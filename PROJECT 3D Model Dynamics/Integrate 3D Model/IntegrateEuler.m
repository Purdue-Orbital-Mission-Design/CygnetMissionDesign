function [t1, q1, w1] = IntegrateEuler(massProp, w0, times, momentfunction)
    [vecs, vals] = eig(massProp.I);
    vecs = vecs * det(vecs);

    q0 = quaternion.rotationmatrix(vecs);
    PlotBasis(vecs)

    I_princ = diag(vals);

    t = times.start:times.step:times.stop;

    [q1, w1, t1] = PropagateEulerEq(q0, w0, I_princ, t, momentfunction(t, massProp));
end
