% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ESM_Evaluation.R
\name{ESM_Response.Plot}
\alias{ESM_Response.Plot}
\title{Produce response plots for ESMs}
\usage{
ESM_Response.Plot(ESM.Mod, ESM.ensembleMod, fixed.var.metric = "median")
}
\arguments{
\item{ESM.Mod}{The object returned by \code{\link{ESM_Modeling}}.}

\item{ESM.ensembleMod}{The object returned by \code{\link{ESM_Ensemble.Modeling}}.}

\item{fixed.var.metric}{Either 'median' (\emph{Default}), 'mean', 'min' or 'max' specifying the statistic used 
to fix as constant the remaining variables when the predicted response is estimated for one of the variables.}
}
\value{
A plot of the response curves is produced (red line Ensemble, other colour lines are for single algorithms) and a \code{list} with the output is provided.
}
\description{
This function creates response plots (evaluation strips) for Ensembles of Small Models (ESMs).
}
\details{
This function plots the response curves of a model for each variable, while keeping the remianing variables constant. 
This is an adaptation of the Evaluation Strip method proposed by Elith et al.(2005).
}
\references{
Elith, J., Ferrier, S., Huettmann, FALSE. & Leathwick, J. R. 2005 The evaluation strip: A new and robust method for plotting predicted 
responses from species distribution models. Ecological Modelling 186, 280-289.
}
\seealso{
\code{\link{ESM_Modeling}}, \code{\link{ESM_Ensemble.Modeling}}
}
\author{
Flavien Collart \email{flaviencollart@hotmail.com} from the code of Frank Breiner.
}
