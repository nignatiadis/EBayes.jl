using Test
using EBayes
using Random
using MLJ

Random.seed!(0)
ffh_sim = EBayes.FriedmanFayHerriotSimulation(1000, 5 , 0.5, 1.0)
ffh_sample = rand(ffh_sim)


lin_mlj = MLJ.@load LinearRegressor pkg=GLM
lin_mach = fit!(machine(lin_mlj, ffh_sample.X, response(ffh_sample.ss)), verbosity=0)
lin_preds = predict_mean(lin_mach)

mse_linpred = mean((lin_preds .- ffh_sample.true_μs).^2)
mse_mle = mean((response(ffh_sample.ss) - ffh_sample.true_μs).^2)

ebcf_lin = EBayesCrossFit(lin_mlj)
ebcf_fit = fit(ebcf_lin, ffh_sample.X, ffh_sample.ss)

ebcf_preds = predict(ebcf_fit)


mse_ebcf = mean((ebcf_preds .- ffh_sample.true_μs).^2)
@test mse_ebcf < mse_linpred
@test mse_ebcf < mse_mle
