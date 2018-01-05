# Fri Jan  5 10:20:22 PST 2018
# Run after distances.R

library(scales)
library(cluster)

source("helpers.R")

load("~/data/pems/fd_dist.rds")

# This shows distances following something like an exponential
# distribution, with a mean distance of around 2.
hist(fd_dist)

# We can find a "median" or typical shape for the fundamental diagram
m = apply(fd_dist, 1, median)

# Station 404907 has a median distance of 1.47 to all the other stations.
m[m == min(m)]

# Many other stations have a similar property.
hist(m)


# Clustering
############################################################

D = as.dist(fd_dist)

pam1 = pam(D, 2)

# We see no evidence of clustering
plot(pam1)

# Including more clusters doesn't help.
plot(pam(D, 6))


stn = load_station()

NLINES = 50

medoids = stn[pam1$medoids]
stn_cls = split(stn, pam1$clustering)

set.seed(31279)
c1 = stn_cls[[1]][sample.int(length(stn_cls[[1]]), size = NLINES)]
c2 = stn_cls[[2]][sample.int(length(stn_cls[[2]]), size = NLINES)]


pdf("fd_2clusters.pdf", width = 6, height = 4)

par(mfrow = c(1, 2))
blank_plot(main = "Cluster 1")

lapply(c1, stn_lines, col = alpha("black", 0.1))
stn_lines(medoids[[1]], lwd = 3)

blank_plot(main = "Cluster 2")
lapply(c2, stn_lines, col = alpha("black", 0.1))
stn_lines(medoids[[2]], lwd = 3)

dev.off()

# This is way more appealing as a cluster
