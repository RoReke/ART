box::use(
  DBI[dbExecute, dbListTables, dbDisconnect, dbGetQuery],
  app/logic/db_manager[db_manager],
  glue[glue],
)

# Read constants file
constants <- config::get(file = "app/constants/constants.yml")
# Read environment variables
DB_SOURCE <- Sys.getenv("DB_SOURCE", unset = "local") #nolint
# Schema
SCHEMA <- NULL

if (DB_SOURCE %in% constants$valid_db_sources) {
  # setup database connection
  ## get db credentials for the selected db source
  db_credentials <- config::get(
    value = DB_SOURCE,
    file = "app/database/credentials.yml"
  )
  SCHEMA <- db_credentials$schema
  if (is.null(SCHEMA)) {
    stop("You need to set up a schema for the chosen (DB_SOURCE) entry in credentials.yml")
  }
  ## initialize db manager
  db_manager_instance <- db_manager(db_credentials)
}

con <- db_manager_instance$get_connection()

# Drop table
dbExecute(con, glue("DROP TABLE IF EXISTS {SCHEMA}.cobertura;"))

# Create cobertura table
dbGetQuery(
  conn = con,
  glue("CREATE TABLE IF NOT EXISTS {SCHEMA}.cobertura
    (
      id uuid,
      Aseguradora text,
      Cart int,
      Ciiu int,
      Descripcion text,
      Grupo int,
      Grupo_Desc text,
      Periodo int,
      Periodo_Filtro text,
      PERIODO_FECHA int,
      Provincia text,
      Provinciadgi int,
      Seccion text,
      Seccion_Desc text,
      Tamañoagru_D text,
      Tamañoagru_Up text,
      Tipo_Empleador_Desc text,
      Canttrabajadores_D int,
      Canttrabajadores_Up int,
      Cuotadomesticos numeric,
      Cuotaffe numeric,
      Empleadores int,
      Número_de_registros int,
      Recaudada_Cp numeric,
      Recaudada_Up numeric,
      Remuneracion numeric,
      Tipo_Empleador text
    );"
  ))

db_manager_instance$disconnect()

