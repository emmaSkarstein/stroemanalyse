##############################################################################
# DATAFORBEREDELSER
##############################################################################

library(dplyr)
library(lubridate)
library(ggplot2)
library(readxl)


load_from_xls <- function(month){
  filename <- paste0(month, "_strom.xlsx")
  data <- read_excel(filename)
  data <- data[2:nrow(data),]
  data$time <- as.character(data$Column1)
  data$time <- as.POSIXct(data$time, format = "%d.%m.%Y %H:%M")
  colnames(data) <- c("Fra", "Til", "forbruk", "time")
  data$forbruk <- as.numeric(data$forbruk)
  data <- select(data, time, forbruk)
  data$hour <- hour(data$time)
  data$day <- day(data$time)
  data$month <- month(data$time)
  data$year <- year(data$time)
  saveRDS(data, paste0(month, "strom.rds"))
  return(data)
}

merge_months <- function(months){
  data <- readRDS(paste0(months[1], "strom.rds"))
  for(i in 2:length(months)){
    data <- rbind(data, readRDS(paste0(months[i], "strom.rds")))
  }
  return(data)
}

