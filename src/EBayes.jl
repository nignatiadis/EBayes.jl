module EBayes

using LaTeXStrings

using Reexport

@reexport using StatsBase
@reexport using Distributions

using NLSolversBase
using Optim
using RecipesBase

using StructArrays

import Base: eltype,
             firstindex,
             getindex,
             getproperty,
             iterate,
             lastindex,
             length,
             rand,
             size,
             zero,
             zeros

import Base.Broadcast: broadcastable

import Distributions:location, RealInterval, support


import StatsBase:predict,
                 fit,
                 dof,
                 leverage

import StatsBase:response

using Statistics
import Statistics:var


import MLJBase, MLJ # to avoid conflicts
import MLJBase:predict_mean
import MLDataPattern:kfolds,FoldsView,shuffleobs

include("ebayes_types.jl")
include("ebayes_samples.jl")
include("predict.jl")
include("shrinkage_locations.jl")
include("sure.jl")
include("ebcf.jl")
include("example_priors.jl")
include("simulations.jl")

export EBayesSample,
       NormalSample,
       StandardNormalSample,
       EBayesSamples,
       AbstractNormalSamples,
       NormalSamples,
       NormalEBayesSimulationResult,
       var, #reexport from Statistics
       predict_mean, #reexport from MLJBase
       FixedLocation,
       GrandMeanLocation,
       SURE,
       EBayesCrossFit

end # module
