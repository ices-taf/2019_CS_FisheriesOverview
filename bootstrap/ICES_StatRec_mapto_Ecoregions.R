
library(icesTAF)
taf.library(icesFO)

statrec2ecoregions <- icesFO::load_statrec2ecoregions()

icesTAF::write.taf(statrec2ecoregions)
