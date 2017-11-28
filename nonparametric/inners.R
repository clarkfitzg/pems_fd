source("helpers.R")

fd_shape = read.table("../data/fd_shape.tsv"
    , col.names = c("station", "right_end_occ", "mean_flow", "sd_flow", "number_observed")
    , colClasses = c("integer", "numeric", "numeric", "numeric", "integer")
    , na.strings = "NULL"
    )

# Making this harder than it has to be...
keep = read.csv("../data/keep.csv")[, 1]
stn = split(fd_shape, fd_shape$station)
keep_logical = sapply(stn, function(x) all(x$station %in% keep))
stn = stn[keep_logical]

N = length(stn)

inner = function(s1, s2)
{
    piecewise_inner(x1 = c(0, s1$right_end_occ)
                    , y1 = c(0, s1$mean_flow) 
                    , x2 = c(0, s2$right_end_occ) 
                    , y2 = c(0, s2$mean_flow) 
                    )
}

# Works
inner(stn[[1]], stn[[2]])

# Doesn't work :(
# fd_inners <- outer(stn, stn, inner)

fd_inners = matrix(NA, nrow = N, ncol = N)

# Takes 15 minutes. Numerical integration took 2+ hours with the three
# lines.
# Using a vectorized version on a smaller set took ~4 minutes. Still slow.
# This profiling might be a good exercise for the reading group.
Rprof("inners.out")
system.time(
for(i in 1:N){
    for(j in i:N){
        fij = inner(stn[[i]], stn[[j]])
        fd_inners[i, j] = fij
        fd_inners[j, i] = fij
    }
}
)
Rprof(NULL)

colnames(fd_inners) = rownames(fd_inners) = keep

fd_inners_scaled = corscale(fd_inners)
