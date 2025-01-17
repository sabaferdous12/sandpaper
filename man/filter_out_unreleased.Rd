% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils-releases.R
\name{filter_out_unreleased}
\alias{filter_out_unreleased}
\title{Filter out unreleased episodes}
\usage{
filter_out_unreleased(episodes, lesson_config)
}
\arguments{
\item{episodes}{A character vector of file paths}

\item{lesson_config}{A list of lesson configuration, as returned by \code{\link[=get_config]{get_config()}}}
}
\value{
A character vector of file paths, excluding unreleased episodes
}
\description{
Filter out unreleased episodes
}
\details{
The \code{lesson_config} list is expected to have a \code{releases} component, which is a named list of
episodes, with the names being the release dates in the format \code{YYYY-MM-DD}. This function
filters out any episodes that are scheduled to be released in the future.

The lessons \code{config.yaml} file is expected to have a \code{releases} component, with the following structure:

\if{html}{\out{<div class="sourceCode yaml">}}\preformatted{releases:
   "2024-05-01": introduction.Rmd
   "2025-05-01":
     - not-yet-released.Rmd
     - not-yet-released-2.Rmd
}\if{html}{\out{</div>}}
}
\keyword{internal}
