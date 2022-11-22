box::use(
  R6[R6Class],
  glue[glue, glue_sql],
  dplyr[...],
  pool[dbPool, dbExecute, dbReadTable, poolClose, dbAppendTable, dbGetQuery,
       poolWithTransaction, poolCheckout, poolReturn, dbWithTransaction],
  purrr[map, walk]
)
#' R6 Class to manage DBs
#'
#' @title Database Connection Manager
#' @description Database manager is an R6 class object that is responsible
#' for handling DB connection and performing queries.
#'
#' @name DatabaseManager
#'
#' @section Constructor: DatabaseManager$new(...)
#'
#' @section Constructor Arguments:
#' @param ... all connection arguments required for the particular DB engine
#' @section Public Methods:
#' * initialize() initialize connection
#' * disconnect() close connection
#' * get_connection() get connection
DatabaseManager <- R6Class( #nolint
  "DatabaseManager",
  private = list(
    connection = "connection",
    get_schema_from_parameters = function(...) {
      parameters <- (...)
      if ("schema" %in% names(parameters)) {
        message(
          sprintf("Setting schema: %s", parameters$schema)
        )
        parameters$schema
      } else {
        warning(
          sprintf("Schema was not provided, using public as default")
        )
        "public"
      }
    },
    connect = function(...) {
      private$connection <- do.call(dbPool, (...))
      self$set_schema()
      message("Opening DB connection")
    }
  ),
  public = list(
    schema = NULL,
    #' @description Create a new DB connection
    #' @param ... Arguments needed for both DBI::dbConnect()
    #' @return
    initialize = function(...) {
      self$schema <- private$get_schema_from_parameters(...)
      private$connect(...)
    },
    set_schema = function() {
      set_schema <- glue("SET search_path TO \"{self$schema}\";")
      dbExecute(
        conn = private$connection,
        statement = set_schema
      )
    },
    get_schema = function() {
      self$schema
    },
    disconnect = function() {
      message("Closing DB connection")
      poolClose(private$connection)
    },
    #' @description Get connection
    #' @return
    get_connection = function() {
      private$connection
    }
  )
)

#' @export
db_manager <- DatabaseManager$new
