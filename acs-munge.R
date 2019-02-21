library(readxl)
library(tidyr)
library(readr)
library(plyr)
library(reshape2)
library(uuid)

sessionUUID = format(Sys.time(), "%Y-%m-%d-%M-%S")
dir.create(paste('output/', sessionUUID, sep=""), showWarnings=FALSE)

# function to reformat original ACSDatabase and data_dictionary datasets
melt_acs_data <- function(dataset, combined, metacols, name) {
  # NORMALIZE dictionary
  e <- paste(combined, c('E'), sep='')
  m <- paste(combined, c('M'), sep='')
  z <- paste(combined, c('Z'), sep='')
  p <- paste(combined, c('P'), sep='')
  c <- paste(combined, c('C'), sep='')

  normalizedCombined <- c(e,m,z,p,c, metacols)

  # a new dataframe is created, by grabbing columns from dataset
  df <- dataset[,normalizedCombined]

  # melt df, identifying variable as metacols
  # (each row in metacols will have own discrete value, whereas other variables might have values repeated for multiple rows--metadata)
  melted <- melt(df, id.var=metacols)

  # “variable” column split into two columns, “variable” and “type”, at -2 position of string
  split <- melted %>% separate(variable, into = c("variable", "type"), sep = -2)

  # split is dcast with left hand side (become rows) to right hand side (become columns)
  casted <- dcast(split, GeoType + GeogName + GeoID + Dataset + variable ~ type)

  # order by GeoID in descending order
  final <- arrange(casted, desc(GeoID))
  write_csv(final, path=paste0('output/', sessionUUID, '/', name, '.csv', sep=''), na="")
}

dataset <- read_excel("input/ACSDatabase_0610-1317.xlsx", skip = 1)
data_dictionary <- read_excel("input/Data Dictionary_0610-1317 database_Dec172018.xlsx")
metacols <- c("PrdctType", "Dataset", "GeoType", "GeogName", "GeoID", "FIPS", "BoroID", "CT", "BoroCT1", "BoroCT2", "NTA_Equiv", "PUMA_Equiv")

# DEMOGRAPHIC
melt_acs_data(
  dataset,
    # new vector called “metacols”, added as columns to “dataset”,
    # filter columns from data_dictionary, drop N/As
    c(
    (data_dictionary[data_dictionary$Profile == 'Demographic',] %>% drop_na(VariableName))$VariableName
  ), 
  metacols, # identifying variable in melt function
  'demographic' # name for CSV
)

# SOCIAL
melt_acs_data(
  dataset, 
  c(
    (data_dictionary[data_dictionary$Profile == 'Social',] %>% drop_na(VariableName))$VariableName
  ),
  metacols,
  'social'
)

# ECONOMIC
melt_acs_data(
  dataset, 
  c(
    (data_dictionary[data_dictionary$Profile == 'Economic',] %>% drop_na(VariableName))$VariableName
  ),
  metacols,
  'economic'
)

#HOUSING
melt_acs_data(
  dataset, 
  c(
    (data_dictionary[data_dictionary$Profile == 'Housing',] %>% drop_na(VariableName))$VariableName
  ),
  metacols,
  'housing'
)

write_csv(data_dictionary, paste('output/', sessionUUID, '/', 'factfinder_metadata.csv', sep=""))
