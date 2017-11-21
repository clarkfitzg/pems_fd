library(RHive)


# Non parametric binned means
npbin = function(x)
{
    breaks = dyncut(x$occupancy2, pts_per_bin = 200)
    binned = cut(d$occupancy2, breaks, right = FALSE)
    groups = split(d$flow2, binned)

    out = data.frame(station = rep(x[1, "station"], length(groups))
        , right_end_occ = breaks[-1]
        , mean_flow = sapply(groups, mean)
        , sd_flow = sapply(groups, sd)
        , number_observed = sapply(groups, length)
    )
}
       
 
write_udaf_scripts(f = npbin
    , cluster_by = "station"
    , input_table = "pems"
    , input_cols = c("station", "flow2", "occupancy2")
    , input_classes = c("integer", "integer", "numeric")
    , output_table = "fd_shape"
    , output_cols = c("station", "right_end_occ", "mean_flow", "sd_flow", "number_observed")
    , output_classes = c("integer", "numeric", "numeric", "numeric", "integer")
    , base_name = "fd_shape"
    , include_script = "dyncut.R"
    , overwrite_script = TRUE
    , overwrite_table = TRUE
    , try = TRUE
)
