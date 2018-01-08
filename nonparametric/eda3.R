# Fri Jan  5 10:20:22 PST 2018
# Run after distances.R

library(scales)
library(cluster)

source("helpers.R")

stn = load_station()

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

set.seed(9724)

pam1 = pam(D, 2)

# Slight evidence of clustering
plot(pam1)

# Including more clusters doesn't improve things.
plot(pam(D, 6))


station_cluster = data.frame(ID = names(pam1$clustering)
    , cluster = pam1$clustering
    , maxflow = OBS_HOUR * sapply(stn, function(s) max(s$mean_flow))
    )

write.csv(station_cluster, "../data/station_cluster.csv", row.names = FALSE)


# Plotting
############################################################

NLINES = 50

medoids = stn[pam1$medoids]
stn_cls = split(stn, pam1$clustering)

set.seed(31279)
c1 = stn_cls[[1]][sample.int(length(stn_cls[[1]]), size = NLINES)]
c2 = stn_cls[[2]][sample.int(length(stn_cls[[2]]), size = NLINES)]


pdf("high_flows.pdf", width = 6, height = 4)

lattice::densityplot(~maxflow, data = station_cluster, groups = cluster,
                     plot.points = FALSE, ref = TRUE,
                     auto.key = list(space = "right"), xlab = "vehicles per hour")

dev.off()


# This is way more appealing as a cluster. We see high and low flows
pdf("fd_2clusters.pdf", width = 8, height = 5)

par(mfrow = c(1, 2))
blank_plot(main = "Cluster 1")

lapply(c1, stn_lines, col = alpha("black", 0.1))
stn_lines(medoids[[1]], lwd = 3, col = "purple")

blank_plot(main = "Cluster 2")
lapply(c2, stn_lines, col = alpha("black", 0.1))
stn_lines(medoids[[2]], lwd = 3, col = "purple")

dev.off()




unusual = m > 6
sum(unusual)

medstn = stn[m == min(m)][[1]]

stn2 = stn[!unusual]

pdf("fd_typical_unusual.pdf", width = 8, height = 5)

par(mfrow = c(1, 2))

set.seed(23978)
samp = stn2[sample.int(length(stn2), size = NLINES)]
blank_plot(main = "Typical FDs", sub = "bold line represents the 'median' station")
lapply(samp, stn_lines, col = alpha("black", 0.1))
stn_lines(medstn, lwd = 3, col = "purple")

blank_plot(main = "Unusual Stations")
lapply(stn[unusual], stn_lines, col = alpha("black", 0.1))

dev.off()


