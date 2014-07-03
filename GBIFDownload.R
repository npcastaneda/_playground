# Code prepared to automatize downloads from GBIF
# N. Castaneda - 2014

require(dismo)

# Test done the 28th of April, 2014
# Download by genus

data <- gbif("daucus")
#dismo found: 366 records // 150.977 records in GBIF!
data <- gbif('Daucus', '*')

