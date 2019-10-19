library(icesTAF)
taf.library(icesFO)

areas <- icesFO::load_areas("Celtic Seas")

sf::st_write(areas, "areas.csv", layer_options = "GEOMETRY=AS_WKT")
