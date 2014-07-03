# load the library
library(biomod2)
require(raster)
require(dismo)
#spList <- read.table("clipboard")
#names(spList)
#spList <- spList$V1
#spList <- as.list(spList)
#spList[1]

#spList <- as.data.frame(spList)

#C:/Users/ccsosa/Desktop/logos/


#dir <- "C:/Users/ccsosa/Music/Pop/Diego Torres/gap_ficus/biomod_modeling/native-areas/asciigrids"

#for(sp in spList){
  #path = paste(dir,"/",sp,sep="")
  #dir.create(path)
#}

# load our species raster
# we consider only the presences of Myocastor coypus species
 #myResp.ras <- raster("G:/Capas/CAPAS COLOMBIA ASCII/Colombia_Raster.asc")

#myResp.ras2 <- list.files("/usr/gap_anal/pruebas_20052013/nareas/",pattern=".asc",full.names=T)
setwd("/curie_data2/ncastaneda/cluster_variables/pruebas_aposteriori_20052013/results")

#setwd("/usr/gap_anal/pruebas_20052013/results2/")
myResp.ras2 <- list.files("/curie_data2/ncastaneda/cluster_variables/pruebas_aposteriori_20052013/nareas",pattern=".asc",full.names=T)
myResp.ras <- raster(myResp.ras2[[8]])

# extract the presences data
# the name
myRespName <- "Solanum_boliviense"
# the XY coordinates of the presence
#myRespXY <- read.csv("G:/Capas/CAPAS COLOMBIA ASCII/prueba102052013.csv",header=T,sep=",")
#myRespXY <- read.csv("/usr/gap_anal/pruebas_20052013/occurrences/Solanum_boliviense.csv",header=T,sep=",")
myRespXY <- read.csv("/curie_data2/ncastaneda/cluster_variables/pruebas_aposteriori_20052013/occurrences/Solanum_boliviense.csv",header=T,sep=",")




#myRespXY<-myRespXY[1:27,2:3]
myRespXY<-myRespXY[,1:3]
myRespXY<-subset(myRespXY[,2:3],myRespXY$Taxon=="Solanum_boliviense")
dups <- duplicated(myRespXY[])
myRespXY <- myRespXY[!dups, ]
myRespXY<-myRespXY[,1:2]
myRespXY<-gridSample(myRespXY,myResp.ras,1)
#group <- kfold(myRespXY, 5)
#pres_train <- myRespXY[group != 1, ]
#pres_test <- myRespXY[group == 1, ]
#c<-rep(1,length(pres_train[,1]))
#pres_train<-cbind(pres_train,c)
#pres_train[,3]<-myRespName


# and the presence data
myResp <- extract(x=myResp.ras, y=myRespXY)
myRespXY<-cbind(myRespXY,myResp)
colnames(myRespXY)<-c("long","lat",myRespName)              
myRespXY<-na.omit(myRespXY)
myRespXY<-SpatialPoints(myRespXY[,1:2])
#myResp2 <- extract(x=myResp.ras, y=pres_test)
 # pres_train[,3]<-rep(1,length(pres_train[,1]))
 # colnames(pres_train)<-c("long","lat",myRespName)
#pres_test[,3]<-rep(1,length(pres_test[,1]))
#colnames(pres_test)<-c("long","lat",myRespName)


#myRespXY2<-SpatialPoints(pres_train)




#######
#c2<-c(-90,50,0)
#myResp3<-rbind(pres_test,c2)

#colnames(myResp3)<-c("long","lat","H_paradoxus")


#eval_test<-myResp3[,1:3]

#ex<-extract(myExpl,myResp3[,1:2])
#ex2<-extract(myExpl,pres_test[,1:2])

#eval_test2<-extract(myExpl,pres_test)


# load the environmental raster layers (could be .img, ArcGIS
# rasters or any supported format by the raster package)
# Environmental variables extracted from Worldclim (bio_3, bio_4,
# bio_7, bio_11 & bio_12)
myExpl<-list.files("/curie_data2/ncastaneda/cluster_variables/pruebas_aposteriori_20052013/clim/Solanum_boliviense-clim",pattern=".asc",full.names=T)
#myExpl<-list.files("/usr/gap_anal/pruebas_20052013/clim/Ipomoea_grandifolia-clim/",pattern=".asc",full.names=T)
myExpl<-lapply(myExpl,raster)
myExpl = stack(myExpl)
#myExpl<-setMinMax((myExpl))

#myExpl2<-c("/usr/gap_anal/pruebas_20052013/clim/Ipomoea_grandifolia-clim/bio_2.asc",
        #   "/usr/gap_anal/pruebas_20052013/clim/Ipomoea_grandifolia-clim/bio_3.asc",
         #  "/usr/gap_anal/pruebas_20052013/clim/Ipomoea_grandifolia-clim/bio_4.asc",
         #  "/usr/gap_anal/pruebas_20052013/clim/Ipomoea_grandifolia-clim/bio_8.asc",
        #   "/usr/gap_anal/pruebas_20052013/clim/Ipomoea_grandifolia-clim/bio_13.asc",
        #   "/usr/gap_anal/pruebas_20052013/clim/Ipomoea_grandifolia-clim/bio_14.asc",
       #    "/usr/gap_anal/pruebas_20052013/clim/Ipomoea_grandifolia-clim/bio_15.asc",
        #   "/usr/gap_anal/pruebas_20052013/clim/Ipomoea_grandifolia-clim/bio_18.asc",
       #    "/usr/gap_anal/pruebas_20052013/clim/Ipomoea_grandifolia-clim/bio_19.asc")

myExpl2<-c("/curie_data2/ncastaneda/cluster_variables/pruebas_aposteriori_20052013/clim/Solanum_boliviense-clim/bio_2.asc",
           "/curie_data2/ncastaneda/cluster_variables/pruebas_aposteriori_20052013/clim/Solanum_boliviense-clim/bio_3.asc",
           "/curie_data2/ncastaneda/cluster_variables/pruebas_aposteriori_20052013/clim/Solanum_boliviense-clim/bio_8.asc",
           "/curie_data2/ncastaneda/cluster_variables/pruebas_aposteriori_20052013/clim/Solanum_boliviense-clim/bio_14.asc",
           "/curie_data2/ncastaneda/cluster_variables/pruebas_aposteriori_20052013/clim/Solanum_boliviense-clim/bio_15.asc",
           "/curie_data2/ncastaneda/cluster_variables/pruebas_aposteriori_20052013/clim/Solanum_boliviense-clim/bio_18.asc")

myExpl2<-lapply(myExpl2,raster)
myExpl2<-stack(myExpl2)
#myExpl2<-setMinMax((myExpl2))
png(paste(myRespName,"_VIF_Selection.png",sep=""))
plot(myExpl2)
dev.off()
png(paste(myRespName,"_all_layers.png",sep=""))
plot(myExpl)
dev.off()

#myExpl = stack(myExpl[[1]],myExpl[[3]],myExpl[[7]],myExpl[[10]],myExpl[[12]],myExpl[[18]])
#eval_test2<-extract(myExpl,pres_test)###
#H_niv_tephrodes=as.data.frame(rep(1,length(pres_test[,1])))
#colnames(H_niv_tephrodes)<-"presence"
#eval<-cbind(pres_test[,1:2],H_niv_tephrodes)
#cb<-res
#eval_test2<-SpatialPointsDataFrame(pres_test[,1:2],pres_test[,3])
#names(eval_test2)<-myRespName
#abg<-randomPoints(myResp.ras,100,pres_test)
#ab=as.data.frame(rep(NA,length(abg[,1])))
#colnames(abg2)<-colnames(eval)
#c1<-rbind(abg2,eval)
#eval_test2<-SpatialPointsDataFrame(c1[,1:2],as.data.frame(c1[,3]))


#l_2020<-list.dirs("/curie_data2/ncastaneda/cluster_variables/HEPRO/bio_2_5_North_America/2020")
#ccma_2020<-list.files(l_2020[[2]],full.names=T,pattern=".asc")
#ccma_2020<-lapply(ccma_2020,raster);ccma_2020<-stack(ccma_2020)
#ccma_2020 = stack(ccma_2020[[1]],ccma_2020[[3]],ccma_2020[[7]],ccma_2020[[10]],ccma_2020[[12]],ccma_2020[[18]])
#csiro_2020<-list.files(l_2020[[3]],full.names=T,pattern=".asc")
#csiro_2020<-lapply(csiro_2020,raster);csiro_2020<-stack(csiro_2020)
#csiro_2020 = stack(csiro_2020[[1]],csiro_2020[[3]],csiro_2020[[7]],csiro_2020[[10]],csiro_2020[[12]],csiro_2020[[18]])
#hadcm3_2020<-list.files(l_2020[[4]],full.names=T,pattern=".asc")
#hadm3_2020<-lapply(hadcm3_2020,raster);hadcm3_2020<-stack(hadcm3_2020)
#hadcm3_2020 = stack(hadcm3_2020[[1]],hadcm3_2020[[3]],hadcm3_2020[[7]],hadcm3_2020[[10]],hadcm3_2020[[12]],hadcm3_2020[[18]])

setwd("/curie_data2/ncastaneda/cluster_variables/pruebas_aposteriori_20052013/results")
myBiomodData <- BIOMOD_FormatingData(resp.var =  myRespXY,
                                    expl.var = myExpl2,
                                    resp.name = myRespName,
                                    PA.nb.rep = 1,
                                    PA.nb.absences =10000,
                                    PA.strategy = 'random')

myBiomodData2 <- BIOMOD_FormatingData(resp.var =  myRespXY,
                                      expl.var = myExpl,
                                      resp.name = myRespName,
                                      PA.nb.rep = 1,
                                      PA.nb.absences = 10000,
                                      PA.strategy = 'random') 


	####IMAGES OF DATA TO USE###								  
									  
png(paste(myRespName,"Data_to_useVIF_22052013.png"))
plot(myBiomodData)
dev.off()
png(paste(myRespName,"Data_to_use_alllayer22052013.png"))
plot(myBiomodData2)
dev.off()


# 2. Defining MAXENT Mododelling options
myBiomodOption <- BIOMOD_ModelingOptions(
  MAXENT = list( maximumiterations = 500,
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
    models = "MAXENT",
    models.options = myBiomodOption,
    NbRunEval=5,
    DataSplit=75,
    Yweights=NULL,
    do.full.models=T,
     VarImport=3,
    models.eval.meth =  c('KAPPA','TSS','ROC','FAR', 'SR', 'ACCURACY', 'BIAS', 'POD'),
    SaveObj = TRUE,
    rescal.all.models = TRUE)

myBiomodModelOut2 <- BIOMOD_Modeling(
  myBiomodData2,
  models = "MAXENT",
  models.options = myBiomodOption,
  NbRunEval=5,
  DataSplit=75,
  Yweights=NULL,
  do.full.models=T,
  VarImport=3,
  models.eval.meth =  c('KAPPA','TSS','ROC','FAR', 'SR', 'ACCURACY', 'BIAS', 'POD'),
  SaveObj = TRUE,
  rescal.all.models = TRUE)
# let's have a look at different models scores
myBiomodModelEval<-getModelsEvaluations(myBiomodModelOut)
write.csv(myBiomodModelEval,paste(myRespName,"Model_Evaluations",".csv"))
myBiomodModelEval2<-getModelsEvaluations(myBiomodModelOut2)
write.csv(myBiomodModelEval2,paste(myRespName,"Model_Evaluations_alllayers",".csv"))



##myBiomodModelEval["ROC","Testing.data",,,]

###CSV METRICS ###
a<-getModelsVarImport(myBiomodModelOut)
write.csv(a*100,paste(myRespName,"VIF_selection_","variable_importance.csv"))
a2<-getModelsVarImport(myBiomodModelOut2)
write.csv(a2*100,paste(myRespName,"all_layers_","variable_importance.csv"))



# 4. Project our models over studied area###projections###



myBiomomodProj <- BIOMOD_Projection(modeling.output = myBiomodModelOut,
                                    new.env = myExpl2,
                                    proj.name = "Ipomoea_grandifolia_VIF_SET",
                                    selected.models = 'all',
                                    binary.meth = c('KAPPA','TSS','ROC','FAR', 'SR', 'ACCURACY', 'BIAS', 'POD'),
                                    filtered.meth = c('KAPPA','TSS','ROC','FAR', 'SR', 'ACCURACY', 'BIAS', 'POD'),
                                    compress = 'gz',
                                    clamping.mask = T,
                                    do.stack=F)
myBiomomodProj2 <- BIOMOD_Projection(modeling.output = myBiomodModelOut2,
                                    new.env = myExpl,
                                    proj.name = "Ipomoea_grandifolia_all_19",
                                    selected.models = 'all',
                                    binary.meth = c('KAPPA','TSS','ROC','FAR', 'SR', 'ACCURACY', 'BIAS', 'POD'),
                                    filtered.meth = c('KAPPA','TSS','ROC','FAR', 'SR', 'ACCURACY', 'BIAS', 'POD'),
                                    compress = 'gz',
                                    clamping.mask = T,
                                    do.stack=F)
#
# make some plots sub-selected by str.grep argument
png(filename = paste(myRespName,"_VIFSelection_projections",".png"),
    width = 1280, height = 961, units = "px")
plot(myBiomomodProj)
dev.off()


png(filename = paste(myRespName,"_alllayers_projections",".png"),
    width = 1280, height = 961, units = "px")
plot(myBiomomodProj2)
dev.off()
##print variable importance

##Ensemble Modelling###

myBiomodEM <- BIOMOD_EnsembleModeling(
  modeling.output = myBiomodModelOut,
  chosen.models = 'all',
  em.by="all",
  eval.metric = "all",
  #eval.metric.quality.threshold = c(0.7),
  prob.mean = T,
  prob.cv = T,
  prob.ci = T,
  prob.ci.alpha = 0.05,
  prob.median = T,
  committee.averaging = T,
  prob.mean.weight = T,
  prob.mean.weight.decay = 'proportional' )

myBiomodEM2 <- BIOMOD_EnsembleModeling(
  modeling.output = myBiomodModelOut2,
  chosen.models = 'all',
  em.by="all",
  eval.metric = 'all',
  #eval.metric.quality.threshold = c(0.7),
  prob.mean = T,
  prob.cv = T,
  prob.ci = T,
  prob.ci.alpha = 0.05,
  prob.median = T,
  committee.averaging = T,
  prob.mean.weight = T,
  prob.mean.weight.decay = 'proportional' )

b<-getEMeval(myBiomodEM); b2<-getEMeval(myBiomodEM2)
write.csv(b,paste(myRespName,"Ensemble_Model_Evaluations",".csv"))
write.csv(b2,paste(myRespName,"Ensemble_Model_Evaluations_alllayers",".csv"))




# if you want to make custom plots, you can also get the projected map
myCurrentProj <- getProjection(myBiomomodProj)
myCurrentProj2<- getProjection(myBiomomodProj2)
png(filename = paste(myRespName,"VIF_layers","_projections",".png"),
    width = 1280, height = 961, units = "px")
plot(myCurrentProj)
dev.off()

png(filename = paste(myRespName,"all_layers","_projections",".png"),
    width = 1280, height = 961, units = "px")
plot(myCurrentProj2)
dev.off()


####Ensemble Forecasting###



myBiomodEF <- BIOMOD_EnsembleForecasting(
  projection.output = myBiomomodProj,
  EM.output = myBiomodEM,
  binary.meth = c('KAPPA','TSS','ROC','FAR', 'SR', 'ACCURACY'),
  filtered.meth = c('KAPPA','TSS','ROC','FAR', 'SR', 'ACCURACY'))
  

myBiomodEF2 <- BIOMOD_EnsembleForecasting(
  projection.output = myBiomomodProj2,
  EM.output = myBiomodEM2,
  binary.meth = c('TSS','ROC','FAR', 'SR', 'ACCURACY', 'BIAS'),
  filtered.meth = c('TSS','ROC','FAR', 'SR', 'ACCURACY', 'BIAS'))


############################
