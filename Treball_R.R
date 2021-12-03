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


#ETIQUETAR LES VARIABLES:
# !!! S'etiqueten per ordre, però no es comprova que el nom de la variable correspongui amb el nom de l'etiqueta!
var.labels <- Greenhouse_descr
label(Greenhouse_Gas_Emissions) = as.list(var.labels[,2])
label(Greenhouse_Gas_Emissions)
