####################################################
# TESTING MAXENT IN BIOMOD
####################################################
dir <- "D:/CWR/Biomod2/Test.apr.25.2013"
setwd(dir)


# load the library
library(biomod2)
# load our species raster
# we consider only the presences of Myocastor coypus species
myResp.ras <- raster(system.file("external/species/PantheraOnca.grd",
  package="biomod2"))
# extract the presences data
# the name
myRespName <- 'Panthera'
# the XY coordinates of the presence
myRespXY <- xyFromCell(object=myResp.ras,
                       cell=which(myResp.ras[]>0))
# and the presence data
myResp <- extract(x=myResp.ras, y=myRespXY)
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
myBiomodData <- BIOMOD_FormatingData(resp.var = myResp,
                                     expl.var = myExpl,
                                     resp.xy = myRespXY,
                                     resp.name = myRespName,
                                     PA.nb.rep = 2,
                                     PA.nb.absences = 200,
                                     PA.strategy = 'sre')
#plot(myBiomodData)
# 2. Defining MAXENT Mododelling options
maxentDir = "C:/Users/npcastaneda/Documents/Maxent"
myBiomodOption <- BIOMOD_ModelingOptions(
  MAXENT = list( path_to_maxent.jar = maxentDir,
                 maximumiterations = 200,
                 visible = FALSE,
                 linear = TRUE,
                 quadratic = TRUE,
                 product = TRUE,
                 threshold = TRUE,
                 hinge = TRUE,
                 lq2lqptthreshold = 80,
                 l2lqthreshold = 10,
                 hingethreshold = 15,
                 beta_threshold = -1,
                 beta_categorical = -1,
                 beta_lqp = -1,
                 beta_hinge = -1,
                 defaultprevalence = 0.5))
# 3. Computing the models
myBiomodModelOut <- BIOMOD_Modeling(
  myBiomodData,
  models = c('SRE','RF','MAXENT'),
  models.options = myBiomodOption,
  NbRunEval=1,
  DataSplit=80,
  Yweights=NULL,
  VarImport=3,
  models.eval.meth = c('TSS','ROC'),
  SaveObj = TRUE,
  rescal.all.models = TRUE)
# let's have a look at different models scores
getModelsEvaluations(myBiomodModelOut)
# 4. Project our models over studied area
myBiomomodProj <- BIOMOD_Projection(modeling.output = myBiomodModelOut,
                                    new.env = myExpl,
                                    proj.name = 'current',
                                    selected.models = 'all',
                                    binary.meth = 'ROC',
                                    filtered.meth = 'TSS',
                                    compress = 'xz',
                                    clamping.mask = T,
                                    do.stack=T)
# make some plots sub-selected by str.grep argument
plot(myBiomomodProj, str.grep = 'MAXENT')