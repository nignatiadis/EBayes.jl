module EBayes

using Reexport

@reexport using StatsBase
@reexport using Distributions

using StructArrays

import Base:length, rand, size
import Base.Broadcast: broadcastable
import Base: iterate,
             getindex,
             firstindex,
             lastindex,
             eltype,
             zero,
             zeros

import StatsBase:predict,
                 fit,
                 dof,
                 leverage

import StatsBase:response

using Statistics
import Statistics:var

import Distributions:location

import MLJBase, MLJ # to avoid conflicts
import MLJBase:predict_mean
import MLDataPattern:kfolds,FoldsView,shuffleobs
using NLSolversBase
using Optim

include("ebayes_types.jl")
include("ebayes_samples.jl")
include("predict.jl")
include("shrinkage_locations.jl")
include("sure.jl")
include("ebcf.jl")
include("simulations.jl")

export EBayesSample,
       NormalSample,
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
