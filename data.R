# Initial formatting of the data

library(icesTAF)
taf.library(icesFO)
library(dplyr)

mkdir("data")

# load species list
species_list <- read.taf("bootstrap/data/FAO_ASFIS_species/species_list.csv")
sid <- read.taf("bootstrap/data/ICES_StockInformation/sid.csv")

# 1: ICES official cath statistics

hist <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_historical_catches.csv")
official <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_2006_2017_catches.csv")
prelim <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_preliminary_catches.csv")

catch_dat <- 
  format_catches(2019, "Celtic Seas", 
    hist, official, prelim, species_list, sid)

write.taf(catch_dat, dir = "data", quote = TRUE)

if (FALSE) {
# 2: RDB effort and landings

# effort <- read.csv("bootstrap/data/STECF_effort.csv")
# landings <- read.csv("bootstrap/data/STECF_landings.csv")

# 2: STECF effort and landings

effort <- read.taf("bootstrap/data/STECF_effort.csv", check.names = TRUE)

landings <- read.taf("bootstrap/initial/data/STECF_landings.csv", check.names = TRUE)

frmt_effort <- format_stecf_effort(effort)
frmt_landings <- format_stecf_landings(landings)

write.taf(frmt_effort, dir = "data", quote = TRUE)
write.taf(frmt_landings, dir = "data")

}

# 3: SAG
sag_sum <- read.taf("bootstrap/data/SAG_data/SAG_summary.csv")
sag_refpts <- read.taf("bootstrap/data/SAG_data/SAG_refpts.csv")
sag_status <- read.taf("bootstrap/data/SAG_data/SAG_status.csv")

clean_sag <- format_sag(sag_sum, sag_refpts, 2019, "Celtic")
clean_status <- format_sag_status(sag_status, 2019, "Celtic Seas")

write.taf(clean_sag, dir = "data")
write.taf(clean_status, dir = "data", quote = TRUE)
