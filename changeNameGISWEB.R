# H. Achicanoy
# CIAT, 2014

### =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ###
### Rename folders and files in GISWEB
### =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ###

require(XML)
require(RCurl)
require(RGoogleDocs)

connection   = getGoogleDocsConnection(getGoogleAuth("your_email@gmail.com","your_password",service="wise"))
spreadsheets = getDocs(connection, ssl.verifypeer=FALSE)
data         = getWorksheets(spreadsheets$"CWR_DISTRIBUTION_MAPS_REVISION_2014_03", connection)
data         = sheetAsMatrix(data$Taxa_to_change_names_in_GISWEB, header=TRUE, as.data.frame=TRUE)
data         = data[-98,]

main_dir = "//gisweb/AGCastanedaV/www_distributionMaps"

files_ch = data
files_ch = files_ch[order(files_ch$crop),]

crops = as.character(files_ch$crop)
crops = unique(crops)

# Loop for crops
for(i in 1:length(crops)){
  
  options(warn=-1)
  
  # Define taxa to change
  taxa  = files_ch$taxon_id[files_ch$crop==crops[i]] # old ID
  taxa  = as.character(taxa)
  taxa  = as.numeric(taxa)
  ntaxa = files_ch$new_taxon_id[files_ch$crop==crops[i]] # new ID
  ntaxa = as.character(ntaxa)
  ntaxa = as.numeric(ntaxa)
  
  if(!any(is.na(ntaxa))){ # Verify if new_taxon_id exists
    
    fpcat = files_ch$FPCAT[files_ch$crop==crops[i]] #  FPS category
    fpcat = as.character(fpcat)
    
    # Define occurrence, models and gap spp directories for each crop
    occ_dir = paste(main_dir,"/gap_",crops[i],"/occurrence_files",sep="")
    mod_dir = paste(main_dir,"/gap_",crops[i],"/models",sep="")
    gsp_dir = paste(main_dir,"/gap_",crops[i],"/gap_spp",sep="")
    
    # Loop for taxa within each crop
    for(j in 1:length(taxa)){
      
      # Occurrence file
      taxon_ch = paste(occ_dir,"/",taxa[j],".csv",sep="")
      if(file.exists(taxon_ch)){
        cat("Change occurrence name for", crops[i], "changing the taxon number:",taxa[j],"\n")
        file.rename(from=paste(occ_dir,"/",taxa[j],".csv",sep=""),to=paste(occ_dir,"/",ntaxa[j],".csv",sep=""))
        cat("Done! \n")
      } else {
        cat("The occurrence file for", crops[i], "taxon number:",taxa[j],"was changed manually. \n")
      }
      rm(taxon_ch)
      
      # Models test image
      models_im = paste(mod_dir,"/",taxa[j],"/",taxa[j],"scaleTestImage.png",sep="")
      if(file.exists(models_im)){
        cat("Change test image models for", crops[i], "changing the taxon number:",taxa[j],"\n")
        file.rename(from=paste(mod_dir,"/",taxa[j],"/",taxa[j],"scaleTestImage.png",sep=""),to=paste(mod_dir,"/",taxa[j],"/",ntaxa[j],"scaleTestImage.png",sep=""))
        cat("Done! \n")
      } else {
        cat("The test image models for", crops[i], "taxon number:",taxa[j],"was changed manually. \n")
      }
      rm(models_im)
      
      # Gap spp test image
      gpspp_im = paste(gsp_dir,"/",fpcat[j],"/",taxa[j],"/",taxa[j],"scaleTestImage.png",sep="")
      if(file.exists(gpspp_im)){
        cat("Change test image gap_spp for", fpcat[j], "category in", crops[i], "changing the taxon number:",taxa[j],"\n")
        file.rename(from=paste(gsp_dir,"/",fpcat[j],"/",taxa[j],"/",taxa[j],"scaleTestImage.png",sep=""), to=paste(gsp_dir,"/",fpcat[j],"/",taxa[j],"/",ntaxa[j],"scaleTestImage.png",sep=""))
        cat("Done! \n")
      } else {
        cat("The test image gap_spp for", fpcat[j], "category in", crops[i], "taxon number:",taxa[j],"was changed manually. \n")
      }
      rm(gpspp_im)
      
      # Rename models folder
      if(file.exists(paste(mod_dir,"/",taxa[j],sep=""))){
        cat("Change the folder name for models: taxon",taxa[j],"in",crops[i],"\n")
        file.rename(from=paste(mod_dir,"/",taxa[j],sep=""),to=paste(mod_dir,"/",ntaxa[j],sep=""))
        cat("Done! \n")
      } else {
        cat("The folder name for models:",crops[i],"taxon numer:",taxa[j],"was changed manually. \n")
      }
      
      # Rename gap_spp folder
      if(file.exists(paste(gsp_dir,"/",fpcat[j],"/",taxa[j],sep=""))){
        cat("Change the folder name for gap_spp:",crops[i],"\n")
        file.rename(from=paste(gsp_dir,"/",fpcat[j],"/",taxa[j],sep=""),to=paste(gsp_dir,"/",fpcat[j],"/",ntaxa[j],sep=""))
        cat("Done! \n")
      } else {
        cat("The folder name for gap_spp:",crops[i],"taxon numer:",taxa[j],"was changed manually. \n")
      }
      
    }
    
  } else {
    
    cat("For the crop:",crops[i],", exists taxa without new taxon ID assigned \n")
    cat("Please check again, before to run the code. \n")
    
  }
  
}
