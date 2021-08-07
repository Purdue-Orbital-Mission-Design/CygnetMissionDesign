function [current_patch] = RenderObj(objName, C)
    fv_draft = readObj(objName);
    fv = struct;
    fv.Vertices = fv_draft.v;
    fv.Faces = fv_draft.f.v;
    
    current_patch = patch(fv,                  ...
             'FaceColor',       [0.8 0.8 1.0],    ...
             'EdgeColor',       'none', ...
             'FaceLighting',    'gouraud',     ...
             'AmbientStrength', 0.1,           ...
             'LineWidth', 0.01);
                      
    % Add a camera light, and tone down the specular highlighting
    camlight('headlight');
    material('dull');

    % Fix the axes scaling, and set a nice view angle
    axis('image');
    view([135 3]);
    
    current_patch.Vertices(:, 1) = current_patch.Vertices(:, 1) - C(1);
    current_patch.Vertices(:, 2) = current_patch.Vertices(:, 2) - C(2);
    current_patch.Vertices(:, 3) = current_patch.Vertices(:, 3) - C(3);
    
    val = max(vecnorm(current_patch.Vertices'));
    xlim([-val, val])
    ylim([-val, val])
    zlim([-val, val])
    grid on
end