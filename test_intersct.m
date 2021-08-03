slate

epsilon = 1e-6;
skip_faces = [];

objFile = 'OBJ_for_testing/deer_triangulated.obj';
[m, C, I] = SolveMassProperties(objFile);
current_patch = RenderObj(objFile, C);
hold on

rotx = @(t) [1 0 0; 0 cos(t) -sin(t) ; 0 sin(t) cos(t)];
roty = @(t) [cos(t) 0 sin(t) ; 0 1 0 ; -sin(t) 0  cos(t)];
rotz = @(t) [cos(t) -sin(t) 0 ; sin(t) cos(t) 0 ; 0 0 1];

tic
ordered_triads = zeros(length(current_patch.Faces) * 3, 3);

for i = 1:length(current_patch.Faces)
    ordered_triads(i*3-2:i*3, :) = current_patch.Vertices(current_patch.Faces(i, :), :);
end

incoming_vector = [1; 0; 0];
planebasis1 = roty(pi / 2) * incoming_vector;
planebasis2 = cross(planebasis1, incoming_vector);
flattened_ordered_coords = ordered_triads * [planebasis2, planebasis1];

apparent_facet_areas = zeros(length(current_patch.Faces), 1);
for i = 1:length(current_patch.Faces)
    x_vals = flattened_ordered_coords(i*3-2:i*3-0, 1);
    y_vals = flattened_ordered_coords(i*3-2:i*3-0, 2);
    apparent_facet_areas(i) = 1 / 2 * det([x_vals, y_vals, [1; 1; 1]]);
    
    if apparent_facet_areas(i) < epsilon
        skip_faces = [skip_faces, i];
    end
end

flattened_triangles = polyshape.empty;
for i = 1:length(current_patch.Faces)
    if ~ismember(i, skip_faces)
        flattened_triangles(i) = polyshape(flattened_ordered_coords(i*3-2:i*3-0, 1), flattened_ordered_coords(i*3-2:i*3-0, 2));
    end
end

facet_normals = zeros(length(current_patch.Faces), 3);
facet_centroids = zeros(length(current_patch.Faces), 3);
facet_normals_to_incoming = zeros(length(current_patch.Faces), 1);
facet_force_contributions = zeros(length(current_patch.Faces), 1);

for i = 1:length(current_patch.Faces)
    if ~ismember(i, skip_faces)
        p1 = ordered_triads(i*3-2, :)';
        p2 = ordered_triads(i*3-1, :)';
        p3 = ordered_triads(i*3-0, :)';
        b1 = p3 - p2;
        b2 = p3 - p1;
        facet_normals(i, :) = cross(b1 / norm(b1), b2 / norm(b2))';
        facet_centroids(i, :) = mean(ordered_triads(i*3-2:i*3, :));
        facet_normals_to_incoming(i) = real(acos(max(min(dot(incoming_vector,facet_normals(i, :))/(norm(incoming_vector)*norm(facet_normals(i, :))),1),-1)));
        facet_force_contributions(i) = cos(pi - facet_normals_to_incoming(i)) * apparent_facet_areas(i);
%         disp(facet_force_contributions(i))
    end
end
toc

figure
hold on

cmap = parula(1000);
valued_variable = facet_force_contributions;

for i = 1:length(current_patch.Faces)
    if ~ismember(i, skip_faces)
        plot(flattened_triangles(i), 'FaceColor', cmap(ceil(valued_variable(i) / max(valued_variable) * length(cmap)), :))
    end
end




% o = [100 s r];
% d = [-100 s r];
% 
% valid_triads = struct('triads', [], 'dists', []);
% triads = [];
% dists = [];
% 
% tic
% 
% planebasis1 = rotx(pi / 2) * (d-o)';
% planebasis2 = cross(planebasis1, (d-o)');
% 
% projected_vertices = current_patch.Vertices * [planebasis1, planebasis2];
% 
% for i = 1:length(current_patch.Faces)
%     [flag, u, v, t, a] = fastRayTriangleIntersection(o, d, ordered_triads(i*3-2, :), ordered_triads(i*3-1, :), ordered_triads(i*3, :));
% 
%     if flag == 1
%         valid_triads.triads = [valid_triads.triads; ordered_triads(i*3-2:i*3, :)];
%         valid_triads.dists = [valid_triads.dists; t];
%     end
% end
% toc
% 
% 
% if size(valid_triads.triads)
%     disp(valid_triads)
%     [val, i] = min(valid_triads.dists);
%     if length(valid_triads.dists) > 1
%         scatter3(valid_triads.triads(i*3-2:i*3, 1), valid_triads.triads(i*3-2:i*3, 2), valid_triads.triads(i*3-2:i*3, 3), 'b.')
%     end
% % plot3([o(1) d(1)], [o(2) d(2)], [o(3) d(3)], 'r')
% end