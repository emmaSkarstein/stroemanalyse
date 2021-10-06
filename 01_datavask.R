##############################################################################
# DATAFORBEREDELSER
##############################################################################

library(dplyr)
library(lubridate)
library(ggplot2)
library(tidyverse)


clean_df <- function(data){
  data <- data %>% select(Fra, KWH.60.Forbruk)
  colnames(data) <- c("tid", "forbruk")
  data$tid <- as.POSIXct(data$tid, format = "%d.%m.%Y %H:%M")
  data$forbruk
  return(data)
}

load_all_files <- function(){
  filenames <- list.files("./raw_data")  
  megalist <- lapply(filenames, function(i){read.csv(paste0("./raw_data/", i), dec = ",", header = TRUE)})
  megaframe <- bind_rows(megalist)
  return(megaframe)
}

up_to_date_data <- clean_df(load_all_files())


