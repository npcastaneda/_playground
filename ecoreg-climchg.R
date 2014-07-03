# Preparing ecoregional vulnerability map to climate change (Watson et al., 2013)
# N. Castaneda - 2014

# Load data
dir <- "D:/_geodata/ecoreg-clim-chng"
table <- read.csv(paste(dir,"/ecoregions_all-cs-natcov.csv", sep=""))

# Calculating average among climate change models
table["avg"] <- NA
table$avg <- rowMeans(table[,c("csiro","cccma", "ipsl", "mpi", "ncar", "ukhad", "ukgem")])
head(table)

# Estimating Spearman's correlation
cor(table[,c("natcov_1", "avg")], method="spearman")

# Calculating standard deviation
table["sd"] <- NA
table$sd <- apply(table[,c("csiro","cccma", "ipsl", "mpi", "ncar", "ukhad", "ukgem")],1,sd)
head(table)

# Plot data
plot(table$avg, table$natcov_1)

# Saving data
write.csv(table,paste(dir,"/ecoreg-clim-chng-calc.csv",sep=""))

?sd

a <- c(0.5955348, 0.7379253, 0.5508990, 0.8524095, 0.8827151, 0.8358543, 0.8318268)
sd(a)