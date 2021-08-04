slate

objFile = 'OBJ_for_testing/deer_triangulated.obj';
[m, C, I] = SolveMassProperties(objFile);
current_patch = RenderObj(objFile, C);

times = struct('start', 0.0, 'step', 0.01, 'stop', 1);
massProp = struct('m', m, 'C', C, 'I', I);
w0 = [0.1; 5.0; 0.0];

[t1, q1, w1] = IntegrateEuler(massProp, w0, times);
prev_quat = q1(1);

fig1 = gcf;
ax1 = gca;
fig2 = figure;

brightness = zeros(1, length(t1));

tic
for i = 1:length(t1)
    RotatePatchByQuat(current_patch, q1(1) * (prev_quat ^ -1 * q1(i)) * q1(1) ^ -1)
    [brightness(i), image] = getBrightnessOfFigure(ax1, fig2);
    prev_quat = q1(i);
end
toc

figure, plot(t1, brightness)