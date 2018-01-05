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

distwrap = function(s1, s2)
{
    distance(x1 = c(0, s1$right_end_occ)
                    , y1 = c(0, s1$mean_flow) 
                    , x2 = c(0, s2$right_end_occ) 
                    , y2 = c(0, s2$mean_flow) 
                    )
}

# Works
distwrap(stn[[1]], stn[[2]])

fd_dist = matrix(NA, nrow = N, ncol = N)

system.time(
for(i in 1:N){
    for(j in i:N){
        fij = distwrap(stn[[i]], stn[[j]])
        fd_dist[i, j] = fij
        fd_dist[j, i] = fij
    }
}
)

colnames(fd_dist) = rownames(fd_dist) = keep
