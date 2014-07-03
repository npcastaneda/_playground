require(rgdal)
require(raster)
require(phyloclim)

####CALCULATE PREDICTED NICHE OCCUPANCY######

###Path_models####
path_model<-"/mnt/workspace_cluster_6/ccsosa/Hel_models"


####Bioclim paths####
biocl<- c("/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_1.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_2.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_3.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_4.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_5.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_6.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_7.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_8.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_9.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_10.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_11.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_12.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_13.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_14.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_15.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_16.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_17.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_18.asc",
"/mnt/workspace_cluster_6/ccsosa/bio_2_5m/bio_19.asc"
)

#####doing empty list####
pno_list<-list()

###Run pno function###
for(i in 1:length(biocl)){

pno_list[[i]]<-pno(biocl[i],path_model,bin_width = 1,bin_number = 50, subset = NULL)

}


####output dir###
pno_dir<-"/mnt/workspace_cluster_6/ccsosa/PNO"


####Save files in csv####
for(i in 1:length(pno_list)){

  write.csv(pno_list[[i]],paste(pno_dir,"/","PNO_RESULTS_BIO","_",i,".csv",sep=""))
} 


########plot PNO#####

plotPNO(pno_list[[1]],legend.pos = "topleft")





 