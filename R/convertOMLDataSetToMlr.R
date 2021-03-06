#' @title Convert an OpenML data set to mlr task.
#'
#' @description
#' Converts an \code{\link{OMLDataSet}} to a \code{\link[mlr]{Task}}.
#'
#' @param obj [\code{\link{OMLDataSet}}]\cr
#'   The object that should be converted.
#' @param task.type [\code{character(1)}]\cr
#'   As we only pass the data set, we need to define the task type manually.
#'   Possible are: \dQuote{Supervised Classification}, \dQuote{Supervised Regression},
#'   \dQuote{Survival Analysis}.
#'   Default is \code{NULL} which means to guess it from the target column in the
#'   data set. If that is a factor, we choose classification. If it is numeric we
#'   choose regression. In all other cases an error is thrown.
#' @param target [\code{character}]\cr
#'   The target for the classification/regression task.
#'   Default is the \code{default.target.attribute} of the \code{\link{OMLDataSetDescription}}.
#' @param ignore.flagged.attributes [\code{logical(1)}]\cr
#'   Should those features that are listed in the data set description slot \dQuote{ignore.attribute}
#'   be removed?
#'   Default is \code{TRUE}.
#' @param drop.levels [\code{logical(1)}]\cr
#'   Should empty factor levels be dropped in the data?
#'   Default is \code{TRUE}.
#' @template arg_verbosity
#' @return [\code{\link[mlr]{Task}}].
#' @family data set-related functions
#' @example /inst/examples/convertOMLDataSetToMlr.R
#' @export
convertOMLDataSetToMlr = function(
  obj,
  task.type = NULL,
  target = obj$desc$default.target.attribute,
  ignore.flagged.attributes = TRUE,
  drop.levels = TRUE,
  verbosity = NULL) {

  assertClass(obj, "OMLDataSet")
  assertChoice(target, obj$colnames.new)
  assertFlag(ignore.flagged.attributes)
  assertFlag(drop.levels)

  data = obj$data
  desc = obj$desc

  # no task type? guess it by looking at target
  if (is.null(task.type)) {
    if (is.factor(data[, target]) | is.logical(data[, target]))
      task.type = "Supervised Classification"
    else if (is.numeric(data[, target]))
      task.type = "Supervised Regression"
    else
      stopf("Cannot guess task.type from data!")
  } else {
    assertChoice(task.type, c("Supervised Classification", "Supervised Regression", "Survival Analysis"))
  }

  #  remove ignored attributes from data
  if (!is.na(desc$ignore.attribute) && ignore.flagged.attributes) {
    inds = which(obj$colnames.old %in% desc$ignore.attribute)
    data = data[, -inds]
  }

  # drop levels
  if (drop.levels)
    data = droplevels(data)

  # get fixup verbose setting for mlr
  if (is.null(verbosity))
    verbosity = getOMLConfig()$verbosity
  fixup = ifelse(verbosity == 0L, "quiet", "warn")

  mlr.task = switch(task.type,
    "Supervised Classification" = makeClassifTask(data = data, target = target, fixup.data = fixup),
    "Supervised Regression" = makeRegrTask(data = data, target = target, fixup.data = fixup),
    "Survival Analysis" = makeSurvTask(data = data, target = target, fixup.data = fixup),
    stopf("Encountered currently unsupported task type: %s", task.type)
  )

  #  remove constant featues
  mlr.task = removeConstantFeatures(mlr.task)
  return(mlr.task)
}

