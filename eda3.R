# Mon Nov  6 07:52:15 PST 2017
#
# Looking at the results of the kernel based clustering.

library(cluster)

source("tools.R")

# Big file, I prefer to keep it out of git
d = read.table("~/data/pems/fd_inner.txt")

dm = as.matrix(d)

# From histogram some of these values are way out of line. We'll chop off
# the outliers because it's likely due to faulty sensors rather than
# any interesting phenomenon.

# These actually represent the squared function norms
norms = diag(dm)

# Chop off the upper and lower 1 percent
hilow = quantile(norms, probs = c(0.01, 0.99))
keepers = (hilow[1] < norms) & (norms < hilow[2])

# Sanity check, should be about 0.98
mean(keepers)

dm = dm[keepers, keepers]

# Scaling a similarity matrix into a correlation matrix
dcor = dm
N = nrow(dm)
# This is a nice use case for when a for loop is easy to write, but an
# apply function would be awkward.
# I didn't know why I was getting NA's, so I wanted to stop and check when
# it occurs.
for(i in 1:N){
    for(j in 1:N){
        dij = dm[i, j] / sqrt(dm[i, i] * dm[j, j])
        if(is.na(dij)) stop()
        dcor[i, j] = dij
    }
}

# Becomes a measure of dissimilarity
# Is it a metric? Only thing to verify is the triangle inequality
# Started to try this on paper, could come back if I feel like it.
D = as.dist(1 - dcor)


# Gets much worse as I increase the number of clusters, so it doesn't make
# sense to have more clusters.

pam1 = pam(D, 2)
#plot(pam1)


clusters = pam1$clustering

table(clusters)

fd = read.table("data/fdclean.tsv", header = TRUE)

# match clusters to stations
c2 = clusters[as.character(fd$station)]
fd$cluster = c2

# Remove those that didn't match
fd = fd[!is.na(fd$cluster), ]

# What do the representative FD's look like?
message('These are the "median" cluster for each group. Whatever that means')
print(pam1$medoids)

cluster1 = fd[fd$station == as.integer(pam1$medoids[1]), ]

cluster2 = fd[fd$station == as.integer(pam1$medoids[2]), ]

c2 = fd$cluster == 2

# This is only 0.84, so concavity mostly corresponds to the clustering, but
# not exactly.
mean(fd$right_convex == c2)

fd$ID = fd$station

write.csv(fd, "data/station_cluster.csv")
