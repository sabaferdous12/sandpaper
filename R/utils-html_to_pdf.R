html_to_pdf <- function(input, output = fs::path_ext_set(input, "pdf"), ...) {
  rlang::check_installed("pagedown")

  chrome_available <- check_chrome_available()
  if (!chrome_available) {
    return(invisible(FALSE))
  } else {
    cli::cli_text("Converting {.file {basename(input)}} to {.file {basename(output)}}")
    try_chrome_print(input = input, output = output, ...)
  }
  invisible(file.exists(output))
}

try_chrome_print <- function(input, output, ...) {
  tryCatch({
    pagedown::chrome_print(input = input, output = output, format = "pdf", ...)
  }, error = function(e) {
    cli::cli_warn(c(
      "x" = "chrome_print failed to write {.file {basename(output)}} with the following error:",
      " " = "{.emph '{e$message}'}"
    ))
  })
}

check_chrome_available <- function() {
  browser <- find_browser()
  chrome_available <- utils::file_test("-x", browser)
  if (!chrome_available) {
    cli::cli_warn(c(
      "x" = "Chrome is not available on your system.",
      " " = "Please install Chrome and try again.",
      "i" = "See https://www.google.com/chrome/ for more information."
    ))
  }
  chrome_available
}

find_browser <- function() {
  ## Adapted from https://github.com/rstudio/pagedown/blob/466c1c1e8fc4a679aeff25bdd19fd834c0b78bbd/R/chrome.R#LL78C3-L82C4
  if (is.na(browser <- Sys.getenv("PAGEDOWN_CHROME", NA))) {
    browser <- pagedown::find_chrome()
  }
  browser
}
