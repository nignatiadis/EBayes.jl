# EBayes.jl

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://nignatiadis.github.io/EBayes.jl/dev)
[![Build Status](https://travis-ci.com/nignatiadis/EBayes.jl.svg?branch=master)](https://travis-ci.com/nignatiadis/EBayes.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/nignatiadis/EBayes.jl?svg=true)](https://ci.appveyor.com/project/nignatiadis/EBayes-jl)
[![Codecov](https://codecov.io/gh/nignatiadis/EBayes.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/nignatiadis/EBayes.jl)
[![Coveralls](https://coveralls.io/repos/github/nignatiadis/EBayes.jl/badge.svg?branch=master)](https://coveralls.io/github/nignatiadis/EBayes.jl?branch=master)

A Julia package for empirical Bayes estimation. See the [documentation](https://nignatiadis.github.io/EBayes.jl/dev) for instructions on how to use it.

The package implements the empirical Bayes cross-fit method [1], which estimates effect sizes of many experiments by optimally synthesizing experimental data and rich covariate information. Furthermore, the method may leverage any black-box predictive model: [1] provides theoretical guarantees that hold for *any* regression method and the package here allows usage of any supervised model that has implemented the [MLJ.jl](https://github.com/alan-turing-institute/MLJ.jl) interface.

# References

[1] Ignatiadis, N., & Wager, S. (2019). Covariate-Powered Empirical Bayes Estimation. To appear in Advances in Neural Information Processing Systems 32 (NeurIPS 2019). [arXiv:1906.01611.](https://arxiv.org/abs/1906.01611)

