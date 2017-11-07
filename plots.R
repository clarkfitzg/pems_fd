source("tools.R")

station_cluster = read.csv("data/station_cluster.csv")


cluster1 = station_cluster[station_cluster$ID == 401000, ]
cluster2 = station_cluster[station_cluster$ID == 402261, ]

svg("web/cluster_fd.svg")

plot(c(0, 1), c(0, max(cluster1$lefty, cluster2$lefty)), type = "n"
     , main = "Cluster medoids"
     , xlab = "occupancy"
     , ylab = "flow (veh / 30 sec)")
plotfd(cluster1, col = colors[1])
plotfd(cluster2, col = colors[2])
legend("topright", legend = c("Cluster 1", "Cluster 2")
       , col = colors, lty = 1)

dev.off()

# Cool!
# The most obvious feature is that one function is concave while the other
# is not.


