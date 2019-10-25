using Documenter, EBayes

makedocs(;
    modules=[EBayes],
    format=Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/nignatiadis/EBayes.jl/blob/{commit}{path}#L{line}",
    sitename="EBayes.jl",
    authors="Nikos Ignatiadis <nikos.ignatiadis01@gmail.com>",
    assets=String[],
)

deploydocs(;
    repo="github.com/nignatiadis/EBayes.jl",
)
