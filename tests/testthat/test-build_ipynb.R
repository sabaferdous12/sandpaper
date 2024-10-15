# setup test fixture
{
  tmp <- res <- restore_fixture()
  create_episode("second-episode", path = tmp)
}

test_that("build_episode_ipynb() works", {
  skip_if_not(getRversion() >= "4.2")

  fun_file <- fs::path(tmp, "episodes", "introduction.Rmd")
  skip_if_not(file.exists(fun_file), "episodes/introduction.Rmd not found")

  outfile <- fs::path_ext_set(fs::path_file(fun_file), "ipynb")
  outpath <- fs::path(path_built(fun_file), outfile)
  msg <- paste("Converting", fun_file, "to", outpath)

  res <- build_episode_ipynb(fun_file)

  expect_equal(basename(res), "introduction.ipynb")
  expect_true(file.exists(file.path(outpath)))
})

test_that("ipynb rendering does not happen if content is not changed", {
  skip_if_not(getRversion() >= "4.2")
  skip_on_os("windows")

  ## Build ipynb files a first time
  build_ipynb(res, quiet = TRUE)

  expect_message(out <- capture.output(build_ipynb(res)), "nothing to rebuild")
  expect_length(out, 0)
})

test_that("Resetting jupyter notebooks works", {
  ## Build ipynb files
  build_ipynb(res, quiet = TRUE)
  ipynb <- get_ipynb_files(res)

  expect_equal(out <- reset_ipynb(res), ipynb, ignore_attr = TRUE)
  new_ipynb <- get_ipynb_files(res)
  expect_equal(length(new_ipynb), 0)
})

test_that("ipynb rendering fails gracefully on R < 4.2", {
  skip_if(getRversion() >= "4.2", message = "Test only valid for R < 4.2")

  fun_file <- fs::path(tmp, "episodes", "introduction.Rmd")
  skip_if_not(file.exists(fun_file), "episodes/introduction.Rmd not found")
  expect_error(build_episode_ipynb(fun_file))
})

