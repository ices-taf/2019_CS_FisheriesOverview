## Preprocess data, write TAF data tables

## Before:
## After:

library(icesTAF)
require(dplyr)
library(icesFO)

mkdir("data")

# 1: ICES official cath statistics

hist <- read.csv("bootstrap/data/ICES_nominal_catches/ICES_historical_catches.csv")
official <- read.csv("bootstrap/data/ICES_nominal_catches/ICES_2006_2017_catches.csv")
prelim <- read.csv("bootstrap/data/ICES_nominal_catches/ICES_preliminary_catches.csv")

catch_dat <- icesFO::format_catches(2019, "Celtic Seas Ecoregion", hist, official, prelim)

# 2: RDB effort and landings

# effort <- read.csv("bootstrap/data/STECF_effort.csv")
# landings <- read.csv("bootstrap/data/STECF_landings.csv")


frmt_effort <- format_stecf_effort(effort)

frmt_landings <- format_stecf_landings(landings)

# 3: SAG
sag_sum <- read.csv("bootstrap/data/SAG_data/SAG_summary.csv")
sag_refpts <- read.csv("bootstrap/data/SAG_data/SAG_refpts.csv")
sag_status <- read.csv("bootstrap/data/SAG_data/SAG_status.csv")


clean_sag <- format_sag(sag_sum, sag_refpts, 2019, "Celtic")
clean_status <- format_sag_status(sag_status, 2019, "Celtic Seas")
