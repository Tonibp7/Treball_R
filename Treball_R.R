#setwd("C:/Users/Usuari/Documents/MESIO/R and SAS/R/TREBALL")
#setwd("")
#setwd("")
#install.packages("readxl")
#install.packages("httr")

# libraries
library(readxl)
library(httr)

# Read the excel file
url <- "https://github.com/owid/co2-data/raw/master/owid-co2-data.xlsx"
GET(url, write_disk(TF <- tempfile(fileext = ".xlsx")))
Greenhouse_Gas_Emissions <- read_excel(TF)
str(Greenhouse_Gas_Emissions)
