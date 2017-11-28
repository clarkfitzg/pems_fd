# Mon Nov 27 15:47:18 PST 2017
# 
# All the filtering happens here.

fd_shape = read.table("../data/fd_shape.tsv"
    , col.names = c("station", "right_end_occ", "mean_flow", "sd_flow", "number_observed")
    , colClasses = c("integer", "numeric", "numeric", "numeric", "integer")
    , na.strings = "NULL"
    )

stn = split(fd_shape, fd_shape$station)

Nstations_start = length(stn)

hasNA = sapply(stn, function(x) any(is.na(x$sd_flow)))
toosmall = sapply(stn, function(x) all(x$mean_flow < 1))
toofew = sapply(stn, function(x) nrow(x) < 10)

HI_OCC = 0.2
NHI_BINS = 10
toolow = sapply(stn, function(x) sum(x$right_end_occ > HI_OCC) < NHI_BINS)

bad = hasNA | toosmall | toofew | toolow

write.table

Nstations_after = length(stn)
Nstations_after / Nstations_start

save(stn, file = "~/data/pems/clean_stn.rds")
