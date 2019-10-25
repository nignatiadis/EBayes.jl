# Example models to simulate from...
abstract type EBayesSimulation end


struct NormalEBayesSimulationResult{Sim<:EBayesSimulation, NS<:NormalSamples}
    ss::NS
    true_μs::Vector{Float64}
    sim::Sim
end

function NormalSamples(nsim::NormalEBayesSimulationResult)
   nsim.ss
end

#predict(method, sim_res::NormalEBayesSimulationResult) = predict(method, sim_res.ss)


struct NormalNormalSimulation <: EBayesSimulation
   n::Int64
   prior_μ::Float64
   A::Float64
   σ::Float64
end

function NormalNormalSimulation(;n=1000,
                                 prior_μ=0.0,
                                 A=1.0,
                                 σ=1.0)
   NormalNormalSimulation(n, prior_μ, A, σ)
end


function rand(x::NormalNormalSimulation)
   n = x.n
   A = x.A
   σ = x.σ
   prior_μ = x.prior_μ

   μs = randn(n).*sqrt(A) .+ prior_μ
   Zs = randn(n).*σ .+ μs
   σs = fill(σ, n)

   NormalEBayesSimulationResult(NormalSamples(Zs,σs), μs, x)
end
#----------------------------------------------------------------------
# Xie-Kou-Brown 2012 include 6 examples for their simulation benchmark
#----------------------------------------------------------------------


struct XieKouBrownExample1 <: EBayesSimulation
    n::Int64
end

function rand(x::XieKouBrownExample1)
   n = x.n
   As = rand(Uniform(0.1,1), n)
   σs = sqrt.(As)
   μs = randn(n)
   Zs = randn(n).*σs .+ μs
   NormalEBayesSimulationResult(NormalSamples(Zs,σs), μs, x)
end

struct XieKouBrownExample2 <: EBayesSimulation
    n::Int64
end

function rand(x::XieKouBrownExample2)
   n = x.n
   As = rand(Uniform(0.1,1), n)
   σs = sqrt.(As)
   μs = rand(n)
   Zs = randn(n).*σs .+ μs
   NormalEBayesSimulationResult(NormalSamples(Zs,σs), μs, x)
end

struct XieKouBrownExample3 <: EBayesSimulation
    n::Int64
end

function rand(x::XieKouBrownExample3)
   n = x.n
   As = rand(Uniform(0.1,1), n)
   σs = sqrt.(As)
   μs = As
   Zs = randn(n).*σs .+ μs
   NormalEBayesSimulationResult(NormalSamples(Zs,σs), μs, x)
end

struct XieKouBrownExample4 <: EBayesSimulation
    n::Int64
end

function rand(x::XieKouBrownExample4)
   n = x.n
   As = rand(InverseGamma(5, 1/2), n)
   σs = sqrt.(As)
   μs = As
   Zs = randn(n).*σs .+ μs
   NormalEBayesSimulationResult(NormalSamples(Zs,σs), μs, x)
end

struct XieKouBrownExample5 <: EBayesSimulation
    n::Int64
end

function rand(x::XieKouBrownExample5)
   n = x.n
   groups = rand(Bernoulli(1/2), n)
   As = [ (g==0) ? 0.1 : 0.5 for g in groups]
   σs = sqrt.(As)
   μs = [ (g==0) ? rand(Normal(2.0,sqrt(0.1))) : rand(Normal(0.0, sqrt(0.5))) for g in groups]
   Zs = randn(n).*σs .+ μs
   NormalEBayesSimulationResult(NormalSamples(Zs,σs), μs, x)
end


struct XieKouBrownExample6 <: EBayesSimulation
    n::Int64
end

function rand(x::XieKouBrownExample6)
   n = x.n
   As = rand(Uniform(0.1,1), n)
   σs = sqrt.(As)
   μs = As
   Zs =  μs .+ rand.(Uniform.( -sqrt.(3 .* As), sqrt.(3 .* As)))
   NormalEBayesSimulationResult(NormalSamples(Zs,σs), μs, x)
end



#-----------------------------------------
# Simulations with covariates
#-----------------------------------------

struct CovariateNormalEBayesSimulationResult{Sim<:EBayesSimulation,
                                    Tbl,
                                    NS<:NormalSamples}
    ss::NS
    X::Tbl
    true_ms::Vector{Float64}
    true_μs::Vector{Float64}
    sim::Sim
end

function NormalSamples(nsim::CovariateNormalEBayesSimulationResult)
   nsim.ss
end


struct FriedmanFayHerriotSimulation{T<:Number} <: EBayesSimulation
    n::Int
    p::Int
    A_sqrt::T
    σ::T
end

friedman_reg(x) = 10*sin(π*x[1]*x[2]) + 20*(x[3] - 1/2)^2 + 10*x[4] +5*x[5]

function rand(sim::FriedmanFayHerriotSimulation)
   p = sim.p
   n = sim.n
   σ = sim.σ
   A_sqrt = sim.A_sqrt
   X = rand(Uniform(0,1), n, p)
   ms = map(friedman_reg, eachrow(X))
   μs = ms .+ rand(Normal(0, A_sqrt), n)
   Zs = μs .+ rand(Normal(0, σ), n)
   X = MLJBase.table(X)
   CovariateNormalEBayesSimulationResult(NormalSamples(Zs,fill(σ, n)), X, ms, μs, sim)
end
