# Mon Dec 11 14:15:07 PST 2017
#
# This is the high level code that I would *like* to run. It won't work
# because it will run out of memory

source("dyncut.R")

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
