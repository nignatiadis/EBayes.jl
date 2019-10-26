

# in principle could be any EBayesShrinkageLocation, as long as it allows sample splitting.

# R: Regression method used
# R: EBayes method that will be applied within each fold

struct EBayesCrossFit{M <: MLJBase.Supervised, I <: Integer} <: AbstractEBayesMethod
    model::M
    num_folds::I
end

EBayesCrossFit(model; num_folds=5) = EBayesCrossFit(model, num_folds)

struct EBayesCrossFitResult{EBS <: NormalSamples,
                        XT,# dataframe
                        KF <: FoldsView, #split into folds
                        MF, #modelfits
                        EBF, #eb_fits
                        T,
                        EBCF}
    ss::EBS
    X::XT
    kfolds::KF
    reg_fits::MF
    eb_fits::EBF
    reg_preds::T
    eb_preds::T
    ebcf_method::EBCF
end

function fit(ebcf::EBayesCrossFit, Xs, ss::NormalSamples; verbosity=0)
    num_folds = ebcf.num_folds

    eb_preds = copy(response(ss))
    reg_preds = copy(response(ss))

    kf = kfolds(shuffleobs(1:length(ss)), num_folds)

    reg_fits = nothing # for now
    eb_fits = []

    # Initialize MLJ machine
    mlj_mach = MLJ.machine(ebcf.model, Xs, response(ss))

    for (train_idx, test_idx) in kf
        fit!(mlj_mach, rows=train_idx, verbosity=verbosity)
        if isa(ebcf.model, MLJBase.Deterministic)
            μs_pred = predict(mlj_mach, rows=test_idx)
        else
            μs_pred = predict_mean(mlj_mach, rows=test_idx)
        end
        eb_fit = fit(Normal(), SURE(), FixedLocation(μs_pred), ss[test_idx])
        push!(eb_fits, eb_fit)

        reg_preds[test_idx] = μs_pred
        eb_preds[test_idx] = predict(eb_fit)
    end

    EBayesCrossFitResult(ss, Xs, kf,
                reg_fits, eb_fits,
                reg_preds, eb_preds,
                ebcf)
end

function predict(ebcf_res::EBayesCrossFitResult)
    ebcf_res.eb_preds
end