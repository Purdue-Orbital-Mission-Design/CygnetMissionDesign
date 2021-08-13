function [old_c, new_c, old_v] = KbyKNewtonsMethod(k, old_c, new_c, old_v, new_v, f, constantspackage)
    del_c = new_c - old_c;
    aug_c = repmat(new_c, k, 1) + diag(diag(repmat(del_c, k, 1)));
    
    del_f = zeros(k, k);

    for i = 1:k
        del_f(:, i) = f(aug_c(i, :), constantspackage);
    end
    
    jacobian = (del_f - new_v) ./ del_c;
    
    old_c = new_c;
    old_v = new_v;
    
    if k > 1
        new_c = new_c - (jacobian ^ -1 * new_v)'; 
    else
        new_c = new_c - (jacobian .^ -1 * new_v)';
    end
end