##############################################################################
# Plotting
##############################################################################

# Load data 
source("01_datavask.R")

#data <- load_from_xls("01")
#readRDS("data/01strom.rds")

#data <- merge_months(c("01", "02", "03", "04", "05", "06", "07", "08"))

data <- up_to_date_data
data$date <- as.Date(data$tid)
data$month <- as.factor(month(data$tid))
data$weekday <- as.factor(weekdays(data$tid))
data$year <- year(data$tid)


summary(data)
str(data)
class(data$month)

ggplot(data, aes(x = tid, y = forbruk)) + 
  geom_line()

ggplot(data, aes(x = tid, y = forbruk))+
  geom_col(aes(fill = hour))+
  theme(axis.text.x = element_text(angle = 90))

summary(data)

# Total amount spent per day
data %>% aggregate(by = list("month"), nfrequency = 12, FUN = sum)


# Convert to time series object
library(xts)
data_xts <- as.xts(data[-1], order.by = data[[1]], dateFormat = "Date")
periodicity(data_xts)
test <- to.period(data_xts, period="day")

day_ep <- endpoints(data_xts, on="days")  
month_ep <- endpoints(data_xts, on="months") 
dayly_sum <- period.apply(data_xts, INDEX = day_ep, FUN = sum)
monthly_sum <- period.apply(data_xts, INDEX = month_ep, FUN = sum)
plot(dayly_sum)
plot(monthly_sum)

ggplot(data_xts, aes(x = Index, y = forbruk)) +
  geom_col() +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") + xlab("")


str(data_xts)

daily_data <- data %>%
  group_by(day, month) %>%
  summarise(sum_forb = sum(forbruk))


library(forecast)
d.arima <- auto.arima(data_xts)
d.forecast <- forecast(d.arima, level = c(95), h = 50)
autoplot(d.forecast)