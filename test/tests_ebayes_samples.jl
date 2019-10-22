using Test
using EBayes
using StructArrays
using Random

## Check single sample
ns = NormalSample(1.0)
@test isa(ns, EBayesSample)
@test isa(ns, EBayesSample{Float64})

ns2 = NormalSample(1.0, 1)
@test ns == ns2

# Check vectorized ebayes samples
nss = StructArray([ns; ns2])
@test isa(nss, NormalSamples)
@test isa(nss, NormalSamples{Float64})

nss2 = NormalSamples(nss.Z,nss.σ)
@test isa(nss2, NormalSamples)

Random.seed!(0)
sim1 = rand(EBayes.XieKouBrownExample1(1000))

nss_sim1 = NormalSamples(sim1)
@test isa(nss_sim1, NormalSamples)
