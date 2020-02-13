using EBayes
using StatsPlots
using InteractiveUtils

ash_prs = [T() for  T in subtypes(EBayes.AshPrior)]
plot(plot.(ash_prs)...)

iw_prs = [T() for  T in subtypes(EBayes.IWPrior)]
plot(plot.(iw_prs)...)

plot(EBayes.EfronUnifNormal())
