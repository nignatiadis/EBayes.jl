abstract type AbstractEBayesMethod end

broadcastable(eb_method::AbstractEBayesMethod) = Ref(eb_method)
