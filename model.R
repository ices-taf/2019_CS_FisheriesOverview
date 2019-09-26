## Run analysis, write model results

## Before:
## After:

library(icesTAF)
require(dplyr)

mkdir("model")

#A. Trends by guild

trends <- stock_trends(clean_sag)


#B.Trends and current catches, landings and discards


catch_trends <- CLD_trends(clean_sag)
catch_current <- stockstatus_CLD_current(clean_sag)

