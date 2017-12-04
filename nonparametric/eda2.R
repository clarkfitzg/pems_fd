# Mon Nov 27 15:34:44 PST 2017
library(scales)

source("inners.R")


# We can find a "median" or typical shape for the fundamental diagram

m = apply(fd_inners_scaled, 1, mean)
# Station 404887
which(m == max(m))

# From the histogram we see some are complete anomalies. Those aren't
# really representative of typical shapes then. Could be sensor failures or
# very weird traffic behavior.

# Quite interesting to vary this between 0.7 and 0.95
cutoff = 0.90
unusual = m < cutoff

sum(unusual)

stn2 = stn[!unusual]
fd_inners_scaled2 = fd_inners_scaled[!unusual, !unusual]

med = apply(fd_inners_scaled2, 1, median)
# Before filter: Station 404907
# After filter: Station 400429
medstn = stn2[med == max(med)][[1]]



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

