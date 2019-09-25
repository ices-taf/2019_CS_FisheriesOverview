
library(icesTAF)
taf.library(icesFO)

ecoregions <- load_ecoregions()

sf::st_write(ecoregions, 
             "ecoregions.csv",
             layer_options = "GEOMETRY=AS_WKT")
