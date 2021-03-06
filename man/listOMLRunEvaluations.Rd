% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/listOMLRunEvaluations.R
\name{listOMLRunEvaluations}
\alias{listOMLRunEvaluations}
\title{List run results of a task.}
\usage{
listOMLRunEvaluations(task.id = NULL, flow.id = NULL, run.id = NULL,
  uploader.id = NULL, tag = NULL, limit = NULL, offset = NULL,
  verbosity = NULL)
}
\arguments{
\item{task.id}{[\code{integer(1)}]\cr
Task ID.}

\item{flow.id}{[\code{integer(1)}]\cr
ID of the implementation of an OpenML flow.}

\item{run.id}{[\code{integer}]\cr
a single ID or a vector of IDs of the runs.}

\item{uploader.id}{[\code{integer(1)}]\cr
ID of the uploader.}

\item{tag}{[\code{character(1)}]\cr
If not \code{NULL} only entries with the corresponding \code{tag}
are listed.}

\item{limit}{[\code{numeric(1)}]\cr
Optional. The maximum number of datasets to return. Without specifying \code{offset}, it returns the first '\code{limit}' datasets.}

\item{offset}{[\code{numeric(1)}]\cr
Optional. The offset to start from. Should be indices starting from 0, which do not refer to IDs. Is ignored when no \code{limit} is given.}

\item{verbosity}{[\code{integer(1)}]\cr
Print verbose output on console? Possible values are:\cr
\code{0}: normal output,\cr
\code{1}: info output,\cr
\code{2}: debug output.\cr
Default is set via \code{\link{setOMLConfig}}.}
}
\value{
[\code{data.frame}].
}
\description{
Retrieves all run results for task(s) (\code{task.id}), flow(s) (\code{flow.id})
run(s) (\code{run.id}) or uploaders(s) (\code{uploader.id} and returns a \code{data.frame}.
Each row contains, among others, the run id \dQuote{rid}. Alternatively the
function can be passed a single \code{tag} to list only runs with the corresponding
tag associated.
}
\note{
This function is memoised. I.e., if you call this function twice in a running R session,
the first call will query the server and store the results in memory while the second and all subsequent calls will return
the cached results from the first call.
You can reset the cache by calling \code{\link[memoise]{forget}} on the function manually.
}
\examples{
\dontrun{
	# get run results of task 6 (as many rows as runs for this task)
	rev_tid6 = listOMLRunEvaluations(task.id = 6L)
	str(rev_tid6)

	# get run results of run 8 (one row)
	rev_rid8 = listOMLRunEvaluations(run.id = 8)
	str(rev_rid8)
}
}

