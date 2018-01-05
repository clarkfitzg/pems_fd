# Mon Nov 27 15:34:44 PST 2017
library(scales)

source("distances.R")

# This shows distances following something like an exponential
# distribution, with a mean distance of around 2.
hist(fd_dist)

# We can find a "median" or typical shape for the fundamental diagram

m = apply(fd_dist, 1, median)

# Station 404907 has a median distance of 1.47 to all the other stations.
m[m == min(m)]

# Many other stations have a similar property.
hist(m)



pdf("fd_typical_unusual.pdf", width = 8, height = 5)

par(mfrow = c(1, 2))

NLINES = 100
set.seed(23978)
samp = stn2[sample.int(length(stn2), size = NLINES)]
blank_plot(main = "Typical FDs", sub = "bold line represents the 'median' station")
lapply(samp, stn_lines, col = alpha("black", 0.1))
stn_lines(medstn, lwd = 3, col = "purple")

blank_plot(main = "Unusual Stations")
lapply(stn[unusual], stn_lines, col = alpha("black", 0.1))

dev.off()


# We can examine the median station further
ms = veh_hr_scale(medstn, vlength = 22)

fit_lo = lm(mean_flow ~ right_end_occ, data = ms[ms$right_end_occ < 35, ])

fit_hi = lm(mean_flow ~ right_end_occ, data = ms[ms$right_end_occ > 50, ])

