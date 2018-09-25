myGL <- read.csv("GL.csv")

myGL$Date <- as.Date(myGL$Date, format="%Y-%m-%d")

library(lubridate)
library(magrittr)
library(dplyr)
options(scipen=999)  
library(ggplot2)
theme_set(theme_bw())
library(xts)


myGL <- subset(myGL, year(Date) %in% c("2015","2016","2017"))
myGL <- subset(myGL, State != "-1")
myGL <- subset(myGL, SupplierCountry != "-1")
myGL <- subset(myGL, is.finite(Amount))
myGL$Month <- factor(month(myGL$Date))
myGL$Year <- factor(year(myGL$Date))
myGL$Time  <- as.yearmon(myGL$Date)

latlong <- read.csv("statelatlong.csv")

myGL <- merge(x = myGL, y = latlong[ , c("State", "Latitude","Longitude")], by = "State", all.x=TRUE)

GL <- myGL %>%
  group_by(Segment,State,Latitude,Longitude,Year,Month,Time) %>%
  summarise(Amount = sum(Amount))

