#setwd("C:/Users/Usuari/Documents/MESIO/R and SAS/R/TREBALL")
#setwd("")
#setwd("")
#install.packages("readxl")
#install.packages("httr")

# libraries
library(readxl)
library(httr)
library(Hmisc)

# Read the excel file
url_data <- "https://github.com/owid/co2-data/raw/master/owid-co2-data.xlsx"
GET(url_data, write_disk(TF_data <- tempfile(fileext = ".xlsx")))
Greenhouse_Gas_Emissions <- read_excel(TF_data)
str(Greenhouse_Gas_Emissions)
url_descr <- "https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-codebook.csv"
GET(url_descr, write_disk(TF_descr <- tempfile(fileext = ".csv")))
Greenhouse_descr <- read.csv(TF_descr)


#ETIQUETAR LES VARIABLES (dona un error):

# (var.labels = Greenhouse_descr$source)
# 
# label(Greenhouse_Gas_Emissions) = as.list(var.labels[match(names(Greenhouse_Gas_Emissions), names(var.labels))])
# 
# label(Greenhouse_Gas_Emissions)
# 
# Greenhouse_Gas_Emissions <- Hmisc::upData(Greenhouse_Gas_Emissions, labels = var.labels)
