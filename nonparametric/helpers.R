# Tue Nov 21 09:27:23 PST 2017


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


# Compute function inner product on two piecewise linear functions
piecewise_inner = function(x1, y1, x2, y2)
{
    x = sort(unique(c(x1, x2)))
    f = approx(x1, y1, xout = x)$y
    g = approx(x2, y2, xout = x)$y

    nm1 = length(x) - 1
    parts = rep(NA, nm1)
    for(i in seq(nm1)){
        ip1 = i + 1
        parts[i] = inner_one_piece(x[i], x[ip1], f[i], f[ip1], g[i], g[ip1])
    }
    sum(parts)
}


# Scale the similarity matrix into a correlation matrix
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
    plot(c(0, 1), c(0, 20), type = "n"
         , xlab = "occupancy", ylab = "flow", ...)
}

stn_lines = function(stn, ...)
{
    midpts = stn$right_end_occ - diff(c(0, stn$right_end_occ)) / 2
    midpts = c(0, midpts, 1)
    flow = c(0, stn$mean_flow, 0)
    lines(midpts, flow, ...)
}
