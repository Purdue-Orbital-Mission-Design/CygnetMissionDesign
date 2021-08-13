% random quat
% rotate patch to quat
% compute brdf there
% store

MaintainPath;
CleanSlate;

objFile = 'testtorus.obj';
objClassification = 'Testing Models';
[m, C, I] = SolveMassProperties(objClassification, objFile);
current_patch = RenderObj(objFile, C);

tic
numQuats = 5000;
randomOrientations = quaternion.randRot([numQuats, 1]);
toc

checkAxes = rand(3, numQuats);

checkOrientations1 = quaternion.angleaxis(rand(1, numQuats), checkAxes)';
checkOrientations2 = checkOrientations1(randperm(numQuats), :);

initial_patch_state = struct('Faces', current_patch.Faces, 'Vertices', current_patch.Vertices);

[BRDF, rotated_vectors, angles] = computeBRDFForQuats(initial_patch_state, current_patch, randomOrientations, quaternion(1, 0, 0, 0));

rotated_scaled_points = BRDF / max(BRDF) .* rotated_vectors;

x = rotated_vectors(:, 1);
y = rotated_vectors(:, 2);
z = rotated_vectors(:, 3);

x_scaled = rotated_scaled_points(:, 1);
y_scaled = rotated_scaled_points(:, 2);
z_scaled = rotated_scaled_points(:, 3);

figure;
plot(1:length(BRDF), BRDF)
figure; 

colmap = colormap;
scatter3(x_scaled, y_scaled, z_scaled, 70, colmap(ceil(angles / max(angles) * length(colormap)), :), '.')
hold on
% scatter3(x, y, z, 'k.')
scatter3(0, 0, 0, 'r*')

% maxdisp = max(vecnorm(rotated_scaled_points));
% xlim([-maxdisp, maxdisp])
% ylim([-maxdisp, maxdisp])
% zlim([-maxdisp, maxdisp])


% tri = delaunay(x, y, z);
% h = trisurf(tri, x, y, z);