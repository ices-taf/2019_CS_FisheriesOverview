# wd: bootstrap/data/ICES_nominal_catches

library(icesFO, lib.loc="../../library")

hist <- load_historical_catches()
write.csv(hist, file = "ICES_historical_catches.csv")

official <- load_official_catches()
write.csv(official, file = "ICES_2006_2017_catches.csv")

official <- load_preliminary_catches(2018)
write.csv(official, file = "ICES_preliminary_catches.csv")
