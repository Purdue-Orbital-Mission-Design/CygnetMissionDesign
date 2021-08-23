CleanSlate

objFile = 'deer_triangulated.obj';
objClassification = 'Testing Models';
[m, C, I] = SolveMassProperties(objClassification, objFile);
[principalAxes, principalMOIs] = eig(I);
principalMOIs = principalMOIs([9 5 1])';
principalAxes = principalAxes(:, [3 2 1]);

times = struct('start', 0.0, 'step', 0.01, 'stop', 50);
massProp = struct('m', m, 'C', C, 'I', I);

w0 = -1 + 2 * rand(3, 1);
w0 = w0 / norm(w0);
w0 = [1; 1; 0];

[t1, q1, w1] = IntegrateEuler(massProp, w0, times, @(t, massProp) [0, 0, 0]);

T = principalMOIs .* w1 .^ 2;
% L = dot(w1)

L = zeros(1, length(w1));

for i = 1:length(w1)
    L(i) = dot(principalMOIs, diag(principalAxes * diag(w1(:, i)) * principalAxes ^ -1));
end

figure
plot(t1, w1)

figure
plot(t1, L)

figure
scatter3(w1(1, :), w1(2, :), w1(3, :))