box::use(
  shiny[NS, moduleServer],
  header = ./header,
)

#' @export
ui <- function(id, constants) {
  ns <- NS(id)
  header$ui(ns("header"), constants)
}

#' @export
server <- function(id, constants) {
  moduleServer(id, function(input, output, session) {
    header$server("header", constants)
  })
}
