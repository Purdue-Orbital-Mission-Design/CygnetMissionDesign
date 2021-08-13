function RMS = findRMSForOmegaRun(omegay_guess, constants_package)
    truthBRDF = constants_package.truthBRDF;
    current_patch = constants_package.current_patch;
    initial_patch_state = constants_package.initial_patch_state;
    times = constants_package.times;
    massProp = constants_package.massProp;
    w_guess = constants_package.w_guess;

    f2 = @(varargin) computeBRDFForOmega(varargin);
    f3 = @(truthBRDF, guessBRDF) sqrt(mean((truthBRDF - guessBRDF) .^ 2));
    
    RMS = f3(truthBRDF, f2(massProp, [w_guess(1); omegay_guess; w_guess(3)], times, initial_patch_state, current_patch))
end