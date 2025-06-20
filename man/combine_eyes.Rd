% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/combine_eyes.R
\name{combine_eyes}
\alias{combine_eyes}
\title{Combine binocular data into single X/Y coordinate pairs}
\usage{
combine_eyes(data, method = "average")
}
\arguments{
\item{data}{raw data with columns time, left_x, left_y, right_x, right_y, and trial}

\item{method}{either "average" or "best_eye" - see description.}
}
\value{
a dataframe of x-2 variables (with left_x and right_x condensed to x, and left_y and right_y condensed to y) and the same number of observations as the input data
}
\description{
Combines the data from binocular samples into X/Y coordinate pairs. Two
methods can be used: "average" or "best_eye". For "average", the result is based on the average of the two eyes for each sample,
or for samples where there is data from only a single eye, that eye is used. For "best_eye", a summary of the proportion of missing samples
is computed, and the eye with the fewest missing samples is used.
}
\examples{
combine_eyes(HCL, method = "average")

}
