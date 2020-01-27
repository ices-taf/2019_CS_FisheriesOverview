
# All plots and data outputs are produced here

library(icesTAF)
taf.library(icesFO)
library(sf)
library(ggplot2)

mkdir("report")

##########
#Load data
##########

catch_dat <- read.taf("data/catch_dat.csv")

sid <- read.taf("bootstrap/data/ICES_StockInformation/sid.csv")

#frmt_effort <- read.taf("data/frmt_effort.csv")
#frmt_landings <- read.taf("data/frmt_landings.csv")
trends <- read.taf("model/trends.csv")
catch_current <- read.taf("model/catch_current.csv")
catch_trends <- read.taf("model/catch_trends.csv")

clean_status <- read.taf("data/clean_status.csv")

effort_dat <- read.taf("bootstrap/data/ICES_vms_effort_data/vms_effort_data.csv")
landings_dat <- read.taf("bootstrap/data/ICES_vms_landings_data/vms_landings_data.csv")

ices_areas <-
  sf::st_read("bootstrap/data/ICES_areas/areas.csv",
              options = "GEOM_POSSIBLE_NAMES=WKT", crs = 4326)
ices_areas <- dplyr::select(ices_areas, -WKT)

ecoregion <-
  sf::st_read("bootstrap/data/ICES_ecoregions/ecoregion.csv",
              options = "GEOM_POSSIBLE_NAMES=WKT", crs = 4326)
ecoregion <- dplyr::select(ecoregion, -WKT)

# read vms fishing effort
effort <-
  sf::st_read("bootstrap/data/ICES_vms_effort_map/vms_effort.csv",
               options = "GEOM_POSSIBLE_NAMES=wkt", crs = 4326)
effort <- dplyr::select(effort, -WKT)

# read vms swept area ratio
sar <-
  sf::st_read("bootstrap/data/ICES_vms_sar_map/vms_sar.csv",
               options = "GEOM_POSSIBLE_NAMES=wkt", crs = 4326)
sar <- dplyr::select(sar, -WKT)

###############
##Ecoregion map
###############

plot_ecoregion_map(ecoregion, ices_areas)
ggplot2::ggsave("2019_BtS_FO_Figure1.png", path = "report", width = 170, height = 200, units = "mm", dpi = 300)




#################################################
##1: ICES nominal catches and historical catches#
#################################################

#~~~~~~~~~~~~~~~#
# By common name
#~~~~~~~~~~~~~~~#
#Plot
plot_catch_trends(catch_dat, type = "COMMON_NAME", line_count = 11, plot_type = "line")
catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Atlantic mackerel")] <- "mackerel"
catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Atlantic horse mackerel")] <- "horse mackerel"
catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Atlantic cod")] <- "cod"
catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Atlantic herring")] <- "herring"
plot_catch_trends(catch_dat, type = "COMMON_NAME", line_count = 11, plot_type = "line")

ggplot2::ggsave("2019_CS_FO_Figure5.png", path = "report/", width = 170, height = 100.5, units = "mm", dpi = 300)

#data
dat <- plot_catch_trends(catch_dat, type = "COMMON_NAME", line_count = 5, plot_type = "line", return_data = T)
write.taf(dat,"2019_CS_FO_Figure5.csv", dir = "report")


#~~~~~~~~~~~~~~~#
# By country
#~~~~~~~~~~~~~~~#
#Plot
plot_catch_trends(catch_dat, type = "COUNTRY", line_count = 9, plot_type = "area")
ggplot2::ggsave("2019_CS_FO_Figure2.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

#data
dat<-plot_catch_trends(catch_dat, type = "COUNTRY", line_count = 9, plot_type = "area", return_data = T)
write.taf(dat, file= "2019_CS_FO_Figure2.csv", dir = "report")

#~~~~~~~~~~~~~~~#
# By guild
#~~~~~~~~~~~~~~~#

unique(catch_dat$GUILD)

#Plot
plot_catch_trends(catch_dat, type = "GUILD", line_count = 6, plot_type = "line")

catch_dat$GUILD <- tolower(catch_dat$GUILD)
plot_catch_trends(catch_dat, type = "GUILD", line_count = 6, plot_type = "line")
ggplot2::ggsave("2019_CS_FO_Figure4.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

#data
dat <- plot_catch_trends(catch_dat, type = "GUILD", line_count = 6, plot_type = "line", return_data = T)
write.taf(dat, file= "2019_CS_FO_Figure4.csv", dir = "report")


###########
## 3: SAG #
###########

#~~~~~~~~~~~~~~~#
# A. Trends by guild
#~~~~~~~~~~~~~~~#

unique(trends$FisheriesGuild)

# 1. Demersal
#~~~~~~~~~~~
plot_stock_trends(trends, guild="demersal", cap_year = 2019, cap_month = "November", return_data = FALSE)
ggplot2::ggsave("2019_CS_FO_Figure13c.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="demersal", cap_year = 2019, cap_month = "November", return_data = TRUE)
write.taf(dat, file ="2019_CS_FO_Figure13c.csv", dir = "report")

# 2. Pelagic
#~~~~~~~~~~~
plot_stock_trends(trends, guild="pelagic", cap_year = 2019, cap_month = "November", return_data = FALSE)
ggplot2::ggsave("2019_CS_FO_Figure13d.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="pelagic", cap_year = 2018, cap_month = "November", return_data = T)
write.taf(dat,file ="2019_CS_FO_Figure13d.csv", dir = "report")

# 3. Benthic
#~~~~~~~~~~~
plot_stock_trends(trends, guild="benthic", cap_year = 2019, cap_month = "November",return_data = FALSE )
ggplot2::ggsave("2019_CS_FO_Figure13a.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="benthic", cap_year = 2018, cap_month = "November", return_data = TRUE)
write.taf(dat, file ="2019_CS_FO_Figure13a.csv", dir = "report" )

# 4. Crustacean
#~~~~~~~~~~~
plot_stock_trends(trends, guild="crustacean", cap_year = 2019, cap_month = "November",return_data = FALSE )
ggplot2::ggsave("2019_CS_FO_Figure13b.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="crustacean", cap_year = 2018, cap_month = "November", return_data = TRUE)
write.taf(dat, file ="2019_CS_FO_Figure13b.csv", dir = "report" )


#~~~~~~~~~~~~~~~~~~~~~~~~~#
# Ecosystem Overviews plot
#~~~~~~~~~~~~~~~~~~~~~~~~~#
guild <- read.taf("model/guild.csv")

plot_guild_trends(guild, cap_year = 2019, cap_month = "October",return_data = FALSE )
ggplot2::ggsave("2019_CS_EO_GuildTrends.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
guild2 <- guild %>% dplyr::filter(Year > 1957)
plot_guild_trends(guild2, cap_year = 2019, cap_month = "October",return_data = FALSE )
ggplot2::ggsave("2019_CS_EO_GuildTrends_short.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

guild3 <- guild %>% dplyr::filter(FisheriesGuild != "MEAN")
plot_guild_trends(guild3, cap_year = 2019, cap_month = "November",return_data = FALSE )
ggplot2::ggsave("2019_CS_EO_GuildTrends_noMEAN.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
guild4 <- guild3 %>% dplyr::filter(Year > 1957)
plot_guild_trends(guild4, cap_year = 2019, cap_month = "November",return_data = FALSE )
ggplot2::ggsave("2019_CS_EO_GuildTrends_short_noMEAN.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)


dat <- plot_guild_trends(guild, cap_year = 2019, cap_month = "October",return_data = TRUE)
write.taf(dat, file ="2019_CS_EO_GuildTrends.csv", dir = "report" )


dat <- trends[,1:2]
dat <- unique(dat)
dat <- dat %>% dplyr::filter(StockKeyLabel != "MEAN")
dat2 <- sid %>% select(c(StockKeyLabel, StockKeyDescription))
dat <- left_join(dat,dat2)
write.taf(dat, file ="2019_CS_EO_SpeciesGuild_list.csv", dir = "report", quote = TRUE)


#~~~~~~~~~~~~~~~#
# B.Current catches
#~~~~~~~~~~~~~~~#

# 1. Demersal
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current, guild = "demersal", caption = T, cap_year = 2019, cap_month = "November", return_data = F)
catch_current <- catch_current %>% filter(StockKeyLabel != "pol.27.67")
catch_current <- catch_current %>% filter(StockKeyLabel != "ele.2737.nea")
bar <- plot_CLD_bar(catch_current, guild = "demersal", caption = T, cap_year = 2019, cap_month = "November", return_data = F)

bar_dat <- plot_CLD_bar(catch_current, guild = "demersal", caption = T, cap_year = 2019, cap_month = "November", return_data = T)
write.taf(bar_dat, file ="2019_CS_FO_Figure14_demersal.csv", dir = "report" )
top_20 <- bar_dat %>% top_n(20,total)
bar <- plot_CLD_bar(top_20, guild = "demersal", caption = T, cap_year = 2019, cap_month = "November", return_data = F)
kobe <- plot_kobe(top_20, guild = "demersal", caption = T, cap_year = 2019, cap_month = "November", return_data = F)
png("report/2019_CS_FO_Figure14_demersal_top20.png",
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "demersal")
dev.off()


catch_current <- unique(catch_current)
kobe <- plot_kobe(catch_current, guild = "demersal", caption = T, cap_year = 2019, cap_month = "November", return_data = F)

png("report/2019_CS_FO_Figure14_demersal.png",
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "demersal")
dev.off()

# 2. Pelagic
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current, guild = "pelagic", caption = T, cap_year = 2019, cap_month = "November", return_data = F)

bar_dat <- plot_CLD_bar(catch_current, guild = "pelagic", caption = T, cap_year = 2019, cap_month = "November", return_data = T)
write.taf(bar_dat, file ="2019_CS_FO_Figure14_pelagic.csv", dir = "report")

kobe <- plot_kobe(catch_current, guild = "pelagic", caption = T, cap_year = 2019, cap_month = "November", return_data = F)
png(paste0("report/", "2019_CS_FO_Figure14_pelagic", ".png"),
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "pelagic")
dev.off()


# 3. Benthic
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current, guild = "benthic", caption = T, cap_year = 2019, cap_month = "November", return_data = F)

bar_dat <- plot_CLD_bar(catch_current, guild = "benthic", caption = T, cap_year = 2019, cap_month = "November", return_data = T)
write.taf(bar_dat, file ="2019_CS_FO_Figure14_benthic.csv", dir = "report" )

catch_current <- unique(catch_current)
kobe <- plot_kobe(catch_current, guild = "benthic", caption = T, cap_year = 2018, cap_month = "November", return_data = F)
png(paste0("report/", "2019_CS_FO_Figure14_benthic", ".png"),
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "benthic")
dev.off()

# 4. Crustacean
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current, guild = "crustacean", caption = T, cap_year = 2019, cap_month = "November", return_data = F)

bar_dat <- plot_CLD_bar(catch_current, guild = "crustacean", caption = T, cap_year = 2019, cap_month = "November", return_data = T)
write.taf(bar_dat, file ="2019_CS_FO_Figure14_crustacean.csv", dir = "report" )

kobe <- plot_kobe(catch_current, guild = "crustacean", caption = T, cap_year = 2018, cap_month = "November", return_data = F)
png(paste0("report/", "2019_CS_FO_Figure14_crustacean", ".png"),
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "crustacean")
dev.off()


# 5. All
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current, guild = "All", caption = T, cap_year = 2019, cap_month = "November", return_data = F)

bar_dat <- plot_CLD_bar(catch_current, guild = "All", caption = T, cap_year = 2019, cap_month = "November", return_data = T)
write.taf(bar_dat, file ="2019_CS_FO_Figure14_All.csv", dir = "report" )

top_10 <- bar_dat %>% top_n(10, total)
bar <- plot_CLD_bar(top_10, guild = "All", caption = TRUE, cap_year = 2019, cap_month = "November", return_data = FALSE)


kobe <- plot_kobe(top_10, guild = "All", caption = T, cap_year = 2018, cap_month = "November", return_data = F)
png(paste0("report/", "2019_CS_FO_Figure14_All", ".png"),
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "All stocks")
dev.off()


#~~~~~~~~~~~~~~~#
# C. Discards
#~~~~~~~~~~~~~~~#
discardsA <- plot_discard_trends(catch_trends, 2019, cap_year = 2019, cap_month = "November")
catch_trends2 <- catch_trends %>% filter(FisheriesGuild != "elasmobranch")
discardsA <- plot_discard_trends(catch_trends2, 2019, cap_year = 2019, cap_month = "November")


dat<- plot_discard_trends(catch_trends, 2019, cap_year = 2019, cap_month = "November", return_data = T)
write.taf(dat, file ="2019_CS_FO_Figure7_trends.csv", dir = "report" )

catch_trends3 <- catch_trends2 %>% filter(discards > 0)
discardsB <- plot_discard_current(catch_trends3, 2019,position_letter = "b)", cap_year = 2019, cap_month = "November", caption = FALSE)

discardsC <- plot_discard_current(catch_trends2, 2019,position_letter = "c)", cap_year = 2019, cap_month = "November")


dat <- plot_discard_current(catch_trends, 2019, cap_year = 2018, cap_month = "November", return_data = T)
write.taf(dat, file ="2019_CS_FO_Figure7_current.csv", dir = "report" )

cowplot::plot_grid(discardsA, discardsB, discardsC, align = "h", nrow = 1, rel_widths = 1, rel_heights = 1)
ggplot2::ggsave("2019_CS_Figure7.png", path = "report/", width = 220.32, height = 88.9, units = "mm", dpi = 300)


# png(paste0("report/", "2019_CS_FO_Figure7", ".png"),
#     width = 131.32,
#     height = 88.9,
#     units = "mm",
#     res = 300)
# p1_plot<-gridExtra::grid.arrange(discardsA,
#                                  discardsB, ncol = 2,
#                                  respect = TRUE)
# dev.off()

#~~~~~~~~~~~~~~~#
#D. ICES pies
#~~~~~~~~~~~~~~~#

plot_status_prop_pies(clean_status, "November", "2019")
unique(clean_status$FishingPressure)
unique(clean_status$StockSize)
clean_status$StockSize[which(clean_status$StockSize == "qual_RED")] <- "RED"
plot_status_prop_pies(clean_status, "November", "2019")

ggplot2::ggsave("2019_CS_FO_Figure11.png", path = "report/", width = 178, height = 178, units = "mm", dpi = 300)

dat <- plot_status_prop_pies(clean_status, "November", "2018", return_data = T)
write.taf(dat, file= "2019_CS_FO_Figure11.csv", dir = "report")

#~~~~~~~~~~~~~~~#
#E. GES pies
#~~~~~~~~~~~~~~~#
plot_GES_pies(clean_status, catch_current, "November", "2019")
ggplot2::ggsave("2019_CS_FO_Figure12.png", path = "report/", width = 178, height = 178, units = "mm", dpi = 300)

dat <- plot_GES_pies(clean_status, catch_current, "November", "2018", return_data = T)
write.taf(dat, file= "2019_CS_FO_Figure12.csv", dir = "report")

#~~~~~~~~~~~~~~~#
#F. ANNEX TABLE
#~~~~~~~~~~~~~~~#

dat <- format_annex_table(clean_status, 2019)

write.taf(dat, file = "2019_CS_FO_annex_table.csv", dir = "report")

# This annex table has to be edited by hand,
# For SBL and GES only one values is reported, 
# the one in PA for SBL and the one in MSY for GES 

###########
## 3: VMS #
###########

#~~~~~~~~~~~~~~~#
# A. Effort map
#~~~~~~~~~~~~~~~#

gears <- c("Static", "Midwater", "Otter", "Demersal seine", "Dredge", "Beam")

effort <-
    effort %>%
      dplyr::filter(fishing_category_FO %in% gears) %>%
      dplyr::mutate(
        fishing_category_FO =
          dplyr::recode(fishing_category_FO,
            Static = "Static gears",
            Midwater = "Pelagic trawls and seines",
            Otter = "Bottom otter trawls",
            `Demersal seine` = "Bottom seines",
            Dredge = "Dredges",
            Beam = "Beam trawls")
        ) %>%
      dplyr::filter(!is.na(mw_fishinghours))

# write layer
write_layer <- function(dat, fname) {
  sf::write_sf(dat, paste0("report/", fname, ".shp"))
  files <- dir("report", pattern = fname, full = TRUE)
  files <- files[tools::file_ext(files) != "png"]
  zip(paste0("report/", fname, ".zip"), files, extras = "-j")
  file.remove(files)
}
write_layer(effort, "2019_CS_FO_Figure9")

plot_effort_map(effort, ecoregion) +
  ggtitle("Average MW Fishing hours 2015-2018")

ggplot2::ggsave("2019_CS_FO_Figure9.png", path = "report", width = 170, height = 200, units = "mm", dpi = 300)

#~~~~~~~~~~~~~~~#
# B. Swept area map
#~~~~~~~~~~~~~~~#

# write layer
write_layer(sar, "2019_CS_FO_Figure17")

plot_sar_map(sar, ecoregion, what = "surface") +
  ggtitle("Average surface swept area ratio 2015-2018")

ggplot2::ggsave("2019_CS_FO_Figure17a.png", path = "report", width = 170, height = 200, units = "mm", dpi = 300)

plot_sar_map(sar, ecoregion, what = "subsurface")+
  ggtitle("Average subsurface swept area ratio 2015-2018")

ggplot2::ggsave("2019_CS_FO_Figure17b.png", path = "report", width = 170, height = 200, units = "mm", dpi = 300)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# C. Effort and landings plots
#~~~~~~~~~~~~~~~~~~~~~~~~~~~#


## Effort by country
plot_vms(effort_dat, metric = "country", type = "effort", cap_year= 2019, cap_month= "November", line_count= 6)
# effort_dat$kw_fishing_hours <- effort_dat$kw_fishing_hours/1000
effort_dat <- effort_dat %>% dplyr::mutate(country = dplyr::recode(country,
                                                                   FRA = "France",
                                                                   ESP = "Spain",
                                                                   GBR = "UK",
                                                                   BEL = "Belgium",
                                                                   IRL = "Ireland",
                                                                   NLD = "Netherlands",
                                                                   NO = "Norway"))
effort_dat2 <- effort_dat %>% filter(year < 2019, year > 2013)
plot_vms(effort_dat2, metric = "country", type = "effort", cap_year= 2019, cap_month= "November", line_count= 7)
ggplot2::ggsave("2019_CS_FO_Figure3_vms.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_vms(effort_dat, metric = "country", type = "effort", cap_year= 2019, cap_month= "November", line_count= 5, return_data = TRUE)
write.taf(dat, file= "2019_CS_FO_Figure3_vms.csv", dir = "report")

## Landings by gear
plot_vms(landings_dat, metric = "gear_category", type = "landings", cap_year= 2019, cap_month= "November", line_count= 4)

landings_dat$totweight <- landings_dat$totweight/1000
landings_dat <- landings_dat %>% dplyr::mutate(gear_category = 
                                                       dplyr::recode(gear_category,
                                                                     Static = "Static gears",
                                                                     Midwater = "Pelagic trawls and seines",
                                                                     Otter = "Bottom otter trawls",
                                                                     `Demersal seine` = "Bottom seines",
                                                                     Dredge = "Dredges",
                                                                     Beam = "Beam trawls",
                                                                     'NA' = "Undefined"))

landings_dat2 <- landings_dat %>% filter(year <2019, year > 2013)
plot_vms(landings_dat2, metric = "gear_category", type = "landings", cap_year= 2019, cap_month= "November", line_count= 4)
ggplot2::ggsave("2019_CS_FO_Figure6_vms.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_vms(landings_dat, metric = "gear_category", type = "landings", cap_year= 2019, cap_month= "November", line_count= 6, return_data = TRUE)
write.taf(dat, file= "2019_CS_FO_Figure6_vms.csv", dir = "report")

## Effort by gear

plot_vms(effort_dat2, metric = "gear_category", type = "effort", cap_year= 2019, cap_month= "November", line_count= 6)
effort_dat2 <- effort_dat2 %>% dplyr::mutate(gear_category = 
                                                   dplyr::recode(gear_category,
                                                                 Static = "Static gears",
                                                                 Midwater = "Pelagic trawls and seines",
                                                                 Otter = "Bottom otter trawls",
                                                                 `Demersal seine` = "Bottom seines",
                                                                 Dredge = "Dredges",
                                                                 Beam = "Beam trawls",
                                                                 'NA' = "Undefined"))

plot_vms(effort_dat2, metric = "gear_category", type = "effort", cap_year= 2019, cap_month= "November", line_count= 6)

ggplot2::ggsave("2019_CS_FO_Figure8_vms.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <-plot_vms(effort_dat, metric = "gear_category", type = "effort", cap_year= 2019, cap_month= "November", line_count= 6, return_data = TRUE)
write.taf(dat, file= "2019_CS_FO_Figure8_vms.csv", dir = "report")
