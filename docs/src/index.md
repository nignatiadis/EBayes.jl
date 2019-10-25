# EBayes.jl

A package for empirical Bayes (EB) estimation in Julia. Currently the main functionality is estimation in the Gaussian compound decision problem in which we observe:

```math
Z_i \sim \mathcal{N}(\mu_i, \sigma_i^2),\; i=1,\dotsc,n
```

``Z_i`` is observed, ``\sigma_i^2`` is assumed to be known and ``\mu_i`` is unknown. The goal is to use all ``Z_i`` and potential covariates ``X_i`` to design estimators ``\hat{\mu}_i`` of ``\mu_i`` such that ``\sum_i \mathbb{E}\left[(\mu_i - \hat{\mu}_i)^2\right]`` is small.

A longer term goal of this package is to provide a unified interface for EB method development and applications.

# Getting started

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




## EB with covariates: EBayesCrossFit
### Regression estimators

Now let us consider the case that we also have contextual side information about each unit ``i``, i.e., we have covariates ``X_i`` for each ``i`` that may be informative about the ``\mu_i``. The difference compared to ``Z_i`` is that we do not  make any probabilistic assumptions about how ``X_i`` is related to ``\mu_i`` (while we know that ``Z_i`` is unbiased for ``\mu_i``).

If the ``X_i``'s capture ``\mu_i`` perfectly, then a powerful machine learning method will be able to learn the relationship if we regress ``Z_i \sim X_i``. For this task we can use [MLJ.jl](https://github.com/alan-turing-institute/MLJ.jl), which provides a unified framework for working with machine learning methods.

Continuing with our toy problem, let us simulate two-dimensional covariates; the first dimension is informative for ``\mu_i``, while the second is not.

```@example normal_normal
using MLJ, MLJBase

Xs1 = μs .+ randn(n)
Xs2 = randn(n)
Xs = table([Xs1 Xs2])
nothing  # hide
```

We now use MLJ to fit a model (here just ordinary least squares linear regression) and then use the model to predict the ``\mu_i``'s:

```@example normal_normal

lin_mlj = MLJ.@load LinearRegressor pkg=GLM

lin_mach = fit!(machine(lin_mlj, Xs, Zs), verbosity=0)
lin_preds = predict_mean(lin_mach)

mean((lin_preds .- μs).^2)
```
In this example, the regression has almost the same mean squared as the SURE method.

### EBayesCrossFit

We have seen two strong baselines: The empirical Bayes (SURE) method that utilizes the information in the ``Z_i``'s by accounting for their known sampling distributions and the regression (ML) method that utilizes the information in the ``X_i``'s. The `EBayesCrossFit` method [(Ignatiadis and Wager, 2019)](https://arxiv.org/abs/1906.01611) synthesizes both sources of information through the empirical Bayes principle and by simultaneously leveraging any (black-box) ML method.

Let us apply the `EBayesCrossFit` method in conjuction with the linear regression we used previously:

```@example normal_normal

ebcf_lin = EBayesCrossFit(lin_mlj) # EBCF with linear regression
ebcf_fit = fit(ebcf_lin, Xs, ss)   # fit EBCF
ebcf_preds = predict(ebcf_fit)     # gather EBCF predictions

mean((ebcf_preds .- μs).^2)        # evaluate EBCF
```

We see that indeed the `EBayesCrossFit` method outperforms both baselines.


# API Reference
## EBayes sample types

```@docs
NormalSample
```

```@index
```

