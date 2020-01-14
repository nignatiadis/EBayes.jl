#---------------------------------------
# types for a single EB sample
#---------------------------------------
abstract type EBayesSample{T<:Number} end
abstract type AbstractNormalSample{T<:Number} <: EBayesSample{T} end

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
struct NormalSample{T <: Number} <: AbstractNormalSample{T}
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
support(ss::NormalSample) = RealInterval(-Inf, +Inf)

#---------------------------------------
# types for a single EB sample
#---------------------------------------
const EBayesSamples = AbstractArray{EBS} where EBS <: EBayesSample

const NormalSamples{T} = StructArray{NormalSample{T}} where T

function NormalSamples(Zs::AbstractVector{T}, σs::AbstractVector{T}) where T
    NormalSamples{T}((Zs, σs))
end

response(ss::NormalSamples) = ss.Z
Statistics.var(ss::NormalSamples) = ss.σ .^ 2


"""
    StandardNormalSample(Z)

A observed sample ``Z`` drawn from a Normal distribution with known variance ``\\sigma^2 =1``.

```math
Z \\sim \\mathcal{N}(\\mu, 1)
```

``\\mu`` is assumed unknown. The type above is used when the sample ``Z`` is to be used for estimation or inference of ``\\mu``.

```julia
StandardNormalSample(0.5)          #Z=0.5
```
"""
struct StandardNormalSample{T <: Number} <: AbstractNormalSample{T}
    Z::T
end

response(s::StandardNormalSample) = s.Z
Statistics.var(s::StandardNormalSample) = 1

eltype(s::StandardNormalSample{T}) where T = T
zero(s::StandardNormalSample{T}) where T = zero(T)
support(ss::StandardNormalSample) = RealInterval(-Inf, +Inf)


const AbstractNormalSamples = AbstractArray{NS} where NS <: Union{NormalSample,
                                                                  StandardNormalSample}

response(ss::AbstractNormalSamples) = response.(ss)
Statistics.var(ss::AbstractNormalSamples) = var.(ss)
zeros(ss::AbstractNormalSamples) = zeros(eltype(response(ss)), length(ss))





# Poisson

# Binomial

# Replicated , ReplicatedArray