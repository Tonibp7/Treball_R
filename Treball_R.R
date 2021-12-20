setwd("C:/Users/Usuari/Documents/MESIO/R and SAS/R/TREBALL")
#setwd("")
#setwd("")
#install.packages("readxl")
#install.packages("httr")
#install.packages("cowplot")

# libraries
library(readxl)
library(httr)
library(Hmisc)
library(tidyverse)
library(grid)
library(gridExtra)
library(cowplot)

# a) Read the excel file
url_data <- "https://github.com/owid/co2-data/raw/master/owid-co2-data.xlsx"
GET(url_data, write_disk(TF_data <- tempfile(fileext = ".xlsx")))
Greenhouse_Gas_Emissions <- read_excel(TF_data)
str(Greenhouse_Gas_Emissions)
url_descr <- "https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-codebook.csv"
GET(url_descr, write_disk(TF_descr <- tempfile(fileext = ".csv")))
Greenhouse_descr <- read.csv(TF_descr)


# b) ETIQUETAR LES VARIABLES:
# !!! S'etiqueten per ordre, però no es comprova que el nom de la variable correspongui amb el nom de l'etiqueta!
# Hi hauríem de posar les unitats a cada variable?
var.labels <- Greenhouse_descr
label(Greenhouse_Gas_Emissions) = as.list(var.labels[,2])
label(Greenhouse_Gas_Emissions)

# c) Dimension of the dataframe
print(paste0("In this dataset there are ", dim(Greenhouse_Gas_Emissions)[1], " observations of ", dim(Greenhouse_Gas_Emissions)[2], " variables related to the Greenhouse effect gas emitions"))
#Vol que fem una descripció de cada variable??? :-S

# d)Represent graphically co2, methane and nitrous oxide together by country and year. Can be possible all countries or a selection of a country, according to the request made.
#Filter the top 25% most polluting countries
not_countries <- c("Africa", "Asia", "Asia (excl. China & India)", "EU-27", "EU-28", "Europe", "Europe (excl. EU-27)", "Europe (excl. EU-28)", "International transport", "Kuwaiti Oil Fires", "Oceania", "North America", "North America (excl. USA)", "South America", "World" )

# top_20_co2_countries <- Greenhouse_Gas_Emissions %>%
#   select(country, co2, methane, nitrous_oxide, year) %>%
#   filter(year >= 2010 & !(country %in% not_countries)) %>%
#   arrange(desc(co2)) %>%
#   group_by(country) %>%
#   slice_head(n = 20)
  
Quart <- Greenhouse_Gas_Emissions %>%
  select(country, co2, methane, nitrous_oxide, year) %>%
  filter(year >= 2010 & !(country %in% not_countries)) %>%
  summarise(qco2 = quantile (co2, probs = seq(0.8, 1, 0.05), na.rm = TRUE))

Greenhouse_Gas_Emissions %>%
  select(country, co2, methane, nitrous_oxide, year) %>%
  filter(year >= 1970, co2 >= as.numeric(Quart[4,]) & !(country %in% not_countries)) %>%
   ggplot() + 
     geom_line(aes(x = year, y = co2, color = country)) #+
     #theme(legend.position = "none")

# e) Aggregate data-frame by decade and select data only by 3 last decades 
#(1990-2000, 2000-2010, 2010-2020)

Greenhouse_Gas_Emissions <- Greenhouse_Gas_Emissions %>%
  mutate(decade = paste0(year  %/% 10 * 10, "-", (year + 10) %/% 10 * 10 ))

last_decades <- Greenhouse_Gas_Emissions %>%
  filter(decade %in% c("1990-2000", "2000-2010", "2010-2020"))
# f) Calculate the mean, median, standard deviation and the interquartile range for each of the previous
# groups (or other statistics if necessary) for all quantitative variables (co2, co2 per-capita, ...). You
# can present other statistics suitable for this type of data, which you think are convenient.

mean_last_decad <- last_decades %>%
  group_by(decade) %>%
  select_if(is.numeric) %>%
  select(-year) %>%
  summarise_all(mean, na.rm = TRUE)

# Està bé fer-ho així? Faltaria fer median, quartile, etc. D'aquesta manera queda una tibble per cada statistic.

# g) Properly represent the data to be able to see the decade variations of the average co2,methane and
# nitrous oxide in the total countries and country by country (maybe a selection of ten with more co2production).

ggplot(data = mean_last_decad, aes(x= decade, y= co2)) + 
  geom_line() +
  geom_point()

# Com es connecten els punts entre ells?


top_co2_countries <- last_decades %>%
  select(c(decade,country, year, co2)) %>%
  filter(!country %in% not_countries) %>%
  group_by(country) %>%
  summarise(mean = mean(co2, na.rm = TRUE)) %>%
  arrange(desc(mean)) %>%
  top_n(10)

plot_co2 <- function(fcountry, dataframe = last_decades) {
  ftitle <- paste0("Evolution of CO2 emissions in: ", fcountry)
  last_decades %>%
    filter(country == fcountry) %>%
      ggplot(aes(x = year, y = co2)) + 
        geom_line() + 
        geom_point() + 
        labs(title = ftitle)
}

for (row in 1:nrow(top_co2_countries)) {
  print(plot_co2(as.character(top_co2_countries[row,1])))
}

# do the same for the other metrics




# EXERCISE 2






# EXERCISE 3
# 
# a) Calculate the percentage increase between one decade and the following decade (eg. between 1990 - 
#2000 and 2000-2010) for co2, methane and nitrous oxide together by each required country and
# decade, offer a graph per country required and the average of all years studied. You should be able
# to indicate what decades or countries it should represent.

perc <- last_decades %>%
  filter(!(country %in% not_countries)) %>%
  group_by(decade) #%>%
  #summarise()






# b) Try to calculate the projection of co2, methane and nitrous oxide by country requiered. Use a
# linear model to this computation (lm): For this, supposed that decade 1990-2000 has the value 1,
# 2000-2010 the value of 2 and so consecutively so it can be transformed into a regression model.
# You should be able to indicate what country it should represent. Use this example of prediction:
#   https://stat.ethz.ch/R-manual/R-devel/library/stats/html/predict.lm.html






# c) Comment on the results found and if you think they have effects on climate change. Optionally, you
# can build a library to project the future of co2, methane and nitrous oxide and calculate statistics
