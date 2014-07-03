#Heatmaps

require(RColorBrewer)
##################################
# All priority taxa heatmap
##################################
all_scores <- read.csv("D:/CWR/ResultsGapAnalysis2013/_summary/_analysis/Query1.csv")
all_scores <- all_scores[order(all_scores$Crop_code),]
head(all_scores)
row.names(all_scores) <- all_scores$TAXON
head(all_scores)
all_scores <- all_scores[,c(10,15,16,17)]
all_matrix <- data.matrix(all_scores)
all_heatmap <- heatmap(all_matrix, Rowv=NA, Colv=NA, col=heat.colors(256), scale="column", margins=c(5,10))

##################################
# Potato cwr taxa
##################################
all_scores <- read.csv("D:/CWR/ResultsGapAnalysis2013/_summary/_analysis/Query1.csv")
all_scores <- all_scores[order(all_scores$Crop_code),]
head(all_scores)
all_scores <- all_scores[which(all_scores$Crop_code == "potato"),]
row.names(all_scores) <- all_scores$TAXON
head(all_scores)
all_scores <- all_scores[,c(10,15,16,17)]
all_matrix <- data.matrix(all_scores)
pal <- colorRampPalette(brewer.pal(9,"Spectral"))(100)
all_heatmap <- heatmap(all_matrix, Rowv=NA, Colv=NA, col=pal, scale="column", margins=c(5,10))

display.brewer.all(n=10, exact.n=FALSE)