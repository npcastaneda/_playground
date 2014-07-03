# Create barplot
crops = read.table("clipboard")
names(crops)
names(crops) = c("crop", "no_experts")

require(MASS)
crop = crops$no_experts
crop.freq = table(crop)
barplot(crop.freq, main= "Experts giving feedback",xlab ="No. of crops", ylab = "No. of experts", horiz = TRUE)
