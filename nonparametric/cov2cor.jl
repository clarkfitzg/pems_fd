cov2cor = function(x)
    xnew = copy(x)
    N = size(x, 1)
    for i in 1:N
        for j in i:N
            dij = x[i, j] / sqrt(x[i, i] * x[j, j])
            xnew[i, j] = dij
            xnew[j, i] = dij
        end
    end
    return xnew
end


cov2cor2 = function(x)
    xnew = copy(x)
    N = size(x, 1)
    d = 1. ./ sqrt(diag(x))
    @inbounds for i in 1:N
        @fastmath @inbounds @simd for j in i:N
            dij = x[i, j] * d[i] * d[j]
            xnew[i, j] = dij
            xnew[j, i] = dij
        end
    end
    return xnew
end




srand(37)
# Covariance function where closely related points are more correlated
ac(dx, rho) = exp(-rho * abs(dx)^1.4)

n = 1378
index = linspace(0, 0.2, n)
rhotrue = 50.

# Broadcast vectors up to matrix
distances = abs(index .- index')
Sigma = ac.(distances, rhotrue)


# Takes about 30 ms.
@time x = cov2cor(Sigma)

# Takes about 20 ms.
@time x2 = cov2cor2(Sigma)

@code_warntype cov2cor2(Sigma)
