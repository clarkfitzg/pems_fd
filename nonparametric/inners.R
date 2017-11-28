source("helpers.R")

inner = function(s1, s2)
{
    piecewise_inner(x1 = c(0, s1$right_end_occ)
                    , y1 = c(0, s1$mean_flow) 
                    , x2 = c(0, s2$right_end_occ) 
                    , y2 = c(0, s2$mean_flow) 
                    )
}

# Works
inner(stn[[1]], stn[[2]])

# Doesn't work :(
# fd_inners <- outer(stn, stn, inner)


fd_inners = matrix(NA, nrow = N, ncol = N)

# Takes 15 minutes. Numerical integration took 2+ hours with the three
# lines.
system.time(
for(i in 1:N){
    for(j in i:N){
        fij = inner(stn[[i]], stn[[j]])
        fd_inners[i, j] = fij
        fd_inners[j, i] = fij
    }
}
)


