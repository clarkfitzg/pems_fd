# Tue Nov 21 10:22:45 PST 2017
library(cluster)

source("helpers.R")

fd_shape = read.table("../data/fd_shape.tsv"
    , col.names = c("station", "right_end_occ", "mean_flow", "sd_flow", "number_observed")
    , colClasses = c("integer", "numeric", "numeric", "numeric", "integer")
    , na.strings = "NULL"
    )

stn = split(fd_shape, fd_shape$station)

hasNA = sapply(stn, function(x) any(is.na(x$sd_flow)))
toosmall = sapply(stn, function(x) all(x$mean_flow < 1))
toofew = sapply(stn, function(x) nrow(x) < 10)

# Drop the bad cases
stn[hasNA | toosmall | toofew] = NULL

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
system.time(
for(i in 1:N){
    for(j in i:N){
        fij = inner(stn[[i]], stn[[j]])
        fd_inners[i, j] = fij
        fd_inners[j, i] = fij
    }
}
)


# Clustering
############################################################

fd_inners_scaled = corscale(fd_inners)

save(fd_inners_scaled, file = "~/data/pems/fd_inners_scaled.rds")

save(fd_inners, file = "~/data/pems/fd_inners.rds")

D = as.dist(1 - fd_inners_scaled)

# 2 clusters look best, but 3 is not totally unreasonable
pam1 = pam(D, 2)
plot(pam1)


clusters = pam1$clustering

table(clusters)

medoids = stn[pam1$medoids]

plot(c(0, 1), c(0, 20), type = "n")
lapply(medoids, stn_lines)


# Looking at the above, the 2nd medoid only has 160 observations where
# occupancy is greater than 0.15. Lets try looking just at stations that
# have more observations in the areas of high density

HI_OCC = 0.2
NHI_BINS = 10
toolow = sapply(stn, function(x) sum(x$right_end_occ > HI_OCC) < NHI_BINS)
mean(toolow)

stn2 = stn[!toolow]

fd_inners_scaled2 = fd_inners_scaled[!toolow, !toolow]

D2 = as.dist(1 - fd_inners_scaled2)

# There's really just one dominant shape, less evidence that there are
# multiple types of fundamental diagrams.
pam2 = pam(D2, 2)
plot(pam2)

medoids2 = stn2[pam2$medoids]

plot(c(0, 1), c(0, 20), type = "n")
lapply(medoids2, stn_lines)

# We can get some idea of what the typical fds look like by plotting more
# of them.
library(scales)

NLINES = 100

stn_cls = split(stn2, pam2$clustering)

set.seed(31279)
c1 = stn_cls[[1]][sample.int(length(stn_cls[[1]]), size = NLINES)]
c2 = stn_cls[[2]][sample.int(length(stn_cls[[2]]), size = NLINES)]

pdf("fd_2clusters.pdf", width = 8, height = 5)
par(mfrow = c(1, 2))
plot(c(0, 1), c(0, 20), type = "n", main = "Cluster 1"
     , xlab = "occupancy", ylab = "flow")
lapply(c1, stn_lines, col = alpha("black", 0.1))
stn_lines(medoids2[[1]], lwd = 3)
plot(c(0, 1), c(0, 20), type = "n", main = "Cluster 2"
     , xlab = "occupancy", ylab = "flow")
lapply(c2, stn_lines, col = alpha("black", 0.1))
stn_lines(medoids2[[2]], lwd = 3)
dev.off()

# These seem to show a single dominant shape, with some deviating
# considerably.
