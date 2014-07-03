library(raster)
library(dismo)
library(maptools)
library(rgeos)
library(rJava)
library(rgdal)
library(BiodiversityR)
library(gam)
library(stringr)
library(AED)
mywd<-"D:/Evert/MAPFORGEN/Bactris gassipaes/distr modeling"


# current environmental data
setwd("D:/Evert/coverage/LAmrasters")
efiles<-list.files(pattern="asc", full.names=T)
elayers<-stack(efiles)

projection(elayers)<-"+proj=longlat +datum=WGS84"


setwd("D:/Evert/MAPFORGEN/100 FGR/Mapforgen in R/inputlayers/countries")
ctries<-readShapePoly(fn="_Latino_ISO_Code_WGS84_Cut", 
                      proj4string=CRS("+proj=longlat +datum=WGS84"))

# datapoints
setwd(mywd)
bactris<-read.csv("bactris_gasipaes_modelling.csv", header=T)

murt<-bactris
coordinates(murt)<- ~x+y
ov_count<-overlay(murt, ctries)
bactris<-bactris[!is.na(ov_count),]
plot(ctries)
box()
murt<-bactris
coordinates(murt)<- ~x+y
points(murt, col="dark green", pch=20, cex=0.1)
kmlPoints(murt,kmlfile="bactrispoints.kml" ,icon="http://google.com/mapfiles/kml/paddle/red-square-lv.png", name="")

env_val<-extract(elayers, cbind(bactris$x,bactris$y))
bactris<-bactris[!is.na(apply(env_val, 1, sum)),]

# convex hull
largedist<-max(pointDistance(cbind(bactris$x, bactris$y), longlat=F), na.rm=T)
hull<-convHull(cbind(bactris$x, bactris$y),lonlat=T)
ext.hull<-gBuffer(hull@polygons, width=0.1*largedist)
plot(ext.hull, add=T)

# Backgound points
bg<-spsample(ext.hull,10000, type="random")
allcells<-cellFromXY(elayers[[1]],bg)
duplcells<-duplicated(allcells)
bg<-bg@coords[!duplcells, ]
bg2<-as.data.frame(bg)
coordinates(bg2)<- ~x+y
bg2<-overlay(bg2, ctries)
Background<-bg[!is.na(bg2),]
env_val<-extract(elayers, Background)
Background<-Background[!is.na(apply(env_val, 1, sum)),]
env_val<-env_val[!is.na(apply(env_val, 1, sum)),]

# check collinearity current climate
corvif(env_val)
tempo<-env_val[, -19]
corvif(tempo)
tempo<-tempo[, -which(colnames(tempo)=="bio_11")]
corvif(tempo)
tempo<-tempo[, -which(colnames(tempo)=="bio_10")]
corvif(tempo)
tempo<-tempo[, -which(colnames(tempo)=="bio_6")]
corvif(tempo)
tempo<-tempo[, -which(colnames(tempo)=="bio_1")]
corvif(tempo)
tempo<-tempo[, -which(colnames(tempo)=="bio_17")]
corvif(tempo)
tempo<-tempo[, -which(colnames(tempo)=="bio_16")]
corvif(tempo)
tempo<-tempo[, -which(colnames(tempo)=="bio_5")]
corvif(tempo)
tempo<-tempo[, -which(colnames(tempo)=="bio_9")]
corvif(tempo)
tempo<-tempo[, -which(colnames(tempo)=="alt_LAC_2_5min")]
corvif(tempo)
tempo<-tempo[, -which(colnames(tempo)=="bio_12")]
corvif(tempo)


# reatined variables 

# GVIF
# aspect_LAC_2_5min 1.009097
# bio_13            4.099582
# bio_14            4.783770
# bio_15            3.166722
# bio_18            2.376885
# bio_19            3.641701
# bio_2             2.859726
# bio_3             6.839263
# bio_4             7.350434
# bio_8             2.469297
# FAO_globecozone   1.440549
# flow_LAC_2_5min   1.014995
# slope_LAC_2_5min  4.347226
# SOTWIS_soils      1.056144
# TRI_LAC_2_5min    4.752485


gr_p<-kfold(bactris, 5)
back<-Background
back<-back[!is.na(back[,1])&!is.na(back[,2]), ]
gr_b<-kfold(Background, 5)
e1<-list()
e2<-list()
auc_res<-list()
corr_or_not<-vector()

for (m_i in 1:5){
  pres_train<-bactris[, c('x','y')][gr_p!=m_i,]
  pres_test<-bactris[, c('x','y')][gr_p==m_i,]
  backg_train<-as.data.frame(Background[gr_b!=m_i,])
  backg_test<-as.data.frame(Background[gr_b==m_i,])
  
  distm<-geoDist(pres_train, lonlat=T)
  
  #correction spatial bias calculation AUC
  sbcor<-pwdSample(pres_test, backg_test, pres_train, n=1, tr=0.33, lonlat=T)
  pres_test_pwd<-pres_test[!is.na(sbcor[,1]),]
  backg_test_pwd<-backg_test[as.vector(sbcor)[!is.na(as.vector(sbcor))], ]
  colnames(backg_test_pwd)<-c('x', 'y')
  
  # minumum number of 3 testing points retained after spatial bias correction 
  # for which envirnm data available else skip
  
  if (nrow(pres_test_pwd)>=3 & nrow(backg_test_pwd)>=3){
    e1[[m_i]]<-ensemble.test(x=elayers, layer.drops=c(paste('bio_', c(10, 11, 6, 1, 17, 16, 5, 9, 12), sep=""), "alt_LAC_2_5min"), 
                             factors=c("FAO_globecozone", "SOTWIS_soils"), p= pres_train, a = backg_train, pt=pres_test_pwd, at=backg_test_pwd, 
                             DOMAIN=0, MAHAL=0, evaluations.keep=T)
    e2[[m_i]]<-evaluate(model=distm, p=pres_test_pwd, a=backg_test_pwd)
    corr_or_not[m_i]<-0
  } else {
    e1[[m_i]]<-ensemble.test(x=elayers, layer.drops=c(paste('bio_', c(10, 11, 6, 1, 17, 16, 5, 9, 12), sep=""), "alt_LAC_2_5min"), 
                             factors=c("FAO_globecozone", "SOTWIS_soils"), p= pres_train, a = backg_train, pt=pres_test, at=backg_test, 
                             DOMAIN=0, MAHAL=0, evaluations.keep=T)
    e2[[m_i]]<-evaluate(model=distm, p=pres_test, a=backg_test)
    corr_or_not[m_i]<-1}
 
    auc_res[[m_i]]<-sapply(e1[[m_i]][grep(".T$", names(e1[[m_i]]))][e1[[m_i]][grep(".T$", names(e1[[m_i]]))]!='NULL']
                                   , function(x){slot(x,'auc')})
}

setwd(paste(mywd, "/current distribution", sep=""))
auc1<-sapply(e2, function(x){slot(x,'auc')})
auc2<-lapply(auc_res, function(x) t(as.data.frame(x)))
auc3<-auc2[[1]]
for (r in 2:length(auc2)){auc3<-merge(auc3, auc2[[r]], all=T)}
auc3<-round(t(auc3), digits=3)
auc3<-rbind(corr_or_not, round(auc1, digits=3), auc3)
row.names(auc3)[1:2]<-c('Corrected', 'GEODIST')

auc4<-apply(auc3[-c(1,2),],1,function(x){ c(ifelse(mean(x)<mean(auc3[2,]) & wilcox.test(x,auc3[2,])$p.value<=0.01,1, 0), round(wilcox.test(x,auc3[2,])$p.value, digits=3), round(mean(x), digits=3))})
auc4<-t(auc4)
auc4<-rbind(rep(NA, ncol(auc4)), c(rep(NA, (ncol(auc4)-1)), round(mean(auc3[2,]), digits=3)), auc4 )

auc5<- cbind(auc3, auc4)
auc6<-rbind(auc5[1,], auc5[-1,][order(auc5[-1,8]), ])
colnames(auc6)<-c(paste('AUC run', 1:5, sep=""), 'Null Model', 'p-value Wilcoxon', 'Mean AUC')
  
write.csv(auc6, "modelstats.csv")


# current distribution map all environmantal variables
goodMod<-auc6[auc6[,6]==0 & auc6[,7]<0.05 & auc6[,8]>0.5,8]
goodMod<-goodMod[!is.na(goodMod)]
weights<-goodMod/max(goodMod)
names(weights)<-str_sub(names(weights), 1, nchar(names(weights))-2)
if ('GLMS' %in% names(weights)){names(weights)[which(names(weights)=='GLMS')]<-'GLMSTEP'}
mods<-c('MAXENT', 'GBM', 'GBMSTEP', 'RF', 'GLM', 'GLMSTEP', 'GAM', 'GAMSTEP', 'MGCV', 'EARTH', 'RPART', 'NNET', 'FDA', 'SVM', 'SVME', 'BIOCLIM', 'DOMAIN', 'MAHAL')
wgts<-numeric()
for (w in mods){
  wgts[which(mods==w)]<-ifelse(!is.na(weights[w]), weights[w], 0)
  names(wgts)[which(mods==w)]<-w
}

# set minimum and maximum values
for (i in 1:nlayers(elayers)) {
  elayers[[i]] <- setMinMax(elayers[[i]])
}
elayers1<-dropLayer(elayers, c(paste('bio_', c(10, 11, 6, 1, 17, 16, 5, 9, 12), sep=""), "alt_LAC_2_5min"))
env_val<-as.data.frame(env_val)
elayers2<-elayers1
tempras<-elayers2[[which(names(elayers2)=="FAO_globecozone")]]
tempras[!(tempras %in% unique(env_val$FAO_globecozone)[!is.na(unique(env_val$FAO_globecozone))])]<-NA
elayers2[[which(names(elayers2)=="FAO_globecozone")]]<-tempras
tempras<-elayers2[[which(names(elayers2)=="SOTWIS_soils")]]
tempras[!(tempras %in% unique(env_val$SOTWIS_soils)[!is.na(unique(env_val$SOTWIS_soils))])]<-NA
elayers2[[which(names(elayers2)=="SOTWIS_soils")]]<-tempras



ens<-ensemble.raster(x=elayers2, p=bactris[, c('x','y')], a=back, k=0, models.keep=T, 
                     xn= elayers2, ext= ext.hull, RASTER.species.name= 'Bactris', factors=c("FAO_globecozone", "SOTWIS_soils"),
                     ENSEMBLE.decay=1, RASTER.stack.name= 'curr', evaluation.strip=TRUE,
                     formulae.defaults=TRUE, RASTER.models.overwrite=T, threshold.method= 'spec_sens', MAXENT=wgts[1], 
                     GBM=wgts[2], GBMSTEP=wgts[3], RF=wgts[4], GLM=wgts[5], 
                     GLMSTEP=wgts[6], GAM=wgts[7], GAMSTEP=wgts[8], MGCV=wgts[9], EARTH=wgts[10], RPART=wgts[11],
                     NNET=wgts[12], FDA=wgts[13], SVM=wgts[14], SVME=wgts[15], BIOCLIM=wgts[16], DOMAIN=wgts[17], 
                     MAHAL=wgts[18], Yweights='BIOMOD')

# Weights for ensemble forecasting
# MAXENT     GBM GBMSTEP      RF     GLM GLMSTEP     GAM GAMSTEP    MGCV MGCVFIX   EARTH   RPART    NNET     FDA     SVM    SVME BIOCLIM  DOMAIN   MAHAL 
# 0.2021  0.2052  0.2025  0.0000  0.0000  0.2021  0.0000  0.0000  0.1880  0.0000  0.0000  0.0000  0.0000  0.0000  0.0000  0.0000  0.0000  0.0000  0.0000 
# 
# Start of modelling for organism: Bactris
# 
# 
# Bactris: Evaluation with rasterStack: base and calibration data for MAXENT
# 
# class          : ModelEvaluation 
# n presences    : 296 
# n absences     : 7041 
# AUC            : 0.8873147 
# cor            : 0.3350518 
# max TPR+TNR at : 0.3187648 
# |==============================================================================================================================================| 100%
# 
# 
# Bactris: Evaluation with rasterStack: base and calibration data for GBM
# 
# class          : ModelEvaluation 
# n presences    : 296 
# n absences     : 7041 
# AUC            : 0.8718752 
# cor            : 0.2916485 
# max TPR+TNR at : 0.4254036 
# |==============================================================================================================================================| 100%
# 
# 
# stepwise GBM trees (target > 1000)
# [1] 1700
# 
# Bactris: Evaluation with rasterStack: base and calibration data for stepwise GBM
# 
# class          : ModelEvaluation 
# n presences    : 296 
# n absences     : 7041 
# AUC            : 0.9058476 
# cor            : 0.3554887 
# max TPR+TNR at : 0.3838107 
# |==============================================================================================================================================| 100%
# 
# 
# Bactris: Evaluation with rasterStack: base and calibration data for stepwise GLM
# 
# class          : ModelEvaluation 
# n presences    : 296 
# n absences     : 7041 
# AUC            : 0.816196 
# cor            : 0.2344975 
# max TPR+TNR at : 0.5298118 
# |==============================================================================================================================================| 100%
# 
# This is mgcv 1.7-22. For overview type 'help("mgcv-package")'.
# 
# Bactris: Evaluation with rasterStack: base and calibration data for GAM (mgcv package)
# 
# class          : ModelEvaluation 
# n presences    : 296 
# n absences     : 7041 
# AUC            : 0.8416017 
# cor            : 0.2619014 
# max TPR+TNR at : 0.540359 
# |==============================================================================================================================================| 100%
# 
# 
# Bactris: Ensemble evaluation with calibration data
# 
# class          : ModelEvaluation 
# n presences    : 296 
# n absences     : 7041 
# AUC            : 0.880123 
# cor            : 0.3077946 
# max TPR+TNR at : 461.9999 
# 
# Suggested thresholds for absence
# (includes minimum, midpoint and threshold)
# 
# 24, 242.99995, 461.9999
# 
# Suggested thresholds for presence
# (includes threshold, midpoint and maximum)
# 
# 461.9999, 693.99995, 926


jpeg('variables_ensemble_curr_Bactris.jpg',  width=3840, height=3840, quality=200, pointsize = 80)
evaluation.strip.plot(ens$evaluation.strip, model="ENSEMBLE", type="o", col="red")
dev.off()

allmaps<-raster("ensembles/Bactris_ENSEMBLE_curr")
allmaps[allmaps<462]<-NA

ramp<-colorRamp(c(rgb(0,97,0, max=255),rgb(255,255, 0, max=255),rgb(255,34,0, max=255)))

# writeRaster(meanallmaps, filename="ensembles/Bactris_curr", overwrite=T )
KML(allmaps, col=rgb(ramp(seq(0, 1, length = 100)), max = 255), blur=20, file= "ensembles/Bactris_curr.kml", overwrite=T)


#############################################################
# END ######################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################


