# Detecting and reducing collinearity among modelling variables
# Castaneda - Aug 2014

#IMPORTANTE NOTE: CHECK DORMANN ET AL 2013

# -------------------------------------------------------------------
# Strategies to detect and reduce multicollinearity
# 1. Diagnosis:
# 1.1 Produce a correlation matrix, or  - done
# 1.2 Apply a test (?) - pending
# 2. Correction:
# 2.1 Variables selection through cluster analysis (?) - pending
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Initial settings
# -------------------------------------------------------------------
require(raster)
require(corrgram)

wd <- "D:/_geodata/CM30_1975H_Bio_ASCII_V1.1/CM30_1975H_Bio_V1.1"
setwd(wd)

# -------------------------------------------------------------------
# 1. Diagnosis
# -------------------------------------------------------------------
# Producing a correlation matrix between environmental rasters

ls <- list.files(full.names=T)
stk <- stack(ls) #all variables

rs <- stk[[1]]
xy <- xyFromCell(rs,which(!is.na(rs[])))
xy <- as.data.frame(xy)

bios <- extract(stk,xy)
bios <- as.data.frame(bios)
bios <- cbind(xy,bios)

biovars <- bios[,3:ncol(bios)]

# Pearson detects linear relationships. See Chok 2010 http://d-scholarship.pitt.edu/8056/
cor(mtcars, use="complete.obs", method="pearson") 
cor <- cor(biovars)
write.csv(cor,"cor.csv")

# Obtaining a correlogram - resource consuming!
corrgram(biovars, order=NULL, lower.panel=NULL,
         upper.panel=panel.shade, text.panel=panel.txt,
         main="35 bioclim variables obtained from ClimMod")


##########################
#PLAYGROUND


