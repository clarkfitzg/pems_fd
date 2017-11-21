#!/usr/bin/env Rscript

# 
# Automatically generated from R by RHive version 

# These values are specific to the analysis
verbose = FALSE
rows_per_chunk = 1000000
cluster_by = "station"
sep = '\t'
input_cols = c("station", "flow2", "occupancy2")
input_classes = c("integer", "integer", "numeric")
try = TRUE
f = function (x) 
{
    breaks = dyncut(x$occupancy2, pts_per_bin = 200)
    binned = cut(d$occupancy2, breaks, right = FALSE)
    groups = split(d$flow2, binned)
    out = data.frame(station = rep(x[1, "station"], length(groups)), 
        right_end_occ = breaks[-1], mean_flow = sapply(groups, 
            mean), sd_flow = sapply(groups, sd), number_observed = sapply(groups, 
            length))
}


# Other code that the user wanted to include, such as supporting functions
# or variables:
############################################################

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

# The remainder of the script is a generic template
############################################################


# Logging to stderr() writes to the Hadoop logs where we can find them.
msg = function(..., log = verbose)
{
    if(log) writeLines(paste(...), stderr())
}


multiple_groups = function(queue, g = cluster_by) length(unique(queue[, g])) > 1


process_group = function(grp, outfile, try = try)
{
    msg("Processing group", grp[1, cluster_by])

    if(try) {try({
        # TODO: log these failures
        out = f(grp)
        write.table(out, outfile, col.names = FALSE, row.names = FALSE, sep = sep)
    })} else {
        out = f(grp)
        write.table(out, outfile, col.names = FALSE, row.names = FALSE, sep = sep)
    }
}


msg("BEGIN R SCRIPT")
############################################################

stream_in = file("stdin")
open(stream_in)
stream_out = stdout()

# Initialize the queue
# TODO: parameterize Hive's na.strings
queue = read.table(stream_in, nrows = rows_per_chunk, colClasses = input_classes
    , col.names = input_cols, na.strings = "\\N")

while(TRUE) {
    while(multiple_groups(queue)) {
        # Pop the first group out of the queue
        nextgrp = queue[, cluster_by] == queue[1, cluster_by]
        working = queue[nextgrp, ]
        queue = queue[!nextgrp, ]

        process_group(working, stream_out)
    }

    # Fill up the queue
    nextqueue = read.table(stream_in, nrows = rows_per_chunk
        , colClasses = input_classes, col.names = input_cols, na.strings = "\\N")
    if(nrow(nextqueue) == 0) {
        msg("Last group")
        try(process_group(queue, stream_out))
        break
    }
    queue = rbind(queue, nextqueue)
}

msg("END R SCRIPT")
