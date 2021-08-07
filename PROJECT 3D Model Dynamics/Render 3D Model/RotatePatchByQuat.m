function RotatePatchByQuat(current_patch, quat)
    [ang, axis] = AngleAxis(quat);
    rotate(current_patch, axis, ang * 180 / pi);
end