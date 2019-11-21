

taf.library("icesVMS")

vms_effort_data <- icesVMS::get_fo_effort("Celtic Seas")
write.taf(vms_effort_data, file = "vms_effort_data.csv", quote= TRUE)