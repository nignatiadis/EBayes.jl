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

using MLJBase
import MLJBase: fitted_params

using NLSolversBase
using Optim

include("ebayes_types.jl")
include("ebayes_samples.jl")
include("predict.jl")
include("shrinkage_locations.jl")
include("sure.jl")
include("simulations.jl")

export EBayesSample,
       NormalSample,
       EBayesSamples,
       AbstractNormalSamples,
       NormalSamples,
       NormalEBayesSimulationResult,
       var, #reexport
       FixedLocation,
       GrandMeanLocation,
       SURE

end # module
