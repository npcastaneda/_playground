# Code for copying final HPS maps to a single folder and download them for zonal statistics analysis
# 
# N. Castaneda - Jun 2013

gap.dir <-"/curie_data2/ncastaneda/gap-analysis"
date <- "2014-08-27"
# date <- "2014-03-06"
fDir = paste(gap.dir,"/_all_gap_rich/",date,sep="")
if(file.exists(fDir)) {unlink(fDir, recursive=T)}
dir.create(fDir)

#---------------- CROPS LISTS -------------------

# cropList= c("avena", "bambara", "bean", "cajanus", "cicer", "cowpea", "daucus", "eggplant", "eleusine", "faba_bean", "helianthus", "hordeum", 
#             "ipomoea", "lathyrus", "lens", "lima_bean", "malus","medicago","musa","pennisetum", "pisum", "potato", "rice", "secale", "sorghum", 
#             "triticum", "vetch")

# cropPriorList= c("avena", "bambara", "bean", "cajanusPaper", "cicer", "cowpea", "daucus", "eggplant", "eleusine", "faba_bean", "US_CWR/gap_sunflower", "hordeum", 
#                  "ipomoea", "lathyrus", "lens", "lima_bean", "malus","medicago","musa","pennisetum", "pisum", "potato", "rice", "secale", "sorghum", 
#                  "triticum", "vetch")

cropPriorList= c("avena", "bambara", "bean", "cicer", "cowpea", "daucus", "eggplantNHM", "eleusine", "faba_bean", "US_CWR/gap_sunflower", "hordeum", 
                 "lathyrus", "lens", "lima_bean", "malus","medicago","musa","pennisetum", "pisum", "rice", "secale", "sorghum", 
                 "triticum", "vetch")

cropNonPriorList <- c("groundnut","beet","capsicum","watermelon","cucumber","strawberry","soybean","cotton","lettuce","cassava","sugar_cane","tomato","cacao",
                      "grape","maize","garlic","leek","onion","pineapple","cabbage","mustard","mustard_black","rape","turnip","papaya","safflower","grapefruit",
                      "lemon","orange","melon","squash_maxima","squash_pepo","mango","almond","apricot","cherry","peach","plum","pear","spinach","adzuki_bean",
                      "mung_bean","urd_bean","breadfruit","asparagus","quinoa","yam_lagos","yam_water","yam_whiteguinea","millet_panicum","millet_setaria","cocoyam")

cropList <- c(cropPriorList,cropNonPriorList)

for(crop in cropList){
  crop_dir = paste(gap.dir, "/gap_", crop, sep="")
  cat("Processing", crop, "\n")
  # Create final crop folder
  outDir = paste(fDir,"/",crop, sep=""); if(!file.exists(outDir)){dir.create(outDir)}
  # List files available
  gapDir = paste(crop_dir,"/gap_spp/HPS", sep="")
  lsFiles = list.files(gapDir, pattern=".asc.gz")
  if(length(lsFiles)==0){
    cat("No files under HPS category \n")
  }else{
    for(i in 1:length(lsFiles)){
      a = paste(gapDir,"/",lsFiles[i],sep="")
      file.copy(a,outDir)
    }
  }
}

#additional crops to include separately (namely Cajanus, Potato-CIP)

crop <- "cajanusPaper"
crop_dir = paste(gap.dir, "/gap_", crop, sep="")
cat("Processing", crop, "\n")
# Create final crop folder
outDir = paste(fDir,"/",crop, sep=""); if(!file.exists(outDir)){dir.create(outDir)}
# List files available
gapDir = paste(crop_dir,"/gap_spp", sep="")
lsFiles = list.files(gapDir, pattern=".asc.gz")
if(length(lsFiles)==0){
  cat("No files under HPS category \n")
}else{
  for(i in 1:length(lsFiles)){
    a = paste(gapDir,"/",lsFiles[i],sep="")
    file.copy(a,outDir, recursive=T)
  }
}

crop <- "potatoSpooner"
crop_dir = "/curie_data2/cip/gap_potatoSpooner"
cat("Processing", crop, "\n")
# Create final crop folder
outDir = paste(fDir,"/",crop, sep=""); if(!file.exists(outDir)){dir.create(outDir)}
# List files available
gapDir = paste(crop_dir,"/gap_spp/HPS", sep="")
lsFiles = list.files(gapDir, pattern=".asc.gz")
if(length(lsFiles)==0){
  cat("No files under HPS category \n")
}else{
  for(i in 1:length(lsFiles)){
    a = paste(gapDir,"/",lsFiles[i],sep="")
    file.copy(a,outDir)
  }
}

# zipFiles
zip(paste(fDir,".zip",sep=""), fDir)

#-------------------------------------------------------------------------------------------------------
# Code for copying all figures to a single folder and download them for reports preparation
# 
# N. Castaneda - Aug 2013

gap.dir <-"/curie_data2/ncastaneda/gap-analysis" 
fDir = paste(gap.dir, "/_all_figures",sep="")
if(file.exists(fDir)) {unlink(fDir, recursive=T)}
dir.create(fDir)

cropList= c("avena", "bambara", "bean", "cajanus", "cicer", "cowpea", "daucus", "eggplant", "eleusine", "faba_bean", "helianthus", "hordeum", 
            "ipomoea", "lathyrus", "lens", "lima_bean", "malus","medicago","musa","pennisetum", "pisum", "potato", "rice", "secale", "sorghum", 
            "triticum", "vetch")

for(crop in cropList){
  crop_dir = paste(gap.dir, "/gap_", crop, sep="")
  cat("Processing", crop, "\n")
  # Create final crop folder
  outDir = paste(fDir,"/",crop, sep=""); if(!file.exists(outDir)){dir.create(outDir)}
  # List files available
  gapDir = paste(crop_dir,"/figures", sep="")
  lsFiles = list.files(gapDir, pattern=".tif")
  if(length(lsFiles)==0){
    cat("No figures available for",crop, "\n")
  }else{
    for(i in 1:length(lsFiles)){
      a = paste(gapDir,"/",lsFiles[i],sep="")
      file.copy(a,outDir)
    }
  }
}

# zipFiles
zip(paste(fDir,".zip",sep=""), fDir)

#-------------------------------------------------------------------------------------------------------
# Code for copying all priorities tables
# N. Castaneda - Aug 2014

#---------------- CROPS LISTS -------------------

# cropList= c("avena", "bambara", "bean", "cajanus", "cicer", "cowpea", "daucus", "eggplant", "eleusine", "faba_bean", "helianthus", "hordeum", 
#             "ipomoea", "lathyrus", "lens", "lima_bean", "malus","medicago","musa","pennisetum", "pisum", "potato", "rice", "secale", "sorghum", 
#             "triticum", "vetch")

# cropPriorList= c("avena", "bambara", "bean", "cajanusPaper", "cicer", "cowpea", "daucus", "eggplant", "eleusine", "faba_bean", "US_CWR/gap_sunflower", "hordeum", 
#                  "ipomoea", "lathyrus", "lens", "lima_bean", "malus","medicago","musa","pennisetum", "pisum", "potato", "rice", "secale", "sorghum", 
#                  "triticum", "vetch")

cropPriorList= c("avena", "bambara", "bean", "cajanusPaper", "cicer", "cowpea", "daucus", "eggplantNHM", "eleusine", "faba_bean", "hordeum", 
                 "lathyrus", "lens", "lima_bean", "malus","medicago","musa","pennisetum", "pisum", "rice", "secale", "sorghum", 
                 "triticum", "vetch")

cropNonPriorList <- c("groundnut","beet","capsicum","watermelon","cucumber","strawberry","soybean","cotton","lettuce","cassava","sugar_cane","tomato","cacao",
                      "grape","maize","garlic","leek","onion","pineapple","cabbage","mustard","mustard_black","rape","turnip","papaya","safflower","grapefruit",
                      "lemon","orange","melon","squash_maxima","squash_pepo","mango","almond","apricot","cherry","peach","plum","pear","spinach","adzuki_bean",
                      "mung_bean","urd_bean","breadfruit","asparagus","quinoa","yam_lagos","yam_water","yam_whiteguinea","millet_panicum","millet_setaria","cocoyam")

cropList <- c(cropPriorList,cropNonPriorList)

for(crop in cropList){
  crop_dir = paste(gap.dir, "/gap_", crop, sep="")
  cat("Processing", crop, "\n")
  # Create final crop folder
  outDir = paste(fDir,"/",crop, sep=""); if(!file.exists(outDir)){dir.create(outDir)}
  # List files available
  gapDir = paste(crop_dir,"/priorities", sep="")
  lsFiles = list.files(gapDir, pattern="priorities.csv")
  if(length(lsFiles)==0){
    cat("No files under HPS category \n")
  }else{
    for(i in 1:length(lsFiles)){
      a = paste(gapDir,"/",lsFiles[i],sep="")
      file.copy(a,outDir)
    }
  }
}

crop <- "cajanusPaper"
crop_dir = paste(gap.dir, "/gap_", crop, sep="")
cat("Processing", crop, "\n")
# Create final crop folder
outDir = paste(fDir,"/",crop, sep=""); if(!file.exists(outDir)){dir.create(outDir)}
# List files available
gapDir = paste(crop_dir,"/priorities", sep="")
lsFiles = list.files(gapDir, pattern="priorities.csv")
if(length(lsFiles)==0){
  cat("No files under HPS category \n")
}else{
  for(i in 1:length(lsFiles)){
    a = paste(gapDir,"/",lsFiles[i],sep="")
    file.copy(a,outDir)
  }
}

crop <- "potatoSpooner"
crop_dir = "/curie_data2/cip/gap_potatoSpooner"
cat("Processing", crop, "\n")
# Create final crop folder
outDir = paste(fDir,"/",crop, sep=""); if(!file.exists(outDir)){dir.create(outDir)}
# List files available
gapDir = paste(crop_dir,"/priorities", sep="")
lsFiles = list.files(gapDir, pattern="priorities.csv")
if(length(lsFiles)==0){
  cat("No files under HPS category \n")
}else{
  for(i in 1:length(lsFiles)){
    a = paste(gapDir,"/",lsFiles[i],sep="")
    file.copy(a,outDir)
  }
}