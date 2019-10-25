using Test
using EBayes
using Random
using MLJBase

Random.seed!(0)

# First let us check if SURE works when we apply it on easiest Gaussian problem
# i.e. Gaussian prior and under homoskedastisticity

normal_normal_sim = EBayes.NormalNormalSimulation(n=100000, A=4.0)
sim_res = rand(normal_normal_sim)

ns = NormalSamples(sim_res)
sure_fit = fit(Normal(), SURE(), FixedLocation(), ns)

@test first(MLJBase.fitted_params(sure_fit))  ≈ 4 atol=0.1


