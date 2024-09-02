today <- Sys.Date()

test_that("Unreleased episodes are filtered out", {
  episodes <- c("introduction.Rmd", "not-yet-released.Rmd", "not-yet-released-2.Rmd")
  lesson_config <- list(
    releases = list(
      "date1" = "introduction.Rmd",
      "date2" = c("not-yet-released.Rmd", "not-yet-released-2.Rmd")
    )
  )
  ## Set release dates
  names(lesson_config$releases) <- c(today - 1, today + 1)

  filtered_episodes <- filter_out_unreleased(episodes, lesson_config)

  expect_equal(filtered_episodes, "introduction.Rmd")
})


test_that("Release dates are optional", {
  episodes <- c("introduction.Rmd", "episode2.Rmd", "episode3.Rmd")
  lesson_config <- list()

  filtered_episodes <- filter_out_unreleased(episodes, lesson_config)

  expect_equal(filtered_episodes, episodes)
})
