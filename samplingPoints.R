# H. Achicanoy
# Created to reduce the number of points of Lactuca serriola (ID 1787)
# CIAT 2013

# data <- read.csv("C:/Users/haachicanoy/Downloads/1787-narea.csv",header=T,sep=",")
data <- read.csv("D:/Playground/gap_lettuce/occurrence_files/1787-narea.csv",header=T,sep=",")
attach(data)

plot(data$lon[data$Type=="H"],data$lat[data$Type=="H"],
     xlim=c(-20,180),ylim=c(20,75),pch=20,cex=0.8)
points(data$lon[data$Type=="G"],data$lat[data$Type=="G"],pch=20,cex=0.8,col=2)

nG <- sum(data$Type=="G")
nH <- sum(data$Type=="H")

rG <- data$id[data$Type=="G"]
rH <- data$id[data$Type=="H"]

# G records (x1)%
samG <- sample(x=rG,size=(nG/(nG+nH))*1000)
samH <- sample(x=rH,size=(nH/(nG+nH))*1000)

length(samG)+length(samH)
samT <- c(samG,samH)
tipo <- c(rep("G",length(samG)),rep("H",length(samH)))

mySam <- data.frame(id=samT,Type=tipo)

res <- merge(mySam,data,by="id")

plot(res$lon[res$Type.x=="H"],res$lat[res$Type.x=="H"],
     xlim=c(-20,180),ylim=c(20,75),pch=20,cex=0.8)
points(res$lon[res$Type.x=="G"],res$lat[res$Type.x=="G"],pch=20,cex=0.8,col=2)

write.csv(res, "D:/Playground/gap_lettuce/occurrence_files/1787-narea-reduced.csv")