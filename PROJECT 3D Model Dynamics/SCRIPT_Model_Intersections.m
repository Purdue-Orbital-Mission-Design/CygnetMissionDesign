slate

epsilon = 1e-6;
skip_faces = [];

objFile = 'OBJ_for_testing/deer_triangulated.obj';
[m, C, I] = SolveMassProperties(objFile);
current_patch = RenderObj(objFile, C);
hold on

tic
ordered_triads = zeros(length(current_patch.Faces) * 3, 3);

for i = 1:length(current_patch.Faces)
    ordered_triads(i*3-2:i*3, :) = current_patch.Vertices(current_patch.Faces(i, :), :);
end

incoming_vector = [1; 1; 0];
incoming_vector = incoming_vector / norm(incoming_vector);

point_in_projection_plane = null(incoming_vector')*((rand(2, 1)-0.5)*2); % <- here are the coordinates of random points

planebasis1 = point_in_projection_plane / norm(point_in_projection_plane);
planebasis2 = cross(incoming_vector, planebasis1);

flattened_ordered_triads = ordered_triads * [planebasis1, planebasis2];

apparent_facet_areas = zeros(length(current_patch.Faces), 1);
for i = 1:length(current_patch.Faces)
    x_vals = flattened_ordered_triads(i*3-2:i*3-0, 1);
    y_vals = flattened_ordered_triads(i*3-2:i*3-0, 2);
    apparent_facet_areas(i) = 1 / 2 * det([x_vals, y_vals, [1; 1; 1]]);
    
    if apparent_facet_areas(i) < epsilon
        skip_faces = [skip_faces, i];
    end
end

facet_normals = zeros(length(current_patch.Faces), 3);
facet_centroids = zeros(length(current_patch.Faces), 3);
flattened_facet_centroids = zeros(length(current_patch.Faces), 2);
facet_normals_to_incoming = zeros(length(current_patch.Faces), 1);
facet_force_contributions = zeros(length(current_patch.Faces), 1);

facet_centroid_to_projection_plane = zeros(length(current_patch.Faces), 3);

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
        
        flattened_facet_centroids(i, :) = mean(flattened_ordered_triads(i*3-2:i*3-0, :));
        facet_centroid_to_projection_plane(i, :) = ([planebasis1, planebasis2] * flattened_facet_centroids(i, :)')' - facet_centroids(i, :);
%         disp(facet_force_contributions(i))
    end
end

flattened_triangles = polyshape.empty;
for i = 1:length(current_patch.Faces)
    if ~ismember(i, skip_faces)
        flattened_triangles(i) = polyshape(flattened_ordered_triads(i*3-2:i*3-0, 1), flattened_ordered_triads(i*3-2:i*3-0, 2));
    end
end
toc

figure
hold on

cmap = parula(100);

valued_variable = facet_centroid_to_projection_plane(boolean(repmat(incoming_vector', length(facet_centroid_to_projection_plane), 1)));
for i = 1:length(current_patch.Faces)
    if ~ismember(i, skip_faces)
        lerp = (valued_variable(i) - min(valued_variable)) / (max(valued_variable) - min(valued_variable));
        col = cmap((ceil(lerp * (length(cmap) - 2) * 0.95 + 1)), :);
        plot(flattened_triangles(i), 'FaceColor', col)
        scatter(flattened_facet_centroids(i, 1), flattened_facet_centroids(i, 2), [], col)
    end
end