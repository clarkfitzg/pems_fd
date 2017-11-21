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
    f = approx(x1, y1, xout = d$x)$y
    g = approx(x2, y2, xout = d$x)$y

    parts = rep(NA, nrow(d) - 1)
    for(i in seq(nrow(d) - 1)){
        ip1 = i + 1
        parts[i] = inner_one_piece(x[i], x[ip1], f[i], f[ip1], g[i], g[ip1])
    }
    sum(parts)
}
