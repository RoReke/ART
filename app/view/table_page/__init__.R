box::use(
  shiny[moduleServer, NS, div, h3, hr, fluidPage, titlePanel]
)

#' @export
ui <- function(id, constants) {
  ns <- NS(id)

  fluidPage(
    titlePanel(h3(constants$routes$table$page_title, align = "center"))
  )
}

#' @export
server <- function(id, constants,
                   db_manager_instance, rv, state_manager, user) {
  moduleServer(id, function(input, output, session) {
  })
}
