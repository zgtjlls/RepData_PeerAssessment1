## libraries
library(dplyr)
library(lubridate)
## Set work directory and download data
setwd("~/Documents/Coursera/Data Science/Reproducible Research/project1/RepData_PeerAssessment1")

## Load data
data <- read.csv(unz("activity.zip" , "activity.csv"))
data$date <- ymd(data$date)

## histogram of steps for each day
table(data$date)
data_steps <- data %>% group_by(date) %>% summarize(total_step = sum(steps, na.rm = TRUE))
hist(data_steps$total_step, breaks = 10, 
     main = "Histogram of total number of steps each day", 
     xlab = "total number of steps each day")
