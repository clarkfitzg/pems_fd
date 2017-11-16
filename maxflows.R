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
pdf("congestion_event.pdf")
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
dev.off()

# What does a smoother look like on the whole data? This actually gives us
# far more freedom versus the triangular or piecewise linear one. And it's
# amenable to the clustering technique I'm already using.

s = smooth.spline(d$occupancy2, d$flow2, nknots = 5)

plot(s)

# Memory use quadratic in n - BAD!
#l = loess(flow2 ~ occupancy2, d)

# What if we just bin it and take the means?
# Then if we claim it's continuous we can just linearly interpolate.

cp = 0.2
breaks = unique(c(seq(from = 0, to = cp, by = 0.02), seq(from = cp, to = 1, by = 0.1)))

plot_bins = function(d, breaks, ...)
{
    grp = cut(d$occupancy2, breaks, right = FALSE)
    groups = split(d$flow2, grp)
    means = sapply(groups, mean)
    ci = lapply(groups, function(x) t.test(x)$conf.int)
    ci = do.call(rbind, ci)
    bp = breaks[-length(breaks)] + diff(breaks) / 2
    # This looks reasonable. But I would prefer to adjust the bins based on the
    # amount of data available in that area, ie. there may be very few
    # observations inside (0.7, 0.8)
    plot(c(0, bp, 1), c(0, means, 0), type = "l")
    lines(bp, ci[, 1], lty = 2)
    lines(bp, ci[, 2], lty = 2)
}

plot_bins(d, breaks)

d2 = d[order(d$occupancy2), ]
d2 = d2[d2$occupancy2 > 0, ]

# Only 100 observations in the area where occupancy is from 0.57 to 1
tail(d2$occupancy2, n = 100)

# If I want a certain number of points in each bin I can work backwards
# from here.


# A better way to do this is to specify a minimum bin width, ie. 0.01, and
# then make sure the bins are at least this wide. We also make sure they
# have a sufficient number of points.
# This seems like a reasonable dynamic binning scheme.
dyncut = function(x, pts_per_bin = 20, lower = 0, upper = 1, min_bin_width = 0.01)
{
    N = length(x)
    max_num_cuts = ceiling(upper / min_bin_width)
    eachq = pts_per_bin / N

    possible_cuts = quantile(x, probs = seq(from = 0, to = 1, by = eachq))
    cuts = rep(NA, max_num_cuts)
    current_cut = lower
    for(i in seq_along(cuts)){
        # Find the first possible cuts that is at least min_bin_width away from
        # the current cut
        possible_cuts = possible_cuts[possible_cuts > current_cut + min_bin_width]
        if(length(possible_cuts) == 0) 
            break
        current_cut = possible_cuts[1]
        cuts[i] = current_cut
    }
    cuts = cuts[!is.na(cuts)]
    c(lower, cuts, upper)
}

cuts = dyncut(d2$occupancy2, pts_per_bin = 200)

# This seems to have worked :)
# But it's pretty noisy as is
plot_bins(d2, cuts)

