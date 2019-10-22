abstract type EBayesSample{T<:Number} end

struct NormalSample{T <: Number} <: EBayesSample{T}
    Z::T
    σ::T
end

function NormalSample(Z::T) where {T<:Number}
    NormalSample(Z, one(T))
end

NormalSample(Z::Number, σ::Number) = NormalSample(promote(Z, σ)...)


const NormalSamples{T} = StructArray{NormalSample{T}} where T

function NormalSamples(Zs::AbstractVector{T}, σs::AbstractVector{T}) where T
    NormalSamples{T}((Zs, σs))
end




