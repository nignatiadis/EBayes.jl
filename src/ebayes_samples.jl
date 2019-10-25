#---------------------------------------
# types for a single EB sample
#---------------------------------------
abstract type EBayesSample{T<:Number} end

"""
    NormalSample(Z,σ)

A observed sample ``Z`` drawn from a Normal distribution with known variance ``\\sigma^2 > 0``.

```math
Z \\sim \\mathcal{N}(\\mu, \\sigma^2)
```

``\\mu`` is assumed unknown. The type above is used when the sample ``Z`` is to be used for estimation or inference of ``\\mu``.

```julia
NormalSample(0.5, 1.0)          #Z=0.5, σ=1
```
"""
struct NormalSample{T <: Number} <: EBayesSample{T}
    Z::T
    σ::T
end

function NormalSample(Z::T) where {T<:Number}
    NormalSample(Z, one(T))
end

NormalSample(Z::Number, σ::Number) = NormalSample(promote(Z, σ)...)

response(s::NormalSample) = s.Z
Statistics.var(s::NormalSample) = s.σ^2

eltype(s::NormalSample{T}) where T = T
zero(s::NormalSample{T}) where T = zero(T)
#---------------------------------------
# types for a single EB sample
#---------------------------------------
const EBayesSamples = AbstractArray{EBS} where EBS <: EBayesSample
const AbstractNormalSamples = AbstractArray{NS} where NS <: NormalSample
const NormalSamples{T} = StructArray{NormalSample{T}} where T

function NormalSamples(Zs::AbstractVector{T}, σs::AbstractVector{T}) where T
    NormalSamples{T}((Zs, σs))
end

response(ss::NormalSamples) = ss.Z
Statistics.var(ss::NormalSamples) = ss.σ .^ 2

zeros(ss::NormalSamples) = zeros(eltype(response(ss)), length(ss))


