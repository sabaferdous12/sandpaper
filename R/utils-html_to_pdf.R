html_to_pdf <- function(input, output) {
  rlang::check_installed("pagedown")

  tryCatch({
    cli::cli_text("Writing '{.file {basename(output)}}'")
    pagedown::chrome_print(input = input, output = output, format = "pdf")
  }, error = function(e) {
    cli::cli_warn(c(
      "x" = "chrome_print failed to write {.file {basename(output)}} with the following error:",
      " " = "{.emph '{e$message}'}",
      "i" = "Do you have Chrome installed?"
    ))
  })
}
