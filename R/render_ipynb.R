#' Render Jupyter notebook from a markdown file
#'
#' This uses [rmarkdown::pandoc_convert()] to render a Jupyter Notebook from a markdown file.
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
render_ipynb <- function(path_in, ..., quiet = FALSE) {

  # jupytext --to notebook notebook.py
  htm <- paste0("jupytext --to notebook ", path_in)
  # args <- construct_pandoc_args3(path_in, output = htm, to = "ipynb", ...)
  # callr::r(function(...) rmarkdown::pandoc_convert(...), args = args,
  #          show = !quiet)

  # Add a space or not in case we are running on a mac.
  # sed -i for BSD uses a space to set the backup file, whereas
  #        the GNU version doesn't require a space.
  #        If not used `-i` the file is not change in place.
  is_mac <- version$os
  space <- if(grepl("darwin", is_mac)) paste(" ") else paste("")
  remove_lines <- paste0("sed -i", space, "'.bak' '/^::::/d' ", path_in)
  system(remove_lines)
  system(htm)
  paste("COME ipynb PLEASE", collapse = "\n")
}

construct_pandoc_args3 <- function(path_in, output, to = "pdf", ...) {

  from <- paste0("markdown", "-hard_line_breaks")
  lua_filter <- rmarkdown::pkg_file_lua("lesson.lua", "sandpaper")
  list(
    input   = path_in,
    output  = output,
    from    = from,
    to      = to,
    options = c(
      "--preserve-tabs",
      "--indented-code-classes=sh",
      "--section-divs",
      "--mathjax",
      "--listings",
      "--lua-filter",
      lua_filter,
      ...
    ),
    verbose = FALSE
  )
}
