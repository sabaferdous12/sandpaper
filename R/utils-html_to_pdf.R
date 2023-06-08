html_to_pdf <- function(input, output = fs::path_ext_set(aio, "pdf"), ...) {
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

try_chrome_print <- function(input, output, format, ...) {
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
  browser <- pagedown::find_chrome()
  if (!file.exists(browser)) browser <- Sys.which(browser)
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
