# Mon Nov 27 15:34:44 PST 2017

source("helpers.R")

load("~/data/pems/fd_inners_scaled.rds")

# We can find a "median" or typical shape for the fundamental diagram

m = apply(fd_inners_scaled, 1, mean)

# 1453
which(m == max(m))


med = apply(fd_inners_scaled, 1, median)
# 631
which(med == max(med))
