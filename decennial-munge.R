library(readxl)
library(tidyr)
library(plyr)
library(reshape2)
library(stringr)
setwd("~/r-acs-munge")

simple_melt <- function(df, metacols) {
  melted <- melt(df, id.var=metacols)
  simplified <- melted$PrdctType <- NULL
  simplified <- melted$GeogType <- NULL
  arrange(melted, desc(GeoID))
}

dataset <- read_excel("~/r-acs-munge/PFF_2000to2010_CityBoroPUMA_NTA_CT_CB_2-12-18.xlsx")
data_dictionary <- read_excel("~/r-acs-munge/PFF_2000to2010DataDictionary-2-12-18.xlsx")
metacols <- c("PrdctType", "Year", "GeogType", "GeoID")

# write.csv(dataset, 'decennial.csv', na="", row.names = FALSE)
# write.csv(data_dictionary, 'decennial_dictionary.csv', na="", row.names = FALSE)


#Sex and Age
sexAgeCols <- (data_dictionary[data_dictionary$Category == "SEX AND AGE",] %>% drop_na(VariableName))$VariableName

write.csv(
  simple_melt(
    dataset[,c(sexAgeCols, metacols)],
    metacols
  ), 
  'dec_sex_age.csv', na="", 
  row.names = FALSE
)

for (category in unique(data_dictionary$Category)) {
  category_name = str_replace_all(category, "[[:punct:]]", "")
  sexAgeCols <- (data_dictionary[data_dictionary$Category == category,] %>% drop_na(VariableName))$VariableName
  
  write.csv(
    simple_melt(
      dataset[,c(sexAgeCols, metacols)],
      metacols
    ), 
    paste(category_name, '.csv', sep=''), 
    na="", 
    row.names = FALSE
  )
}
