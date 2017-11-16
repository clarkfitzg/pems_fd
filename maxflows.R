# Thu Nov 16 09:22:19 PST 2017
#
# Attempting to find peak flow by finding all areas where the occupancy
# increases, say from 0.1 to 0.3. Flow should increase then decrease.

d = read.csv("~/data/pems/401395.csv", row.names = NULL)
# Drop row names
d = d[, -1]

d$timestamp = as.POSIXct(d$timestamp, format = "%Y-%m-%d %H:%M:%S")

# Check that it's sorted

delta = diff(d$timestamp)

delta2 = as.numeric(delta)

# Some huge ones
hist(delta2)

sum(delta2 > 100)

# Could break it into chunks where the delta is small.

# Let's try plotting one occasion, see if it looks as expected.
start = which(d$occupancy2 > 0.2)[1]
nbr = 20
congest = d[seq(from = start - nbr, to = start + nbr), ]

# In the top right plot the data hovers around 0.1 before it hits the
# congested state
par(mfrow = c(3, 2))
with(congest, {
     plot(timestamp, occupancy1, type = "l")
     plot(timestamp, occupancy2, type = "l")
     abline(h = 0.2, col = "red")
     abline(h = 0.1, col = "red", lty = 2)
     plot(timestamp, flow1, type = "l")
     plot(timestamp, flow2, type = "l")
     plot(timestamp, speed1, type = "l")
     plot(timestamp, speed2, type = "l")
})

# What does a smoother look like on the whole data? This actually gives us
# far more freedom versus the triangular or piecewise linear one. And it's
# amenable to the clustering technique we have.
