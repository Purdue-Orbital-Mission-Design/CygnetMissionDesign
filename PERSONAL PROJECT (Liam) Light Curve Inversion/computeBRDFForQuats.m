function [BRDF, rotated_vectors, angles] = computeBRDFForQuats(initial_faces_vertices, current_patch, q1, basis_quat)
    ax1 = gca;
    fig2 = figure;

    angles = zeros(length(q1), 1);
    BRDF = zeros(length(q1), 1);
    rotated_vectors = zeros(length(q1), 3);

    tic
    prev_quat = q1(1);
    
    for i = 1:length(q1)
        current_quat = q1(i);
        angles(i) = RotatePatchByQuat(initial_faces_vertices, current_patch, basis_quat, prev_quat, current_quat);
        [BRDF(i), ~] = getBrightnessOfFigure(ax1, fig2);
        rotated_vectors(i, :) = current_patch.Vertices(1, :);
        
        prev_quat = q1(i);
    end
    toc
    delete(fig2)
end