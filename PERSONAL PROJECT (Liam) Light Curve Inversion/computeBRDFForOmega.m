function [BRDF, t1] = computeBRDFForOmega(massProp, w0, times, initial_patch_state, current_patch)
    if isequal(size(massProp), [1 5])
        current_patch = massProp{5};
        initial_patch_state = massProp{4};
        times = massProp{3};
        w0 = massProp{2};
        massProp = massProp{1};
    end
    
    [t1, q1, ~] = IntegrateEuler(massProp, w0, times, @(t, massProp) [0, 0, 0]);
    BRDF = computeBRDFForQuats(initial_patch_state, current_patch, q1, q1(1));
end