box::use(
  DBI[Id, dbDisconnect, dbAppendTable],
  app/logic/db_manager[db_manager],
  dplyr[mutate, if_else, rename_with],
  magrittr[`%>%`],
  glue[glue],
)

# Read constants file
constants <- config::get(file = "app/constants/constants.yml")
# Read environment variables
DB_SOURCE <- Sys.getenv("DB_SOURCE") #nolint
# Schema
SCHEMA <- NULL

# only append data to database in local or dev environments
if (DB_SOURCE %in% c("local","dev")) {
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


data <- read.csv("./data/cobertura.csv", sep = ";", dec = ",")
data <- rename_with(data, ~ tolower(gsub(".", "_", .x, fixed = TRUE)))
dbAppendTable(
  conn = con,
  name = Id(
    schema= SCHEMA,
    table = "cobertura"
  ),
  value = data
)

db_manager_instance$disconnect()

