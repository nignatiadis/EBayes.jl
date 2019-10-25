using Test
using EBayes
using StructArrays
using Random

## Check single sample
ns = NormalSample(1.0)
@test isa(ns, EBayesSample)
@test isa(ns, EBayesSample{Float64})
@test response(ns) == 1.0
@test eltype(ns) == Float64
@test zero(ns) == 0
@test var(ns) == 1.0

ns2 = NormalSample(1.0, 1)
@test ns == ns2

# Check vectorized ebayes samples
nss = StructArray([ns; ns2])
@test isa(nss, NormalSamples)
@test isa(nss, NormalSamples{Float64})

@test isa(nss, EBayesSamples)
@test isa(nss, AbstractNormalSamples)
@test AbstractNormalSamples <: EBayesSamples
@test NormalSamples{Float64} <: EBayesSamples

nss2 = NormalSamples(nss.Z,nss.σ)
@test isa(nss2, NormalSamples)

@test response(nss) == response.(nss)
@test zeros(nss) == zeros(Float64, 2)
@test length(nss) == 2


## test predictions

@test predict(Normal(), 1, 0.0, ns) == 1/2
@test predict(Normal(), 1, 1.0, ns) == 1.0
@test predict(Normal(), 0, 0.0, ns) == 0.0

@test predict.(Normal(), 1, 0.0, nss) == 1/2 .* ones(2)
@test predict.(Normal(), [1;1], [0;0], nss) == 1/2 .* ones(2)

## test simulation code
Random.seed!(0)
sim1 = rand(EBayes.XieKouBrownExample1(1000))

nss_sim1 = NormalSamples(sim1)
@test isa(nss_sim1, NormalSamples)



