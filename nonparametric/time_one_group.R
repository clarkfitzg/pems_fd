# How long to do just one group?

dyncut = function(x, pts_per_bin = 200, lower = 0, upper = 1, min_bin_width = 0.01)
{
    x = x[x < upper]
    N = length(x)
    max_num_cuts = ceiling(upper / min_bin_width)
    eachq = pts_per_bin / N

    possible_cuts = quantile(x, probs = seq(from = 0, to = 1, by = eachq))
    cuts = rep(NA, max_num_cuts)
    current_cut = lower
    for(i in seq_along(cuts)){
        # Find the first possible cuts that is at least min_bin_width away from
        # the current cut
        possible_cuts = possible_cuts[possible_cuts >= current_cut + min_bin_width]
        if(length(possible_cuts) == 0) 
            break
        current_cut = possible_cuts[1]
        cuts[i] = current_cut
    }
    cuts = cuts[!is.na(cuts)]
    c(lower, cuts, upper)
}

# Non parametric binned means
npbin = function(x)
{
    breaks = dyncut(x$occupancy2, pts_per_bin = 200)
    binned = cut(x$occupancy2, breaks, right = FALSE)
    groups = split(x$flow2, binned)

    out = data.frame(station = rep(x[1, "station"], length(groups))
        , right_end_occ = breaks[-1]
        , mean_flow = sapply(groups, mean)
        , sd_flow = sapply(groups, sd)
        , number_observed = sapply(groups, length)
    )
    out
}
 
n = 1e6
x = data.frame(occupancy2 = runif(n), flow2 = rpois(n, 1))
x$station = 1L

# About 16 MB for 1 group
os1 = object.size(x)

# Takes about 0.26 seconds to compute one group
t1 = system.time(result <- npbin(x))["elapsed"]

# There are around 3000 groups total
ngroups = 3000
total_comp_time = t1 * ngroups
# 792 seconds of actual compute time.

total_data_size = os1 * ngroups
print(total_data_size, units = "GB")
# ~ 45 GB in memory

w = 64
lower_bound_parallel = total_comp_time / w
# Around 12 seconds lower bound.
# The 4 node Hive cluser takes 12 minutes- to read everything in from disk and do all the GROUP BY business
