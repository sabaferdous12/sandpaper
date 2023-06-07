#' Render pdf from a markdown file
#'
#' This uses [rmarkdown::pandoc_convert()] to render PDF from a markdown file.
#' We've specified pandoc extensions that align with the features desired in the
#' Carpentries
#.
#'
#' @param path_in path to a markdown file
#' @param quiet if `TRUE`, no output is produced. Default is `FALSE`, which
#'   reports the markdown build via pandoc
#' @param ... extra options (e.g. lua filters) to be passed to pandoc
#'
#' @keywords internal
render_pdf <- function(path_in, ..., quiet = FALSE) {
  htm <- paste0(path_in, '.pdf')
  args <- construct_pandoc_args2(path_in, output = htm, to = "pdf", ...)
  callr::r(function(...) rmarkdown::pandoc_convert(...), args = args,
           show = !quiet)

  paste("COME PDF PLEASE", collapse = "\n")
}

construct_pandoc_args2 <- function(path_in, output, to = "pdf", ...) {
  from <- paste0("markdown", "-hard_line_breaks")
  list(
    input   = path_in,
    output  = output,
    from    = from,
    to      = to,
    options = c(
      "--pdf-engine=lualatex",
      paste0("--template=", system.file("pandoc/eisvogel.latex", package = "sandpaper")),
      "--listings",
      ...
    ),
    verbose = FALSE
  )
}
