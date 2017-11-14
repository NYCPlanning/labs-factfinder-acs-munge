library(readxl)
library(tidyr)
library(plyr)
library(reshape2)
setwd("~/r-acs-munge")

melt_acs_data <- function(dataset, combined, metacols, name) {
  df <- dataset[,combined]
  melted <- melt(df, id.var=metacols)
  split <- melted %>% separate(variable, into = c("variable", "type"), sep = -2)
  casted <- dcast(split, GeoType + GeogName + GeoID + Dataset + variable ~ type)
  write.csv(arrange(casted, desc(GeoID)), paste(name, '.csv', sep=''), na="", row.names = FALSE)
}

dataset <- read_excel("~/r-acs-munge/ACSDatabase_0610-1115.xlsx", skip = 1)
data_dictionary <- read_excel("~/r-acs-munge/data_dictionary.xlsx")
metacols <- c("PrdctType", "Dataset", "GeoType", "GeogName", "GeoID", "FIPS", "BoroID", "CT", "BoroCT1", "BoroCT2", "NTA_Equiv", "PUMA_Equiv")

melt_acs_data(
  dataset, 
  c(
    metacols, 
    (data_dictionary[data_dictionary$Profile == 'Demographic' & data_dictionary$Category != 'Demographic- Special Variable',] %>% drop_na(VariableName))$VariableName
  ), 
  metacols, 
  'demographic'
)

melt_acs_data(
  dataset, 
  c(
    metacols, 
    (data_dictionary[data_dictionary$Profile == 'Social' & data_dictionary$Category != 'Social-Special Variable',] %>% drop_na(VariableName))$VariableName
  ),
  metacols,
  'social'
)

melt_acs_data(
  dataset, 
  c(
    metacols, 
    (data_dictionary[data_dictionary$Profile == 'Economic' & data_dictionary$Category != 'Economic- Special Variable' ,] %>% drop_na(VariableName))$VariableName
  ),
  metacols,
  'economic'
)

melt_acs_data(
  dataset, 
  c(
    metacols, 
    (data_dictionary[data_dictionary$Profile == 'Housing' & data_dictionary$Category != 'Housing- Special Variable',] %>% drop_na(VariableName))$VariableName
  ),
  metacols,
  'housing'
)

