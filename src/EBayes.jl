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
             eltype


include("ebayes_samples.jl")
include("simulations.jl")

export EBayesSample,
       NormalSample,
       EBayesSamples,
       AbstractNormalSamples,
       NormalSamples,
       NormalEBayesSimulationResult

end # module
