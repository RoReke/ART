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

#Create change log table
dbGetQuery(
  conn = con,
  glue("CREATE TABLE IF NOT EXISTS {SCHEMA}.cobertura
    (
      id uuid,
      PERIODO int,
      PERIODO_FECHA int,
      CART int,
      ASEGURADORA varchar(50),
      PROVINCIADGI int,
      PROVINCIA varchar(50),
      SECCION int,
      SECCION_DESC varchar(50),
      GRUPO int,
      GRUPO_DESC varchar(50),
      CIIU int,
      CIIU_desc varchar(50),
      TAMAÑOAGRU_UP varchar(50),
      TAMAÑOAGRU_D varchar(50),
      TIPO_EMPLEADOR varchar(50),
      Tipo_empleador_desc varchar(50),
      EMPLEADORES int,
      CANTTRABAJADORES_UP int,
      CANTTRABAJADORES_D int,
      REMUNERACION numeric,
      CUOTAFFE numeric,
      CUOTADOMESTICOS numeric,
      RECAUDADA_UP numeric,
      RECAUDADA_CP numeric
    );"
  )
)

