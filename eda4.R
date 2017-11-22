# Tue Nov 14 12:58:03 PST 2017
# Following up on a couple things before meeting Michael

source("tools.R")

s = read.csv("data/station_cluster.csv")

# Capacity in vehicles / hr
s$capacity = s$lefty * 2 * 60

with(s, hist(capacity))

# Parameters related to analysis
LEFT_RIGHT = 0.1
MIDDLE_LEFT = 0.2
MIDDLE_RIGHT = 0.5
RIGHT_LEFT = 0.5


# What's the slope in mph? 
# Expecting between -10 and - 15 mph.
vehicle_length = 18
ft_per_mile = 5280
mph_multiplier = 2 * 60 / (ft_per_mile / vehicle_length)
s$mid_slope_mph = mph_multiplier * s$mid_slope
s$right_slope_mph = mph_multiplier * s$right_slope

# Sanity check: Typically around 60 - 70 mph
hist(mph_multiplier * s$left_slope
     , main = "Slope of free flow area of FD", xlab = "MPH")

hist(qtrim(s$mid_slope_mph)
     , main = "Slope of FD between 0.2 and 0.5 density", xlab = "MPH")

hist(qtrim(s$right_slope_mph)
     , main = "Slope of FD greater than 0.5 density", xlab = "MPH")

s2 = split(s, s$cluster)

par(mfrow = c(2, 1))

lapply(s2, function(x) hist(x$capacity))
