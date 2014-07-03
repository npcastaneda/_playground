# Re doing ERS, species richness files and gap files fro all non-priorities
# Oct 2013 N. Castaneda

#-------------------------------------------------------
# Non-priorities processes
# Sept - Oct 2013

cd /curie_data2/ncastaneda/code/gap-analysis-cwr/gap-analysis/gap-code
# cp * /curie_data2/ncastaneda/gap-analysis/gap_groundnut/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_beet/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_cucumber/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_cotton/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_tomato/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_grape/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_maize/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_lettuce/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_adzuki_bean/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_apricot/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_cassava/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_cherry/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_cacao/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_capsicum/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_cabbage/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_soybean/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_strawberry/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_sugar_cane/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_almond/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_garlic/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_grapefruit/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_leek/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_lemon/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_mango/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_melon/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_mung_bean/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_mustard/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_mustard_black/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_onion/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_orange/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_papaya/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_pineapple/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_plum/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_peach/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_pear/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_rape/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_safflower/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_spinach/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_squash_maxima/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_squash_pepo/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_turnip/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_urd_bean/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_asparagus/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_breadfruit/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_cocoyam/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_millet_panicum/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_millet_setaria/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_quinoa/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_yam_lagos/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_yam_water/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_yam_whiteguinea/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_watermelon/_scripts

#-------------------------------------------------------

src.dir <- paste("/curie_data2/ncastaneda/gap-analysis/gap_",crop,"/_scripts",sep="") # !!! change accordingly !!!
gap.dir <-"/curie_data2/ncastaneda/gap-analysis" # !!! change accordingly !!!

#crop details
crop_dir <- paste(gap.dir,"/gap_",crop,sep="")

if (!file.exists(crop_dir)) {dir.create(crop_dir)}
setwd(crop_dir)

# extract variables
require(raster)
eco_dir <- "/curie_data2/ncastaneda/geodata/wwf_eco_terr" # !!! change accordingly !!!

rs <- raster(paste(eco_dir,"/wwf_eco_terr.asc", sep=""))

msk <- raster(paste(crop_dir,"/masks/mask.asc",sep=""))
e <- extent(msk)

rs <- crop(rs,e)

out_dir <- paste(crop_dir,"/biomod_modeling/current-clim",sep="")

out_dir_wwf <- paste(out_dir,"/wwf_eco",sep="")
if (!file.exists(out_dir_wwf)) {dir.create(out_dir_wwf)}

writeRaster (rs,paste(out_dir_wwf, "/wwf_eco_terr.asc", sep=""), overwrite=T)

# edist.R
source(paste(src.dir,"/009.edistDR.R",sep=""))
x <- summarizeDR_env(crop_dir)

# species richness
source(paste(src.dir,"/010.speciesRichness2.R",sep=""))
x <- speciesRichness_alt(bdir=crop_dir)

# priorities table
source(paste(src.dir,"/000.prioritiesTable.R",sep=""))
x <- priTable(crop_dir)

#== calculate final gap richness ==#
source(paste(src.dir,"/012.gapRichness2.R",sep=""))
x <- gapRichness(bdir=crop_dir)

#== verify if gap map is available for each taxon ==#
priFile <- read.csv(paste(crop_dir, "/priorities/priorities.csv", sep=""))
newpriFile <- priFile
newpriFile$MAP_AVAILABLE <- NA

spList <- priFile$TAXON

for (spp in spList){
  fpcat <- priFile$FPCAT[which(priFile$TAXON==paste(spp))]
  if(file.exists(paste(crop_dir, "/gap_spp/", fpcat, "/", spp, ".asc.gz", sep=""))){
    newpriFile$MAP_AVAILABLE[which(newpriFile$TAXON==paste(spp))] <- 1
  } else {
    newpriFile$MAP_AVAILABLE[which(newpriFile$TAXON==paste(spp))] <- 0
  }
}

write.csv(newpriFile, paste(crop_dir, "/priorities/priorities.csv", sep=""), row.names=F, quote=F)
rm(newpriFile)

#== getting maps and figures ==#
source(paste(src.dir,"/013.mapsAndFigures.R",sep=""))

#== ensuring access to folders ==#
system(paste("chmod", "-R", "777", crop_dir))


