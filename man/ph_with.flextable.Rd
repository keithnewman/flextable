% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ph_with.R
\name{ph_with.flextable}
\alias{ph_with.flextable}
\title{add a flextable into a PowerPoint slide}
\usage{
\method{ph_with}{flextable}(x, value, location, ...)
}
\arguments{
\item{x}{a pptx device}

\item{value}{flextable object}

\item{location}{a location for a placeholder. See \code{\link[officer]{ph_location_type}}
for example.}

\item{...}{unused arguments.}
}
\description{
Add a flextable in a PowerPoint document object produced
by \code{\link[officer]{read_pptx}}.
}
\note{
The width and height of the table can not be set with \code{location}. Use
functions \code{\link{width}}, \code{\link{height}}, \code{\link{autofit}}
and \code{\link{dim_pretty}} instead. The overall size is resulting from
cells, paragraphs and text properties (i.e. padding, font size, border widths).
}
\examples{
library(officer)

ft = flextable(head(iris))

doc <- read_pptx()
doc <- add_slide(doc, "Title and Content", "Office Theme")
doc <- ph_with(doc, ft, location = ph_location_left())

fileout <- tempfile(fileext = ".pptx")
print(doc, target = fileout)
}