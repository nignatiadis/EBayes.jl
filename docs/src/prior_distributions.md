# Empirical Bayes Priors

```@setup setup
import Pkg
Pkg.add("StatsPlots")
Pkg.add("GR")
using EBayes
using StatsPlots
using InteractiveUtils
gr()
```



```@docs
EBayes.AshSpiky
```

```@example setup
ash_prs = [T() for  T in subtypes(EBayes.AshPrior)]
plot(plot.(ash_prs)...)
savefig("plot_ash_priors.png") # hide
```
![](plot_ash_priors.png)

```@docs
EBayes.IWUnimod
```

```@example setup
plot(plot.([EBayes.IWUnimod(), EBayes.IWBimod()])..., size=(600,300))
savefig("plot_iw_priors.png") # hide
```

![](plot_iw_priors.png)

```@docs
EBayes.EfronUnifNormal
```

```@example setup
plot(EBayes.EfronUnifNormal(), size=(600,300))
savefig("plot_efron_prior.png") # hide
```

![](plot_efron_prior.png)
