struct SURE <: AbstractEBayesMethod end

mutable struct FittedEBayes{SS,
                            L,
                            FL,
                            PRED,
                            EBM,
                            FEBM,
                            O}
    ss::SS
    loc::L
    fitted_loc::FL
    predictor::PRED
    method::EBM
    fitted_obj::FEBM
    report::O #Typically nothing or result from Optim.jl
end

MLJBase.fitted_params(feb::FittedEBayes) = (feb.fitted_obj, feb.fitted_loc)

function predict(feb::FittedEBayes)
    prior_μs = predict(feb.loc, feb.fitted_loc, feb.ss)
    predict(feb.predictor, feb.fitted_obj, prior_μs, feb.ss)
end

# TODO: add nicer default interface

function fit(predictor::Normal, method::SURE, loc::EBayesShrinkageLocation, ss::NormalSamples;
             optimizer = IPNewton())
    fitted_loc = fit(loc, ss)
    x0 = optim_start_point(predictor, method, loc, fitted_loc, ss)
    f_diff = optim_objective(predictor, method, loc, fitted_loc, ss, x0)
    dfc = optim_constraints(predictor, method, loc, fitted_loc, ss, x0)
    opt_res = optimize(f_diff, dfc, x0, optimizer)
    fitted_obj = optim_extract(predictor, method, loc, fitted_loc, ss, opt_res)
    FittedEBayes(ss, loc, fitted_loc,
                 predictor, method, fitted_obj,
                 opt_res)
end

function fit(predictor::Normal, method::SURE, ss::NormalSamples; optimizer=IPNewton())
    fit(predictor, method, GrandMeanLocation(), ss; optimizer=optimizer)
end

#------------------------------------------------------------------------------------------
#----------------- Normal prior with with SURE --------------------------------------------
#------------------------------------------------------------------------------------------


function optim_start_point(predictor::Normal,
                           sure::SURE,
                           loc::EBayesShrinkageLocation,
                           fitted_loc,
                           ss::NormalSamples)
    μs = predict(loc, fitted_loc, ss)
    Zs = response(ss)
    σs_squared = var(ss)

    x0  = sqrt(max( mean((Zs .- μs).^2 .- σs_squared), 0.0001))
    x0 = [x0]
    x0
end

function optim_constraints(predictor::Normal,
                           sure::SURE,
                           loc::EBayesShrinkageLocation,
                           fitted_loc,
                           ss::NormalSamples,
                           x0)
    dfc = TwiceDifferentiableConstraints([0.0], [Inf])
    dfc
end

function _f_sure(A, Z, μ, h_ii, σ_squared)
    #(σ^2/(A^2 + σ^2))^2*(Z - μ)^2 + σ^2 - 2*(1 - h_ii)*σ^4/(A^2 + σ^2)
    (σ_squared/(A + σ_squared))^2*(Z - μ)^2 - 2*(1 - h_ii)*σ_squared^2/(A + σ_squared)
end

function optim_objective(predictor::Normal,
                         sure::SURE,
                         loc::EBayesShrinkageLocation,
                         fitted_loc,
                         ss::NormalSamples,
                         x0)
    #f_sure(A, Z, σ) = (σ^2/(A^2 + σ^2))^2*Z^2 + σ^2*(A^2 - σ^2)/(A^2 + σ^2)
                                        #             + σ^2 - 2σ^4/(A^2 + σ^2)
    #f_sure(A, Z, σ) = (σ^2/(A^2 + σ^2))^2*(Z - Zs_bar)^2 + σ^2*(A^2 - σ^2 + 2*σ^2/n)/(A^2 + σ^2)

    Zs = response(ss)
    σs_squared = var(ss)
    μs = predict(loc, fitted_loc, ss)
    hat_diags = leverage(loc, fitted_loc, ss)

    f_diff = TwiceDifferentiable(A -> mean( _f_sure.(first(A), Zs, μs,
                                                     hat_diags, σs_squared)),
                                 x0; autodiff=:forward)
end

function optim_extract(predictor::Normal,
                       sure::SURE,
                       loc::EBayesShrinkageLocation,
                       fitted_loc,
                       ss::NormalSamples,
                       res)
    A = first(Optim.minimizer(res))
    A
end

#function optim_extract(s::NormalSamples,
#                       sure::SURE{D, FixedLocation{T}},
#                       res) where {D<:UnivariateDistribution, T}
#    σ_prior = first(Optim.minimizer(res))
#    D_type = typeof(sure.d)
#    D_type.(sure.locs.μs, σ_prior)
#end






#function optim_extract(s::NormalSamples,
#                sure::SURE{Normal{T}, GrandMeanLocation{S, W}},
#                res) where {T,S,W}

#    σ_prior = first(Optim.minimizer(res))
#    Zs_bar = mean(s.Z)
#    Normal.(Zs_bar .+ sure.locs.μs, σ_prior)
#end

#-------------------------------------------------------------------

#function fit(sure::SURE{Normal{T}, FixedLocation{T}},
#             s::HomoskedasticNormalSamples) where T
#     σ_squared_lik = s.σ^2
#     Zs = s.Zs
#     μ = sure.locs.μs
#     σ_prior_squared = max( mean((Zs .- μ).^2) - σ_squared_lik, zero(T))
#     EmpiricalBayesProblem(s, Normal.(μ, sqrt(σ_prior_squared)), sure)
#end


#----------------------------------------------------------------------
# Semiparametric SURE
#----------------------------------------------------------------------


#(1-b_i)Z_i + b_i \bar{Z}
#    `` \sum_{i=1}^n b_i^2 (Z_i - \bar{Z})^2 + (1 - 2(1-1/n)b_i))\sigma_i^2 ``
#
#  so (Z_i - \bar{Z})^2 in front of b_i^2 and
# -2\sigma^2(1-1/n) in front of b...
# hence could use      \sigma^2(1-1/n)/(Z_i - \bar{Z})^2 as my pseudo-observation.

#function fit(sure::SURE{SemiparametricLinearShrinker,
#                        GrandMeanLocation{T, Nothing}},
#             s::NormalSamples) where T
#    n = length(s)
#    Zs = s.Z
#    σs = s.σ
#    Zbar = mean(Zs)

#    ws = (Zs .- Zbar).^2
#    Y_pseudo = replace(ws, 0.0 => 10.0) #will get 0 weight in optim anyway

#    Y_pseudo = σs.^2 .* (1 - 1/n) ./ Y_pseudo

#    iso_fit = fit(IsotonicRegression, σs, Y_pseudo; wts=ws, lb=0.0, ub=1.0)
#    bs = predict(iso_fit)

#    linshrink = LinearShrinker(Zbar,  1 .- bs)
#    EBayesOptimResult(s, linshrink, sure)
#end

# More or less the same
#   \sum_{i=1}^n b_i^2 (Z_i - \mu_i)^2 + (1 - 2b_i))\sigma_i^2 `