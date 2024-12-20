% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ESM_Modeling.R
\name{ESM_Modeling}
\alias{ESM_Modeling}
\title{Ensemble of Small Models: Calibration of Bivariate Models}
\usage{
ESM_Modeling(
  resp,
  xy,
  env,
  sp.name,
  models,
  models.options = NULL,
  prevalence = 0.5,
  cv.method = "split-sampling",
  cv.rep = 10,
  cv.ratio = 0.7,
  cv.n.blocks = NULL,
  cv.split.table = NULL,
  which.biva = NULL,
  parallel = FALSE,
  n.cores = 1,
  modeling.id = as.character(format(Sys.time(), "\%s")),
  pathToSaveObject = getwd(),
  save.models = TRUE,
  save.obj = TRUE
)
}
\arguments{
\item{resp}{\code{numeric} of 0-1. 0 the species si absent and 1 when present.}

\item{xy}{\code{matrix} or \code{data.frame} containing the X and Y coordinate of the species.}

\item{env}{\code{matrix}, \code{data.frame} or \code{SpatRaster} of the species predictors.}

\item{sp.name}{\code{character}. Name of the species (To generate of ESM folder with this name).}

\item{models}{\code{character} of the wanted algorithm methods. Can be c("ANN","CTA","GLM","GBM","MAXNET) or a subset of these 5 techniques.}

\item{models.options}{\code{NULL} or the output from \code{\link{ESM_Models.Options}}}

\item{prevalence}{\code{NULL} or a \code{numeric} comprised between 0-1. Prevalence value is used to build 
'weighted response weights'. The default is 0.5 (weighting presences equally to the absences). 
If \code{NULL} each observation (presence or absence) has the same weight (independent of the number of presences and absences). 
Note that it is not applicable for MAXNET.}

\item{cv.method}{\code{character}. Either "split-sampling", "block" or "custom". "split-sampling" corresponds 
to a repeated split-sampling cross-validations where a percentage of presences and absences, randomly selected 
for each run, are used to train the model and the remaining to test it. "block" corresponds to a k-fold cross-validations 
but where the presences (and absences) are equally split into the k blocks. If "custom", cv.split.table should be provided.}

\item{cv.rep}{\code{numeric}. Number of replicates used for the split-sampling. Only applicable when cv.method="split-sampling".}

\item{cv.ratio}{\code{numeric} betweem 0 and 1.Ratio of the dataset used to trained the model. Only applicable when cv.method="split-sampling".}

\item{cv.n.blocks}{\code{numeric}. Number of wanted blocks (k-fold cross-validation). Only applicable when cv.method = "block.}

\item{cv.split.table}{a \code{matrix} or a \code{data.frame} filled with TRUE/FALSE to specify which part of data must be used for models calibration (TRUE) 
and for models validation (FALSE). Each column corresponds to a 'RUN' and should be named "RUNX" where X correspond to the number of the run. 
The last column should be filled with only TRUE and named "Full" to make a full model used for the future projection. Only applicable when cv.method="custom".}

\item{which.biva}{\code{numeric}. which bivariate combinations should be used for modeling. \emph{Default}: \code{NULL}, 
meaning that all the combinations will be made.}

\item{parallel}{\code{logical}. Allows or not parallel job using the function parallel::makeCluster.}

\item{n.cores}{\code{numeric}. Number of cores used to make the models.}

\item{modeling.id}{\code{character}. the ID (=name) of modeling procedure. A random number by default.}

\item{pathToSaveObject}{a \code{character} of a full path to store the objects. \emph{Default}: Takes the value from getwd().}

\item{save.models}{\code{logical}. Allows or not to save all the bivariate models. If \code{FALSE}, only the full models will be 
saved to make the projections possible.}

\item{save.obj}{\code{logical}. Allows or not to save the final output.}
}
\value{
\itemize{
a \code{list} containing: 
\item{data}: a \code{list} with the object resp, xy, env.var and sp.name. env.var is = to the data supplied in the argument env. 
If env, was a SpatRaster, it corresponds to the extracted values of these rasters.
\item{model.info}: a \code{list} of the models used (models), their options (model.options), the combination of bivariate models (which.biva), 
the failed models (failed.mod), the modeling ID (modeling.id), the prevalence argument and, the path to the folder where are the stored the models (biva.path).
\item{cv.split.table}: a \code{matrix} used to train and test models. See explanation of the argument cv.split.table.
\item{cv.method }: a \code{character} corresponding to the used cross-validation method.
\item{biva.predictions}: a \code{list} of the predictions of all the runs for each bivariate models.
\item{biva.evaluations}: a \code{list} of the evaluation of each bivariate model runs. The evaluation of the full model correspond 
to the mean of all the runs. Note that if one of the run has a Boyce = NA, we will consider this has a 0 when averaging.
\item{biva.calibration}: a \code{list} of the calibration power of each bivariate model runs including the full model.
}
}
\description{
Model species distribution based on the method Ensemble of Small Models (ESM) Evaluate also each bivariate models.
}
\details{
\describe{
The basic idea of ensemble of small models (ESMs) is to model a species distribution based on small, simple models, 
for example all possible bivariate models (i.e. models that contain only two predictors at a time out of a larger set of predictors), 
and then combine all possible bivariate models into an ensemble (Lomba et al. 2010; Breiner et al. 2015).

The ESM set of functions could be used to build ESMs using simple bivariate models which are averagedusing weights based on model performances. 
They provide full functionality of the approach described in Breiner et al. (2015).

The argument which.biva allows to split model runs, e.g. if which.biva is 1:3, only the three first bivariate variable combinations will be modeled. 
This allows to run different biva splits on different computers. However, it is better not to use this option if all models are run on a single computer.
}
}
\examples{
\donttest{library(ecospat)
#Loading test data
data(ecospat.testNiche.inv)
inv <- ecospat.testNiche.inv
#species occurrences
xy <- inv[,1:2]
resp <- inv[,11]
env <- inv[,3:5]
### Calibration of simple bivariate models
my.ESM <- ESM_Modeling(resp = resp,
                       xy=xy,
                       env=env,
                       sp.name = "test",
                       models = c("GLM"),
                       models.options = NULL,
                       prevalence = 0.5,
                       cv.method = "split-sampling",
                       cv.rep = 2,
                       cv.ratio = 0.7,
                       parallel = FALSE)
                       
# Performances of each bivariate model
my.ESM$biva.evaluations

### Ensemble models using a weighted mean based on maxTSS
my.ESM_EF <- ESM_Ensemble.Modeling(my.ESM,
                                   weighting.score=c("MaxTSS"),
                                   threshold=0)
                                   
## Performances of the ensemble across the replicates
## The full model evaluation corresponds to the mean value across the replicates
my.ESM_EF$evaluations

### Evaluation of the ensemble models based on the pooling procedure 
### as recommended in Collart & Guisan (2023)
eval <- ESM_Pooling.Evaluation(ESM.Mod = my.ESM,
                               ESM.ensembleMod = my.ESM_EF,
                               EachSmallModels = FALSE)
                               
## Performances of the ensemble
eval$ESM.evaluations

### Predictions of each bivariate model into a new space
proj <- ESM_Projection(ESM.Mod = my.ESM,
                       new.env = env,
                       name.env = "current",
                       parallel = FALSE)


### Ensemble predictions
Ens.proj <- ESM_Ensemble.Projection(ESM.proj = proj,
                                   ESM.ensembleMod = my.ESM_EF,
                                   save.obj = TRUE)

### thresholds to produce binary maps
my.ESM_thresholds <- ESM_Threshold(my.ESM_EF)


### Binary Projection based on max TSS of calibrated ESMs into new space                                                
my.ESM_EFproj_current_binary <- (Ens.proj > 
                                (my.ESM_thresholds$TSS.th*1000))*1

### get the variable contributions of ESMs
ESM_Variable.Contributions(my.ESM,my.ESM_EF) 

### get the response plots of ESMs
my.ESM_responsePlot<- ESM_Response.Plot(my.ESM,
                                        my.ESM_EF,
                                        fixed.var.metric = 'mean')
                                        
#To avoid a note: DO NOT RUN 
unlink("ESM.output_test", recursive = TRUE)
}
}
\references{
Lomba, A., L. Pellissier, C.F. Randin, J. Vicente, F. Moreira, J. Honrado and A. Guisan. 2010. Overcoming the rare species 
modelling paradox: A novel hierarchical framework applied to an Iberian endemic plant. \emph{Biological Conservation}, \bold{143},2647-2657.

Breiner F.T., A. Guisan, A. Bergamini and M.P. Nobis. 2015. Overcoming limitations of modelling rare species by using ensembles of small models. \emph{Methods in Ecology and Evolution}, \bold{6},1210-1218.

Breiner F.T., Nobis M.P., Bergamini A., Guisan A. 2018. Optimizing ensembles of small models for predicting the distribution of species with few occurrences. \emph{Methods in Ecology and Evolution}. \doi{10.1111/2041-210X.12957}
}
\seealso{
\code{\link{ESM_Projection}}, \code{\link{ESM_Ensemble.Modeling}},   \code{\link{ESM_Ensemble.Projection}}, 
\code{\link{ESM_Pooling.Evaluation}}
}
\author{
Flavien Collart \email{flaviencollart@hotmail.com} based on the previous code written by Frank Breiner 
and Mirko Di Febbraro with the contributions of Olivier Broennimann and Flavien Collart
}
