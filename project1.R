## libraries
library(dplyr)
library(lubridate)
library(lattice)
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

## mean and meadian of total steps taken per day
total_step_mean <- mean(data_steps$total_step, na.rm = TRUE)
total_step_median <- median(data_steps$total_step, na.rm = TRUE)

## average daily activity
data_intAvg <- data %>% group_by(interval) %>% summarize(interval_avg = mean(steps, na.rm = TRUE))
plot(data_intAvg$interval_avg, type = "l",  main = "TS of average steps taken per interval")

## interval with maximum
interval_max <- with(data_intAvg, interval[which.max(interval_avg)])

##### Fill missing number
## Missing number
missingTotal <- sum(is.na(data))

## fill themissing values
na_index <- which(is.na(data)) ## find the index of missing 

## match interval index of missing values
pattern_index <- match(data[na_index, "interval"], data_intAvg$interval) 
                                                                    
## create data with filled missing values
data_fill <- data
data_fill[na_index, "steps"] <- data_intAvg[pattern_index, "interval_avg"]

## histogram of total steps per day with filled data
datafill_steps <- data_fill %>% group_by(date) %>% summarize(total_step = sum(steps, na.rm = TRUE))
hist(datafill_steps$total_step, breaks = 10, 
     main = "Histogram of total number of steps each day", 
     xlab = "total number of steps each day")

## mean and meadian of total steps taken per day
total_step_mean_filled <- mean(datafill_steps$total_step, na.rm = TRUE)
total_step_median_filled <- median(datafill_steps$total_step, na.rm = TRUE)


#### week days vs weekend
## create weekday/weekend factor
data_fill <- data_fill %>% transform(day = factor(ifelse(
    weekdays(date) %in% c("Saturday", "Sunday"), "weekend", "weekday")))

data_fill_avg <- data_fill %>% group_by(interval, day) %>% summarize(interval_avg = mean(steps, na.rm = TRUE))
xyplot(interval_avg ~ interval | day, data = data_fill_avg, type = "l", 
       layout = c(1,2), xlab = "Interval", ylab = "Number of Steps")
