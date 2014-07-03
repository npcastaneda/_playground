# =====================================================
# Preparing all files and folders required for the gap analysis
# N. Castaneda
# Sept 13- 2013

# =================== Main settings =================== 
main.dir <- "/curie_data2/ncastaneda/gap-analysis"
main.src <- "/curie_data2/ncastaneda/code/gap-analysis-cwr/gap-analysis/gap-code"

cropList <- c("groundnut","beet","capsicum","watermelon","cucumber","strawberry","soybean","cotton","lettuce","cassava","sugar_cane","tomato","cacao",
              "grape","maize","garlic","leek","onion","pineapple","cabbage","mustard","mustard_black","rape","turnip","papaya","safflower","grapefruit",
              "lemon","orange","melon","squash_maxima","squash_pepo","mango","almond","apricot","cherry","peach","plum","pear","spinach","adzuki_bean",
              "mung_bean","urd_bean","breadfruit","asparagus","quinoa","yam_lagos","yam_water","yam_whiteguinea","millet_panicum","millet_setaria","cocoyam")

# Create crop folders
for(crop in cropList){
  crop.dir <- paste(main.dir,"/gap_", crop, sep="")
  cat("Creating folders for", crop, "\n")
  if(!file.exists(crop.dir)){dir.create(crop.dir)}
  # Scripts folder
  src.dir <- paste(crop.dir,"/_scripts",sep="")
  if(!file.exists(src.dir)){dir.create(src.dir)}
  # Scripts files
  file.copy(main.src, crop.dir, recursive=T)
  file.rename(paste(crop.dir, "/gap-code", sep=""), src.dir)
  # Native areas folder
  na.dir <- paste(crop.dir,"/biomod_modeling", sep="")
  if(!file.exists(na.dir)){dir.create(na.dir)}
  na.dir <- paste(crop.dir,"/biomod_modeling/native-areas", sep="")
  if(!file.exists(na.dir)){dir.create(na.dir)}
  na.dir <- paste(crop.dir,"/biomod_modeling/native-areas/polyshps", sep="")
  if(!file.exists(na.dir)){dir.create(na.dir)}
  # Masks folder
  msk.dir <- paste(crop.dir,"/masks", sep="")
  if(!file.exists(msk.dir)){dir.create(msk.dir)}
  msk.dir <- paste(crop.dir,"/masks/polyshps", sep="")
  if(!file.exists(msk.dir)){dir.create(msk.dir)}
  # Maxent folder - lib file
  mxn.dir <- paste(crop.dir,"/maxent_modeling", sep="")
  if(!file.exists(mxn.dir)){dir.create(mxn.dir)}
  mxn.dir <- paste(crop.dir,"/maxent_modeling/lib", sep="")
  if(!file.exists(mxn.dir)){dir.create(mxn.dir)}
  # Occurrences folder
  occ.dir <- paste(crop.dir,"/occurrences", sep="")
  if(!file.exists(occ.dir)){dir.create(occ.dir)}  
}

# Copy native area files
for(crop in cropList){
# narea <- paste(main.dir,"/_nareashp/", crop, sep="")
# crop.dir <- paste(main.dir,"/gap_", crop, sep="")
# na.dir <- paste(crop.dir,"/biomod_modeling/native-areas", sep="")

# file.copy(narea, na.dir, recursive=T)
# file.rename(paste(na.dir, "/", crop, sep=""), paste(na.dir, "/polyshps", sep="") )
# unlink(paste(na.dir, "/", crop, sep=""), recursive=T)
}

# Copy maxent executable file to all genepool folders
for(crop in cropList){
  crop.dir <- paste(main.dir,"/gap_", crop, sep="")
  mxnt <- paste(main.dir, "/gap_avena/maxent_modeling/lib/maxent.jar", sep="")
  file.copy(mxnt, paste(crop.dir, "/maxent_modeling/lib", sep=""))
}
