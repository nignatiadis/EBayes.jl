module EBayes

using Reexport

@reexport using StatsBase
import StatsBase:predict,
                 fit,
                 dof,
                 leverage,
				 response
	
@reexport using Distributions
import Distributions:location, RealInterval, support
		 
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

import MLJBase # to avoid conflicts with StatsBase
import MLJBase:predict_mean
import MLDataPattern:kfolds,FoldsView,shuffleobs

using LaTeXStrings
using NLSolversBase
using Optim
using RecipesBase
using Statistics
using StructArrays

import Statistics:var

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
