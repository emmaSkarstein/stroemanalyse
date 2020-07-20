##############################################################################
# DATAFORBEREDELSER
##############################################################################

library(dplyr)
library(lubridate)
library(ggplot2)
library(readxl)
library(here)


load_from_xls <- function(year, month){
  year = 19
  month = "09"
  filename <- paste0("original_files/", year, "_", month, "_strom.csv")
  data <- read.csv(filename)
  data <- data[2:nrow(data),]
  data$time <- as.character(data$Column1)
  data$time <- as.POSIXct(data$time, format = "%d.%m.%Y %H:%M")
  colnames(data) <- c("Fra", "Til", "forbruk", "time")
  forbruk <- as.character(data$forbruk)
  forbruk <- as.numeric(forbruk)
  data$forbruk <- as.numeric(levels(forbruk))[forbruk]
  data <- select(data, time, forbruk)
  #data$hour <- hour(data$time)
  #data$day <- day(data$time)
  #data$month <- month(data$time)
  #data$year <- year(data$time)
  saveRDS(data, here("data/", paste0(year, "_", month, "_strom.rds")))
  return(data)
}


merge_months <- function(months, year){
  filename <- paste0("csv_data/", year, "_", months[1], "_strom.csv")
  data <- read.csv(filename, sep = ";", dec = ",")
  for(i in 2:length(months)){
    filename <- paste0("csv_data/", year, "_", months[i], "_strom.csv")
    data <- rbind(data, read.csv(filename, sep = ";", dec = ","))
  }
  return(data)
}

clean_df <- function(data){
  data <- data %>% select(Fra, KWH.60.Forbruk)
  colnames(data) <- c("tid", "forbruk")
  data$tid <- as.POSIXct(data$tid, format = "%d.%m.%Y %H:%M")
  return(data)
}

