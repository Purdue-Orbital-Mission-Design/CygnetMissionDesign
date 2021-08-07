function [dm, dv, dc, di] = AddTriangleContribution(A, B, C)
    %First triangle point
    x1 = A(1);
    y1 = A(2);
    z1 = A(3);
    
    %Second triangle point
    x2 = B(1);
    y2 = B(2);
    z2 = B(3);
    
    %Third triangle point
    x3 = C(1);
    y3 = C(2);
    z3 = C(3);
    
    %Signed volume of this tetrahedron.
    dv = (x1*y2*z3 + y1*z2*x3 + x2*y3*z1 - (x3*y2*z1 + x2*y1*z3 + y3*z2*x1));
    dm = dv;
    
    %Contribution to the centroid
    x4 = x1 + x2 + x3;           
    y4 = y1 + y2 + y3;           
    z4 = z1 + z2 + z3;           
    
    dc = dv * [x4; y4; z4];
    
    %Contribution to moment of inertia monomials
    di = zeros(3, 3);
    di(1, 1) = dv * (x1*x1 + x2*x2 + x3*x3 + x4*x4);
    di(2, 2) = dv * (y1*y1 + y2*y2 + y3*y3 + y4*y4);
    di(3, 3) = dv * (z1*z1 + z2*z2 + z3*z3 + z4*z4);
    di(1, 2) = dv * (y1*x1 + y2*x2 + y3*x3 + y4*x4);
    di(1, 3) = dv * (z1*x1 + z2*x2 + z3*x3 + z4*x4);
    di(2, 3) = dv * (z1*y1 + z2*y2 + z3*y3 + z4*y4);
end