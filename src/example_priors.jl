abstract type AbstractPriorExample end

function getproperty(prior_ex::AbstractPriorExample, name::Symbol)
    if name == :distribution
       _distribution(prior_ex)
    end
end

@recipe function f(prior_ex::AbstractPriorExample)
    dbn = prior_ex.distribution
    if isa(dbn, MixtureModel)
        components --> false
    end
   xlab --> L"\mu"
   label --> ""
   title --> _pretty_name(prior_ex)
   dbn
end


"""
    AshSpiky, AshNearnormal, AshFlattop, AshSkew, AshBignormal, AshBimodal

Empirical Bayes priors that are used in the simulations of:

> Stephens, M., 2017. False discovery rates: a new deal. Biostatistics, 18(2), pp.275-294.
"""
AshSpiky, AshNearNormal, AshFlatTop, AshSkew, AshBignormal, AshBimodal

abstract type AshPrior <: AbstractPriorExample end

struct AshSpiky <: AshPrior end
_distribution(::AshSpiky) =  MixtureModel([Normal(0,0.25); Normal(0,0.5); Normal(0,1); Normal(0,2)] ,
                                          [0.4; 0.2; 0.2; 0.2 ])
_pretty_name(::AshSpiky) = "Spiky"

struct AshNearNormal <: AshPrior end
_distribution(::AshNearNormal) = MixtureModel([Normal(0,1); Normal(0,2)], [1/3; 2/3])
_pretty_name(::AshNearNormal) = "Near Normal"

struct AshFlatTop <: AshPrior end
_distribution(::AshFlatTop) = MixtureModel([Normal(x,0.5) for x=-1.5:0.5:1.5])
_pretty_name(::AshFlatTop) = "Flat Top"

struct AshSkew <: AshPrior end
_distribution(::AshSkew) =  MixtureModel([Normal(-2,2), Normal(-1,1.5), Normal(0,1), Normal(1,1)],
                                            [1/4; 1/4; 1/3; 1/6])
_pretty_name(::AshSkew) = "Skew"

struct AshBigNormal <: AshPrior end
_distribution(::AshBigNormal) =  Normal(0,4)
_pretty_name(::AshBigNormal) = "Skew"

struct AshBimodal <: AshPrior end
_distribution(::AshBimodal) =  MixtureModel( [Normal(-2,1); Normal(2,1)],
                            [0.5;0.5] )
_pretty_name(::AshBimodal) = "AshBimodal"


"""
    IWUnimod, IWBimod

Empirical Bayes priors that are used in the simulations of:

> Ignatiadis, N. and Wager, S., 2019. Bias-aware confidence intervals for empirical Bayes analysis. arXiv preprint arXiv:1902.02774.
"""
IWUnimod, IWBimod

abstract type IWPrior <: AbstractPriorExample end

struct IWUnimod <: IWPrior end
_distribution(::IWUnimod) =  MixtureModel([ Normal(-0.2,.2), Normal(0,0.9)],[0.7, 0.3])
_pretty_name(::IWUnimod) = "Unimodal"

struct IWBimod <: IWPrior end
_distribution(::IWBimod) =  MixtureModel([Normal(-1.5,.2), Normal(1.5, .2)])
_pretty_name(::IWBimod) = "Bimodal"


"""
    EfronUnifNormal

Empirical Bayes priors that are used in the simulations of:

> Efron, B., 2016. Empirical Bayes deconvolution estimates. Biometrika, 103(1), pp.1-20.
"""
struct EfronUnifNormal <: AbstractPriorExample end
_distribution(::EfronUnifNormal) =  MixtureModel([Uniform(-3.0,3.0), Normal(0.0, 0.5)], [1/8, 7/8])
_pretty_name(::EfronUnifNormal) = "Uniform / Normal-Mixture"
