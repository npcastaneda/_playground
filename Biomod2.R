##################################################
# MULTI-SPECIES DISTRIBUTION MODELING WITH BIOMOD2
##################################################
require(biomod2)
require(raster)
require(snowfall)

############## Initialisation ##############
dir <- "D:/CWR/Biomod2/Test.apr.19.2013"
setwd(dir)

# 1. loading species occurrences data

DataSpecies <- read.csv( system.file("external/species/mammals_table.csv", package="biomod2"))
head(DataSpecies)
plot(DataSpecies$X_WGS84,DataSpecies$Y_WGS84)

# 2. loading environmental data
# Environmental variables extracted from Worldclim (bio_3, bio_4, bio_7, bio_11 & bio_12)

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
plot(myExpl)

# 3. Running the models with lapply function

MyBiomodSF <- function(sp.n){
  myRespName = sp.n
  cat('\n',myRespName,'modeling...')
  
  ### definition of data
  ## i.e keep only the column of our species
  myResp <- as.numeric(DataSpecies[,myRespName])
  myRespCoord = DataSpecies[c('X_WGS84','Y_WGS84')]
  ### Initialisation
  myBiomodData <- BIOMOD_FormatingData(resp.var = myResp,
                                       expl.var = myExpl,
                                       resp.xy = myRespCoord,
                                       resp.name = myRespName)
  
  ### Options definition
  myBiomodOption <- BIOMOD_ModelingOptions()
  ### Modelling
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
  
  ### save models evaluation scores and variables importance on hard drive
  capture.output(getModelsEvaluations(myBiomodModelOut),
                 file=file.path(myRespName,
                                paste(myRespName,"_formal_models_evaluation.txt", sep="")))
  capture.output(getModelsVarImport(myBiomodModelOut),
                 file=file.path(myRespName,
                                paste(myRespName,"_formal_models_variables_importance.txt", sep="")))
  
  ### Building ensemble-models
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
  
  ### Make projections on current variable
  myBiomodProj <- BIOMOD_Projection(
    modeling.output = myBiomodModelOut,
    new.env = myExpl,
    proj.name = 'current',
    selected.models = 'all',
    binary.meth = 'TSS',
    compress = 'xz',
    clamping.mask = F,
    output.format = '.grd')
  ### Make ensemble-models projections on current variable
  myBiomodEF <- BIOMOD_EnsembleForecasting(
    projection.output = myBiomodProj,
    EM.output = myBiomodEM,
    binary.meth = 'TSS')
}

# define the species of interest
sp.names <- c("ConnochaetesGnou", "GuloGulo", "PantheraOnca", "PteropusGiganteus",
              "TenrecEcaudatus", "VulpesVulpes")

myLapply_SFModelsOut <- lapply( sp.names, MyBiomodSF)

############## Ensemble modeling ##############
# 004 Projection
# 005 Ensemble forecasting