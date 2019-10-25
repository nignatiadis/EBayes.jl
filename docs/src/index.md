# EBayes.jl

## Introduction
A package for empirical Bayes (EB) estimation in Julia. Currently the main functionality is estimation in the Gaussian compound decision problem in which we observe:

```math
Z_i \sim \mathcal{N}(\mu_i, \sigma_i^2),\; i=1,\dotsc,n
```

``Z_i`` is observed, ``\sigma^2`` is assumed to be known and ``\mu`` is unknown. The goal is to use all ``Z_i`` and potential covariates ``X_i`` to design estimators ``\hat{\mu}_i`` of ``\mu_i`` such that ``\sum_i \mathbb{E}\left[(\mu_i - \hat{\mu}_i)^2\right]`` is small.

A longer term goal of this package is to provide a unified interface for EB method development and application.

## SURE EB estimator

Let us generate toy data:

```@example normal_normal
using Random
Random.seed!(1)

n = 10000
σs = fill(1.0, n)
μs = randn(n) .* σs
Zs = μs .+ randn(n)
nothing  # hide
```

We first check the mean squared error if we try to estimate ``\mu_i`` by ``Z_i``:

```@example normal_normal
using StatsBase
mean( (μs - Zs).^2 )
```

Instead let us use the Normal SURE method of [Xie, Kou, and Brown (2012)](https://doi.org/10.1080/01621459.2012.728154), which has been implemented in this package. To do this, we will first need to wrap the `Zs` and `σs` as `NormalSamples`.

```@example normal_normal
using EBayes
ss = NormalSamples(Zs, σs)
sure_fit = fit(Normal(), SURE(), ss)
sure_pred = predict(sure_fit)

mean( (μs - sure_pred).^2 )
```

## EB CrossFit estimator


## Empirical Bayes sample types

```@docs
NormalSample
```


```@index
```

