##################################################
# SINGLE-SPECIES DISTRIBUTION MODELING WITH BIOMOD2
##################################################

# set dir
dir <- "D:/CWR/Biomod2/Test.apr.24.2013"
setwd(dir)

# load the library
library(biomod2)
# load our species data
DataSpecies <- read.csv(system.file("external/species/mammals_table.csv",
                                    package="biomod2"))
head(DataSpecies)

# the name of studied species
myRespName <- 'GuloGulo'
# the presence/absences data for our species
myResp <- as.numeric(DataSpecies[,myRespName])
# the XY coordinates of species data
myRespXY <- DataSpecies[,c("X_WGS84","Y_WGS84")]
# load the environmental raster layers (could be .img, ArcGIS
# rasters or any supported format by the raster package)
# Environmental variables extracted from Worldclim (bio_3, bio_4,
# bio_7, bio_11 & bio_12)
myExpl = stack( system.file( "external/bioclim/current/bio3.grd",
                             package="biomod2"),
                system.file( "external/bioclim/current/bio4.grd",
                             package="biomod2"),
                system.file( "external/bioclim/current/bio7.grd",
                             package="biomod2"),
                system.file( "external/bioclim/current/bio11.grd",
                             package="biomod2"),
                system.file( "external/bioclim/current/bio12.grd",
                             package="biomod2"))
# Formating data
myBiomodData <- BIOMOD_FormatingData(resp.var = myResp,
                                     expl.var = myExpl,
                                     resp.xy = myRespXY,
                                     resp.name = myRespName)
# This is my version
myBiomodData <- BIOMOD_FormatingData(resp.var = myResp,
                      expl.var = myExpl,
                     resp.xy = myRespXY,
                     resp.name = myRespName,
                     eval.resp.var = NULL,
                     eval.expl.var = NULL,
                     eval.resp.xy = NULL,
                     PA.nb.rep = 0,
                     PA.nb.absences = 1000,
                     PA.strategy = 'SRE',
                     PA.dist.min = 0,
                     PA.dist.max = NULL,
                     PA.sre.quant = 0.025,
                     PA.table = NULL,
                     na.rm = TRUE)

# Check the format of your current data
myBiomodData
plot(myBiomodData)
# ----------- OJO: the function BIOMOD_FormatingData prepares the pseudo-abscences of data
# (use preferably: SRE)
#?BIOMOD_FormatingData

# Modeling

#------------ OJO: BIOMOD_ModelingOptions: Use this for setting the parameters of each model
?BIOMOD_ModelingOptions

#------------------------------------------------------
# DO NOT RUN THIS PART!

# default BIOMOD.model.option object
myBiomodOptions <- BIOMOD_ModelingOptions()

# print the object
myBiomodOptions

# you can copy a part of the print, change it and custom your options 
# here we want to compute quadratic GLM and select best model with 'BIC' criterium
myBiomodOptions <- BIOMOD_ModelingOptions(
  GLM = list( type = 'quadratic',
              interaction.level = 0,
              myFormula = NULL,
              test = 'BIC',
              family = 'binomial',
              control = glm.control(epsilon = 1e-08, maxit = 1000, trace = FALSE) ))
#------------------------------------------------------

# 2. Defining Models Options using default options.
myBiomodOption <- BIOMOD_ModelingOptions()

# 3. Computing the models
myBiomodModelOut <- BIOMOD_Modeling(
  myBiomodData,
  models = c('SRE','CTA','RF','MARS','FDA'),
  models.options = myBiomodOption,
  NbRunEval=3,
  DataSplit=80,
  Prevalence=0.5,
  VarImport=3,
  models.eval.meth = c('TSS','ROC'),
  SaveObj = TRUE,
  rescal.all.models = TRUE,
  do.full.models = FALSE,
  modeling.id = paste(myRespName,"FirstModeling",sep=""))

# Modeling summary
myBiomodModelOut

# get all models evaluation
myBiomodModelEval <- getModelsEvaluations(myBiomodModelOut)
# print the dimnames of this object
dimnames(myBiomodModelEval)
# let's print the TSS scores of Random Forest
myBiomodModelEval["TSS","Testing.data","RF",,]
# let's print the ROC scores of all selected models
myBiomodModelEval["ROC","Testing.data",,,]
# print variable importances
getModelsVarImport(myBiomodModelOut)

# Ensamble modeling
myBiomodEM <- BIOMOD_EnsembleModeling(
  modeling.output = myBiomodModelOut,
  chosen.models = 'all',
  em.by='all',
  eval.metric = c('TSS'),
  eval.metric.quality.threshold = c(0.7),
  prob.mean = T,
  prob.cv = T,
  prob.ci = T,
  prob.ci.alpha = 0.05,
  prob.median = T,
  committee.averaging = T,
  prob.mean.weight = T,
  prob.mean.weight.decay = 'proportional' )

# print summary
myBiomodEM

# get evaluation scores
getEMeval(myBiomodEM)

# Model projection
# projection over the globe under current conditions
myBiomodProj <- BIOMOD_Projection(
  modeling.output = myBiomodModelOut,
  new.env = myExpl,
  proj.name = 'current',
  selected.models = 'all',
  binary.meth = 'TSS',
  compress = 'xz',
  clamping.mask = F,
  output.format = '.grd')

# summary of crated projections
myBiomodProj

# files created on hard drive
list.files("GuloGulo/proj_current/")

# make some plots sub-selected by str.grep argument
plot(myBiomodProj, str.grep = 'MARS')

# if you want to make custom plots, you can also get the projected map
myCurrentProj <- getProjection(myBiomodProj)
myCurrentProj

# load environmental variables for the future.
myExplFuture = stack( system.file( "external/bioclim/future/bio3.grd",
                                   package="biomod2"),
                      system.file( "external/bioclim/future/bio4.grd",
                                   package="biomod2"),
                      system.file( "external/bioclim/future/bio7.grd",
                                   package="biomod2"),
                      system.file( "external/bioclim/future/bio11.grd",
                                   package="biomod2"),
                      system.file( "external/bioclim/future/bio12.grd",
                                   package="biomod2"))
myBiomodProjFuture <- BIOMOD_Projection(
  modeling.output = myBiomodModelOut,
  new.env = myExplFuture,
  proj.name = 'future',
  selected.models = 'all',
  binary.meth = 'TSS',
  compress = 'xz',
  clamping.mask = T,
  output.format = '.grd')

# make some plots, sub-selected by str.grep argument
plot(myBiomodProjFuture, str.grep = 'MARS')

# Ensemble forecast
myBiomodEF <- BIOMOD_EnsembleForecasting(
  projection.output = myBiomodProj,
  EM.output = myBiomodEM,
  binary.meth = 'TSS')

proj_current_GuloGulo_TotalConsensus_EMbyTSS <-
  stack("GuloGulo/proj_current/proj_current_GuloGulo_TotalConsensus_EMbyTSS.grd")
proj_current_GuloGulo_TotalConsensus_EMbyTSS

# reduce layer names for plotting convegences
names(proj_current_GuloGulo_TotalConsensus_EMbyTSS) <-
  sapply(strsplit(names(proj_current_GuloGulo_TotalConsensus_EMbyTSS),"_"), tail, n=1)
levelplot(proj_current_GuloGulo_TotalConsensus_EMbyTSS)