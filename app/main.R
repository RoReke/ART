box::use(
  shiny[...],
  shinyjs[useShinyjs],
  shiny.router[...],
)

box::use(
  view = app/view,
  app/logic/db_manager[db_manager],
)

# Read constants file
constants <- config::get(file = "./app/constants/constants.yml")

# Read environment variables
DB_SOURCE <- Sys.getenv("DB_SOURCE", unset = "local") #nolint

if (DB_SOURCE %in% constants$valid_db_sources) {
  # setup database connection
  ## get db credentials for the selected db source
  db_credentials <- config::get(
    value = DB_SOURCE,
    file = "./app/database/credentials.yml"
  )
  ## initialize db manager
  db_manager_instance <- db_manager(db_credentials)
}


ns <- NS("app")

# Create router and provide routing path and UI for this page.
router <- make_router(
  default = route(
    constants$routes$home_page$route,
    view$home_page$ui(ns("home_page"), constants)
  )
)

options(shiny.router.debug = FALSE)

# Create output for router in main UI of Shiny app.
#' @export
ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    title = "A R T Cobertura",
    useShinyjs(),
    view$header$ui(ns("header"), constants)#,
    #div(router$ui, style = "margin-top: 5px;")
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {

    # Plug router into Shiny server.
    router$server(input, output, session)

  })
}

onStop(function() {
  db_manager_instance$disconnect()
})
