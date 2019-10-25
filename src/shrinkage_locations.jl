abstract type EBayesShrinkageLocation end


#-----------------------------------------------
# FixedLocation
#-----------------------------------------------

struct FixedLocation{TS} <: EBayesShrinkageLocation
    offset::TS
end
FixedLocation(; offset=0.0) = FixedLocation(offset)

fit(fixed_loc::FixedLocation, ss) = nothing

function predict(fixed_loc::FixedLocation, ss::NormalSamples)
    zeros(ss) .+ fixed_loc.offset
end

# fitted_loc will be nothing
function predict(fixed_loc::FixedLocation, fitted_loc, ss::NormalSamples)
    predict(fixed_loc, ss)
end

function leverage(fixed_loc::FixedLocation, fitted_loc, ss)
    zero(eltype(response(ss)))
end


#-----------------------------------------------
# GrandMeanLocation
#-----------------------------------------------


struct GrandMeanLocation{TS} <: EBayesShrinkageLocation
    offset::TS
end

GrandMeanLocation(; offset=0.0) = GrandMeanLocation(offset)

fit(loc::GrandMeanLocation, ss) = mean( response(ss) .- loc.offset)


function predict(loc::GrandMeanLocation, fitted_loc, ss::NormalSamples)
    zeros(ss) .+ loc.offset .+ fitted_loc
end

function leverage(loc::GrandMeanLocation, fitted_loc, ss)
    1/length(ss)
end


#----------------------------------------------------------
#  RegressionLocation
#----------------------------------------------------------

#struct RegressionLocation{TS, MT <: Supervised} <: EBayesShrinkageLocation
#    offset::TS
#    model::MT
#end

#RegressionLocation(model; offset=0.0) = FixedLocation(offset, model)

#fit(fixed_loc::FixedLocation, ss) = nothing

#function predict(fixed_loc::FixedLocation, ss::NormalSamples)
#    zeros(ss) .+ fixed_loc.offset
#end

# fitted_loc will be nothing
#function predict(fixed_loc::FixedLocation, fitted_loc, ss::NormalSamples)
#    predict(fixed_loc, ss)
#end

# GrandMeanLocation(μs) = GrandMeanLocation(μs, nothing)
# GrandMeanLocation() = GrandMeanLocation(0.0)
# GrandMeanLocation(::Type{AnalyticWeights}) = GrandMeanLocation(0.0, AnalyticWeights)
#
# weights(gm::GrandMeanLocation) = gm.ws
# dof(gm::GrandMeanLocation) = 1
#
# # TODO: Allow varying μ here as well
# function AnalyticWeights(s::NormalSamples)
#     AnalyticWeights(1 ./ s.σ.^2)
# end
#
# function fit(loc::GrandMeanLocation, s::NormalSamples, ::Type{AnalyticWeights})
#     mean(s.Z, AnalyticWeights(s))
# end
#
# function fit(loc::GrandMeanLocation,
#                   s::Union{HomoskedasticNormalSamples, StandardNormalSamples}, ws)
#     mean(s.Zs)
# end



# function dof_residual(ebloc::EBayesShrinkageLocation, fitted_loc, ss::EBayesSamples)
#     length(ss) - dof(ebloc, fitted_loc)
# end
# function dof_residual(ebloc::EBayesShrinkageLocation, ss::EBayesSamples)
#     length(ss) - dof(ebloc)
# end
#
# dof(ebloc::EBayesShrinkageLocation, fitted_loc) = dof(ebloc)
#
# function fit(loc::EBayesShrinkageLocation, ss::EBayesSamples)
#     fit(loc, ss, weights(loc))
# end
# function fit(loc::EBayesShrinkageLocation, ss::EBayesSamples, ws::Nothing)
#     fit(loc)
# end
#
# fit(loc::EBayesShrinkageLocation, X, ss::EBayesSamples) = fit(loc, ss)
#
# fit(loc::EBayesShrinkageLocation) = loc #by default return itself
# function leverage(loc::EBayesShrinkageLocation, ss::EBayesSamples)
#     leverage(loc)
# end
#
#
# weights(loc::EBayesShrinkageLocation) = nothing
#
#
#
# struct FixedLocation{T} <: EBayesShrinkageLocation
#     μs::T
# end
# FixedLocation() = FixedLocation(0.0)
#
# dof(fixed_loc::FixedLocation) = 0
# leverage(loc::FixedLocation) = 0 # don't need this to be a vector.
#
# function predict(loc::FixedLocation, ss::NormalSamples)
#     μs = loc.μs #fitted objects return the fit
#     preds = copy(ss.Z)
#     preds[:] .= μs
#     preds
# end #let's keep this
#
#
# struct SURELocation{T} <: EBayesShrinkageLocation
#     μs::T
# end
#
# SURELocation() = SURELocation(0.0)
#
# struct GrandMeanLocation{T, W} <: EBayesShrinkageLocation
#     μs::T
#     ws::W
# end
#
# GrandMeanLocation(μs) = GrandMeanLocation(μs, nothing)
# GrandMeanLocation() = GrandMeanLocation(0.0)
# GrandMeanLocation(::Type{AnalyticWeights}) = GrandMeanLocation(0.0, AnalyticWeights)
#
# weights(gm::GrandMeanLocation) = gm.ws
# dof(gm::GrandMeanLocation) = 1
#
# # TODO: Allow varying μ here as well
# function AnalyticWeights(s::NormalSamples)
#     AnalyticWeights(1 ./ s.σ.^2)
# end
#
# function fit(loc::GrandMeanLocation, s::NormalSamples, ::Type{AnalyticWeights})
#     mean(s.Z, AnalyticWeights(s))
# end
#
# function fit(loc::GrandMeanLocation,
#                   s::Union{HomoskedasticNormalSamples, StandardNormalSamples}, ws)
#     mean(s.Zs)
# end
#
# struct FittedGrandMeanLocation{T, GM<:GrandMeanLocation} <: EBayesShrinkageLocation
#     zbar::T
#     gm::GM
# end
#
# function fit(loc::GrandMeanLocation, ss::NormalSamples, ::Nothing)
#     # want to zero center (ss.Z - offset)
#     zbar = mean(ss.Z .- loc.μs)
#     FittedGrandMeanLocation(zbar, loc)
# end
#
# dof(fixed_loc::FittedGrandMeanLocation) = 1
# function leverage(loc::FittedGrandMeanLocation, ss::NormalSamples)
#     1/length(ss)
# end
#
# function predict(loc::FittedGrandMeanLocation, ss::NormalSamples)
#     μs = loc.zbar .+ loc.gm.μs #fitted objects return the fit
#     preds = copy(ss.Z)
#     preds[:] .= μs
#     preds
# end
#
#
#
#
# ########### Code for ...
#
# # could have the μs field as well, but don't need to...
# struct RegressionLocation{M , W, F<:StatsModels.FormulaTerm} <: EBayesShrinkageLocation
#     model::M
#     f::F
#     ws::W # M is the model
#     isfitted::Bool
# end
#
# RegressionLocation(model, f; isfitted=false) = RegressionLocation(model, f, nothing, isfitted)
# # maybe have default formula include everything + 1?
# RegressionLocation(model) = RegressionLocation(model, @formula(1~1))
#
# weights(reg::RegressionLocation) = reg.ws
# dof(reg::RegressionLocation, fitted_loc) = dof(fitted_loc)
# leverage(reg::RegressionLocation) = leverage(reg.model)
#
# #fit(loc, X, ss)
#
# function fit(loc::RegressionLocation, X, ss::NormalSamples)
#     if !loc.isfitted
#         fitted_model = fit(loc.model, X, ss, loc.f, loc.ws)
#         loc = RegressionLocation(fitted_model, loc.f, loc.ws, true)
#     end
#     loc
# end
#
# function fit(model, X_df::AbstractDataFrame, ss::NormalSamples, form, ::Nothing)
#     X = modelmatrix(form, X_df)
#     fitted_model = fit(model, X, ss.Z) #default...
#     fitted_model
# end
#
# # TODO: get weights working again...
# #function fit(loc::RegressionLocation, ssc::CovNormalSamples, ::Type{AnalyticWeights})
# #    X = modelmatrix(loc.f,
# #                    ssc.X_df)
#     # TODO: there will be some code duplication here, fix later
# #    fitted_model = fit(loc.model, X, ssc.S.Zs; wts=AnalyticWeights(ssc).values)
# #end
#
# function predict(loc::RegressionLocation, X, ss::NormalSamples) #with NormalSamples?
#     # TODO: go back to same fun for arbitrary Location
#     if !loc.isfitted
#         loc = fit(loc, X, ss)
#     end
#     predict(loc, X)
# end
#
# # for a fitted model
# function predict(loc::RegressionLocation, X) #with NormalSamples?
#     predict(loc.model, X)
# end
#
# function predict(loc::RegressionLocation, ss::NormalSamples) #with NormalSamples?
#     predict(loc.model)
# end
#
# predict(model, X) = predict(model)
#
