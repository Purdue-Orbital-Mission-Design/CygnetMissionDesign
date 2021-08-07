function [m, C, I] =  GetResults(m, C, I)
    r = 1.0 / (4 * m);
    C = C * r;

    %Mass
    m = m / 6;

    %Moment of inertia about the centroid.
    r = 1.0 / 120;
    
    I(1, 2) = I(1, 2) * r - m * C(2)*C(1);
    I(1, 3) = I(1, 3) * r - m * C(3)*C(1);
    I(2, 3) = I(2, 3) * r - m * C(3)*C(2);
    
    I(2, 3) = -I(2, 3);
    I(1, 3) = -I(1, 3);
    I(1, 2) = -I(1, 2);

    I(3, 2) = I(2, 3);
    I(3, 1) = I(1, 3);
    I(2, 1) = I(1, 2);

    xx = I(1, 1) * r - m * C(1)*C(1);
    yy = I(2, 2) * r - m * C(2)*C(2);
    zz = I(3, 3) * r - m * C(3)*C(3);

    I(1, 1) = yy + zz;
    I(2, 2) = zz + xx;
    I(3, 3) = xx + yy;
end