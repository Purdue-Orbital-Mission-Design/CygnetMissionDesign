function [ang, axis] = RotatePatchByQuat(initial_faces_vertices, current_patch, basis_quat, prev_quat, current_quat)
    if initial_faces_vertices.Faces == false
        
        q = basis_quat * (prev_quat ^ -1 * current_quat) * basis_quat ^ -1;
 
    else
        current_patch.Faces = initial_faces_vertices.Faces;
        current_patch.Vertices = initial_faces_vertices.Vertices;
        
        q = basis_quat * current_quat * basis_quat ^ -1;

    end
    
    [ang, axis] = AngleAxis(q);
    rotate(current_patch, axis, ang * 180 / pi);
end