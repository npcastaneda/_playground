# Determine the distribution pattern of samples for modelling
# N. Castaneda - 2014


# Using package vegan
require(vegan)
data(BCI)

J # Pielou index
H # Shannon-weaver diversity index

H <- diversity(BCI)
J <- H/log(specnumber(BCI))

# Using package asbio
install.packages("asbio")
data(varespec)
evenness(varespec) #does not work


# prepare code for RTB!!!
# prepare code for small legumes!!!