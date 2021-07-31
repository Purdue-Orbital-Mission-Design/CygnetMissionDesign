function M = body_moment(t, y, massProp)
    F = [0; 0; 10];
    R = [10; 0; 0];
    M = cross(R - massProp.C, F);
end