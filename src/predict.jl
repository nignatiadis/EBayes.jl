function predict(prior::Normal, A, loc, s::NormalSample)
        z =  response(s)
        noise_var = var(s)
        λ_shrink = A/(noise_var + A)
        λ_shrink*z + (1-λ_shrink)*loc
end
