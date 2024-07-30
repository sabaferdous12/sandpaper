## Create a temporary local lesson
local_lesson <- function(..., envir = parent.frame()) {
  tmpdir <- withr::local_tempdir(.local_envir = envir)
  suppressMessages({
    utils::capture.output({
      lsn <- create_lesson(tmpdir, open = FALSE, ...)
    })
  })
  lsn
}
