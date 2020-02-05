"""
    ash_spiky, ash_nearnormal, ash_flattop, ash_skew, ash_bignormal, ash_bimodal

Empirical Bayes priors that are used in the simulations of:

Stephens, M., 2017. False discovery rates: a new deal. Biostatistics, 18(2), pp.275-294.
"""
ash_spiky, ash_nearnormal, ash_flattop, ash_skew, ash_bignormal, ash_bimodal

const ash_spiky =  MixtureModel( [Normal(0,0.25); Normal(0,0.5); Normal(0,1); Normal(0,2)] ,
                           [0.4; 0.2; 0.2; 0.2 ])

const ash_nearnormal = MixtureModel([Normal(0,1); Normal(0,2)], [1/3; 2/3])

const ash_flattop = MixtureModel([Normal(x,0.5) for x=-1.5:0.5:1.5])

const ash_skew = MixtureModel([Normal(-2,2), Normal(-1,1.5), Normal(0,1), Normal(1,1)],
                        [1/4; 1/4; 1/3; 1/6])

const ash_bignormal = Normal(0,4)

const ash_bimodal = MixtureModel( [Normal(-2,1); Normal(2,1)],
                            [0.5;0.5] )



"""
    iw_unimod, iw_bimod

Empirical Bayes priors that are used in the simulations of:

Ignatiadis, N. and Wager, S., 2019. Bias-aware confidence intervals for empirical Bayes analysis.
arXiv preprint arXiv:1902.02774.
"""
iw_unimod, iw_bimod

const iw_unimod = MixtureModel([ Normal(-0.2,.2), Normal(0,0.9)],[0.7, 0.3])
const iw_bimod = MixtureModel([Normal(-1.5,.2), Normal(1.5, .2)])
