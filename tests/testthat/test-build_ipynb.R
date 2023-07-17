test_that("build_episode_ipynb() works", {
  # Set up test lesson
  tmp <- local_lesson(ipynb = TRUE)

  fun_file <- fs::path(tmp, "episodes", "introduction.Rmd")
  skip_if_not(file.exists(fun_file), "episodes/introduction.Rmd not found")

  outfile <- fs::path_ext_set(fs::path_file(fun_file), "ipynb")
  outpath <- fs::path(path_built(fun_file), outfile)
  msg <- paste("Converting", fun_file, "to", outpath)

  res <- build_episode_ipynb(fun_file)

  expect_equal(basename(res), "introduction.ipynb")
  expect_true(file.exists(file.path(outpath)))
})
