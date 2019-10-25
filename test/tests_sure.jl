using Test
using EBayes
using Random
using MLJBase

Random.seed!(0)

# First let us check if SURE works when we apply it on easiest Gaussian problem
# i.e. Gaussian prior and under homoskedastisticity

# Check if we recover variance
A1 = 4.0
normal_normal_sim = EBayes.NormalNormalSimulation(n=100000, A=A1)
sim_res = rand(normal_normal_sim)
nss = NormalSamples(sim_res)
sure_fit = fit(Normal(), SURE(), FixedLocation(), nss)
@test first(MLJBase.fitted_params(sure_fit))  ≈ A1 atol=0.1

@test mean( (predict(sure_fit) .- sim_res.true_μs).^2) ≈ A1*1/(A1 + 1) atol=0.05

# Check if we also recover mean
A2 = 0.5
sim_res2 = rand(EBayes.NormalNormalSimulation(n=100000, prior_μ=3.0, A=A2))
nss2 = NormalSamples(sim_res2)
sure_fit2 = fit(Normal(), SURE(), GrandMeanLocation(), nss2)

@test first(MLJBase.fitted_params(sure_fit2))  ≈ A2 atol=0.02
@test last(MLJBase.fitted_params(sure_fit2)) ≈ 3.0 atol=0.01

@test mean( (predict(sure_fit2) .- sim_res2.true_μs).^2) ≈ A2/(A2 + 1) atol=0.03


# Now check results on simulation from Xie, Kou and Brown
# TODO: Do it automated and also run through all settings


sim_res3 = rand(EBayes.XieKouBrownExample1(100000))
nss3 = NormalSamples(sim_res3)
sure_fit3 = fit(Normal(), SURE(), nss3)


# Table 1 from Kou et al.
risk_sure_sim1 = 0.3357
@test mean( (predict(sure_fit3) .- sim_res3.true_μs).^2) ≈ risk_sure_sim1 atol=0.01

sim_res4 = rand(EBayes.XieKouBrownExample4(100000))
nss4 = NormalSamples(sim_res4)
sure_fit4 = fit(Normal(), SURE(), nss4)

# Table 1, Sim4 from Kou et al.
risk_sure_sim4 = 0.0051
@test mean( (predict(sure_fit4) .- sim_res4.true_μs).^2) ≈ risk_sure_sim4 atol=0.001

