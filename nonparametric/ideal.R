# Mon Dec 11 14:15:07 PST 2017
#
# This is the high level code that I would *like* to run. It won't work
# because it will run out of memory

# A better way to do this is to specify a minimum bin width, ie. 0.01, and
# then make sure the bins are at least this wide. We also make sure they
# have a sufficient number of points.
# This seems like a reasonable dynamic binning scheme.
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


# Actual program
############################################################
#
# - Load data
# - Split based on column value
# - Apply a function to each group
# - Write the result

cc = strsplit("NULL NULL integer NULL NULL NULL NULL numeric numeric", " ")[[1]]
cc = c(cc, rep("NULL", 18))

# Read all the files in this directory
pems = read.table(pipe("cat ~/data/pems/*")
    , col.names = c("station", "flow2", "occupancy2")
    , colClasses = cc
    )
 
pems2 = split(pems, pems$station)

results = lapply(pems2, npbin)

results = do.call(rbind, results)

write.csv(results, "results.csv")
