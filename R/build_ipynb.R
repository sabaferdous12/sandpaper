#' Build ipynb notebooks from the RMarkdown episodes
#'
#' Convert the RMarkdown episodes to Jupyter notebooks using `jupytext`.
#' Only the actual episodes are converted, not the additional pages.
#'
#' @param path the path to your repository (defaults to your current working
#' directory)
#' @param rebuild if `TRUE`, everything will be built from scratch as if there
#' was no cache. Defaults to `FALSE`, which will only build ipynb files that
#' haven't been built before.
#' @param quiet when `TRUE`, output is supressed.
#'
#' @keywords internal
#' @seealso [build_episode_ipynb()]
build_ipynb <- function(path = ".", rebuild = FALSE, quiet = FALSE) {
  if (rebuild) {
    reset_ipynb(path)
  } else {
    create_site(path)
  }

  outdir <- path_built(path)

  ## We only want to build ipynb for the actual episodes
  episodes <- get_episodes(path)
  episode_paths <- fs::path(path_episodes(path), episodes)

  ## Determine episodes to rebuild
  db_path <- fs::path(outdir, "md5sum-ipynb.txt")
  db <- build_status(episode_paths, db_path, rebuild, write = FALSE, format = "ipynb")

  update <- FALSE
  on.exit({if (update) write_build_db(db$new, db_path)}, add = TRUE)

  cli::cli_div(theme = sandpaper_cli_theme())

  needs_building <- fs::path_ext(db$build) %in% c("md", "Rmd")
  if (any(needs_building)) {
    build_me <- db$build[needs_building]

    for (i in seq_along(build_me)) {
      if (!quiet) cli::cli_alert_info("Converting {episodes[i]} to ipynb")
      build_episode_ipynb(path = episode_paths[i], outdir = outdir)
    }
  } else {
    if (!quiet) {
      cli::cli_alert_success("All files up-to-date; nothing to rebuild!")
    }
  }

  cli::cli_end()

  # We've made it this far, so the database can be updated
  update <- TRUE
  invisible(db$build)
}

## Clear existing ipynb files
reset_ipynb <- function(path) {
  check_lesson(path)
  to_delete <- get_ipynb_files(path)
  fs::file_delete(to_delete)
}

get_ipynb_files <- function(path) {
  path <- path_built(path)
  fs::dir_ls(path, glob = "*.ipynb")
}
