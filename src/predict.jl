function predict(prior::Distribution, fitted_obj, prior_μs, ss::NormalSamples)
    predict.(prior, fitted_obj, prior_μs, ss)
end

function predict(prior::Normal, A, prior_μ, s::NormalSample)
        z =  response(s)
        noise_var = var(s)
        λ_shrink = A/(noise_var + A)
        λ_shrink*z + (1-λ_shrink)*prior_μ
end

