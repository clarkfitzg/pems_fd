# Tue Nov 21 09:27:23 PST 2017

VLENGTH = 22
OBS_HOUR = 120
FT_MILE = 5280

VEH_MILE = FT_MILE / VLENGTH


load_station = function(f = "../data/fd_shape.tsv")
{
    fd_shape = read.table(f
        , col.names = c("station", "right_end_occ", "mean_flow", "sd_flow", "number_observed")
        , colClasses = c("integer", "numeric", "numeric", "numeric", "integer")
        , na.strings = "NULL"
        )

    # Making this harder than it has to be...
    keep = read.csv("../data/keep.csv")[, 1]
    stn = split(fd_shape, fd_shape$station)
    keep_logical = sapply(stn, function(x) all(x$station %in% keep))
    stn = stn[keep_logical]
    stn
}


veh_hr_scale = function(obs, vlength = VLENGTH, obs_hour = OBS_HOUR)
{
    obs$right_end_occ = obs$right_end_occ * VEH_MILE
    obs$mean_flow = obs$mean_flow * obs_hour
    obs$sd_flow = obs$sd_flow * obs_hour
    obs
}


# Given observations of linear functions f and g at points a and b this
# calculates the integral of f * g from a to b.
#
# Looks like it will already work as a vectorized function. Sweet!
inner_one_piece = function(a, b, fa, fb, ga, gb)
{
    # Roughly following my notes
    fslope = (fb - fa) / (b - a)
    gslope = (gb - ga) / (b - a)

    fint = fa - fslope * a
    gint = ga - gslope * a

    # polynomial coefficients for integral
    p3 = fslope * gslope / 3
    p2 = (fint * gslope + fslope * gint) / 2
    p1 = fint * gint

    (p3*b^3 + p2*b^2 + p1*b) - (p3*a^3 + p2*a^2 + p1*a)
}


# Compute the distance based on function inner product:
#
# sqrt(<f-g, f-g>)
distance = function(x1, y1, x2, y2)
{
    x = sort(unique(c(x1, x2)))
    f = approx(x1, y1, xout = x)$y
    g = approx(x2, y2, xout = x)$y

    delta = f - g

    a = -length(x)
    b = -1
    parts = inner_one_piece(x[a], x[b], delta[a], delta[b], delta[a], delta[b])
    sqrt(sum(parts))
}


# Compute function inner product on two piecewise linear functions
#
# x1, y1 are vectors of corresponding x and y coordinates that define a
# piecewise linear function on [0, 1].
# Same for x2, y2.
piecewise_inner = function(x1, y1, x2, y2)
{
    x = sort(unique(c(x1, x2)))
    f = approx(x1, y1, xout = x)$y
    g = approx(x2, y2, xout = x)$y

    a = -length(x)
    b = -1
    parts = inner_one_piece(x[a], x[b], f[a], f[b], g[a], g[b])
    sum(parts)
}


# Scale the similarity matrix into a correlation matrix
#
# I don't know how to cleanly vectorize this.
corscale = function(x)
{
    xnew = x
    N = nrow(x)
    for(i in 1:N){
        for(j in i:N){
            dij = x[i, j] / sqrt(x[i, i] * x[j, j])
            if(is.na(dij)) stop()
            xnew[i, j] = dij
            xnew[j, i] = dij
        }
    }
    xnew
}


blank_plot = function(...)
{
    x = c(0, 1) * VEH_MILE
    y = c(0, 3000)
    plot(x, y, type = "n"
         , xlab = "density (veh/mi)", ylab = "flow (veh/hr)", ...)
}


stn_lines = function(stn, ...)
{
    midpts = stn$right_end_occ - diff(c(0, stn$right_end_occ)) / 2
    midpts = c(0, midpts, 1) * VEH_MILE
    flow = c(0, stn$mean_flow, 0) * OBS_HOUR
    lines(midpts, flow, ...)
}
