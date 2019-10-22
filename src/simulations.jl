# Example models to simulate from...
abstract type EBayesSimulation end


struct NormalEBayesSimulationResult{Sim<:EBayesSimulation, SS<:NormalSamples}
    ss::SS
    true_μs::Vector{Float64}
    sim::Sim
end

function NormalSamples(nsim::NormalEBayesSimulationResult)
   nsim.ss
end

#predict(method, sim_res::NormalEBayesSimulationResult) = predict(method, sim_res.ss)


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


