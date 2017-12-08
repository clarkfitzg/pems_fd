
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
    xnew = similar(x)
    N = size(x, 1)
    d = 1. ./ sqrt(diag(x))
    @inbounds for j in 1:N
        @simd for i in 1:N
            dij = x[i, j] * d[i] * d[j]
            xnew[i, j] = dij
            #xnew[j, i] = dij
        end
    end
    return xnew
end


# Ethan's versions:

function cov2cor3(x) 
    d = 1 ./ sqrt.(diag(x))
    return x .* d .* d.'
end


function cov2cor4(x) 
    d = 1./sqrt.(diag(x))
    y = similar(x)   
    n = size(x,1) 
    @inbounds for col in 1:n 
        @simd for row in 1:n
            y[row,col] = x[row,col] * d[row] * d[col]
        end 
    end 
    return y
end


function cov2cor6(x) 
    d = 1./sqrt.(diag(x))
    y = similar(x)   
    n = size(x,1) 
    @inbounds for col in 1:n 
        @simd for row in 1:col
            y[row,col] = x[row,col] * d[row] * d[col]
        end 
    end 
    return Symmetric(y)
end




srand(37)
# Covariance function where closely related points are more correlated
ac(dx, rho) = exp(-rho * abs(dx)^1.4)

n = 1378
index = linspace(0, 0.2, n)
rhotrue = 50.

# Broadcast vectors up to matrix
distances = abs(index .- index')
Sigma = 1. .+ ac.(distances, rhotrue)


# Takes about 30 ms.
@time x = cov2cor(Sigma)

# Takes about 20 ms.
@time x2 = cov2cor2(Sigma)

@code_warntype cov2cor2(Sigma)

using BenchmarkTools
@benchmark cov2cor($Sigma)  #<-- 17.357 ms  Clark: 12.4

@benchmark cov2cor2($Sigma) #<-- 12.551 ms	Clark: 9.1

@benchmark cov2cor3($Sigma) #<-- 3.246 ms	Clark: 6.9

@benchmark cov2cor4($Sigma) #<-- 2.667 ms	Clark: 2.6


@benchmark cov2cor6($Sigma) # Clark: 1.45
