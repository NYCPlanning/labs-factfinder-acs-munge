library(readxl)
library(tidyr)
library(reshape2)
setwd("~/r-acs-munge")

dataset <- read.csv("~/r-acs-munge/ACSDatabase_0610-1115.csv")

data_dictionary <- read_excel("~/r-acs-munge/data_dictionary.xlsx")

metacols <- c("PrdctType", "Year", "GeoType", "GeogName", "GeoID", "FIPS", "BoroID", "CT", "BoroCT1", "BoroCT2", "NTA_Equiv", "PUMA_Equiv")

cols_from_meta <- data_dictionary[data_dictionary$Profile == 'Demographic' & data_dictionary$Category != 'Demographic- Special Variable',] %>% drop_na(VariableName)

combined <- c(metacols, cols_from_meta$VariableName)

df <- dataset[,combined]
melted <- melt(df, id.var=metacols)
split <- melted %>% separate(variable, into = c("variable", "type"), sep = -2)
casted <- dcast(split, GeoType + GeogName + GeoID + Year + variable ~ type)
write.csv(casted, 'melted_full.csv', na="", row.names = FALSE)
