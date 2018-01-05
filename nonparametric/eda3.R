# Fri Jan  5 10:20:22 PST 2018
# Run after distances.R

library(cluster)

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
