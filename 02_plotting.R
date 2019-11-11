##############################################################################
# Plotting
##############################################################################

# Load data 
source("01_datavask.R")

data <- load_from_xls("01")


data <- merge_months(c("01", "02", "03", "04", "05", "06", "07", "08"))


ggplot(data, aes(x = time, y = forbruk)) + 
  geom_line()

ggplot(data, aes(x = time, y = forbruk))+
  geom_col(aes(fill = hour))+
  theme(axis.text.x = element_text(angle = 90))

summary(data)


