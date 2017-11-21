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
