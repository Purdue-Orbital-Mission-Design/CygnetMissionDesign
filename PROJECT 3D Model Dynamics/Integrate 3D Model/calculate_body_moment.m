function M = calculate_body_moment(t, y, massProp)
    worldFrameForce = [0; -0; 0];
    worldFrameR = [0; 00; 10];
    
    bodyFrameForce = RotateVector(quaternion(y(1:4)), worldFrameForce);
    
    display(bodyFrameForce)
    
    M = cross(worldFrameR, bodyFrameForce);
    
    M = [0; 0; 0]
end