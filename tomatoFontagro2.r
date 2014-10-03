# Fontagro tomate
# 2014

# DATA EXPLORATION
data <- read.csv("clipboard",sep="\t", header=T)
head(data)

require(maptools)
data(wrld_simpl)
plot(wrld_simpl)

attach(data)
points(lon,lat) # Two points with unexpected distribution (atlantic ocean and Bolivia)

# AIM: describe associations between environmental characteristics and physiological traits
# AIM: correlations 

# Strategy
# Alternative 1: explore GGE biplot approach - Check Rakshit et al 2012 - Sorghum
# Alternative 2: Pearson correlations - Check Zhou et al 2013 - Rice
# Alternative 3: mixed linear models - Check wild wheat project
# Alternative 4: hierarchical partinioning - check Zhou et al 2013 - Rice

