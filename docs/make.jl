using EBayes
using Documenter

makedocs(
    format=Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    pages=[
        "Home" => "index.md",
        "Reference" => ["Empirical Bayes Samples" => "ebayes_samples.md",
                        "Example Priors" => "prior_distributions.md"],
    ],
    repo="https://github.com/nignatiadis/EBayes.jl/blob/{commit}{path}#L{line}",
    sitename="EBayes.jl",
    authors="Nikos Ignatiadis <nikos.ignatiadis01@gmail.com>"
)

deploydocs(;
    repo="github.com/nignatiadis/EBayes.jl",
)
