box::use(
  shiny.router[change_page, get_page, route_link],
  shiny[...],
  shinyWidgets[...],
  glue[glue]
)

#' @export
ui <- function(id, constants) {
  ns <- NS(id)
  fluidRow(
    column(
      width = 2,
      style = "left:5px; margin-top: 10px;",
      dropdown(
        icon = icon("bars"),
        style = "pill",
        tags$ul(
          tags$li(a(href = route_link(
            constants$routes$home_page$route),
            constants$routes$home_page$page_title)
          ),
          tags$li(a(href = route_link(
            constants$routes$table_page$route),
            constants$routes$table_page$page_title)
          )
        )
      )
    ),
    column(
      width = 3,
      offset = 7,
      div(
        style = "right:10px; position:absolute;",
        HTML(
          glue("Fuente: {tags$a('srt.gob.ar/estadisticas', href = 'http://www.srt.gob.ar/estadisticas')}.
               Actualización 08/2022"
          )
        )
      )
    )
  )
}


#' @export
server <- function(id, constants) {
  moduleServer(id, function(input, output, session) {
  })
}
