#' Filter out unreleased episodes
#'
#' @param episodes A character vector of file paths
#' @param lesson_config A list of lesson configuration, as returned by [`get_config()`]
#'
#' @details
#' The `lesson_config` list is expected to have a `releases` component, which is a named list of
#' episodes, with the names being the release dates in the format `YYYY-MM-DD`. This function
#' filters out any episodes that are scheduled to be released in the future.
#'
#' The lessons `config.yaml` file is expected to have a `releases` component, with the following structure:
#'
#' ```yaml
#' releases:
#'    "2024-05-01": introduction.Rmd
#'    "2025-05-01":
#'      - not-yet-released.Rmd
#'      - not-yet-released-2.Rmd
#' ```
#'
#' @return A character vector of file paths, excluding unreleased episodes
#' @keywords internal
filter_out_unreleased <- function(episodes, lesson_config) {

  releases <- lesson_config$releases
  if (length(releases) == 0) {
    return(episodes)
  }

  today <- Sys.Date()
  release_dates <- as.Date(names(releases))
  unreleased <- unlist(releases[release_dates > today], use.names = FALSE)

  episodes[!fs::path_file(episodes) %in% unreleased]
}
