slate

objFile = 'OBJ_for_testing/deer_triangulated.obj';
[m, C, I] = SolveMassProperties(objFile);

subplot(2, 1, 1)
current_patch = RenderObj(objFile, C);

times = struct('start', 0.0, 'step', 0.1, 'stop', 10);
massProp = struct('m', m, 'C', C, 'I', I);
w0 = [0.1; 5.0; 0.0];

[t1, q1, w1] = IntegrateEuler(massProp, w0, times);
prev_quat = q1(1);

subplot(2, 1, 2)
f = figure(gcf);
f.Position = [f.Position(1) f.Position(2) - 200 700 600];

f = getframe(gcf);
[im,map] = rgb2ind(f.cdata, 256, 'nodither');
im(1,1,1,length(t1)) = 0;

for j = 1:length(t1)
    subplot(2, 1, 1)
    fprintf("Processing t = %.2f, %.2f%% complete\n", t1(j), j / length(t1) * 100)
    
    RotatePatchByQuat(current_patch, q1(1) * (prev_quat ^ -1 * q1(j)) * q1(1) ^ -1)
    prev_quat = q1(j);
    
    f = getframe(gcf);
    im(:,:,1,j) = rgb2ind(f.cdata,map);
    
    subplot(2, 1, 2)
    cla
    hold on
    plot(t1(1:j), w1(1, 1:j), t1(1:j), w1(2, 1:j), t1(1:j), w1(3, 1:j))
    ax = gca;
    ax.XLim = [0, times.stop];
    ax.YLim = [min(min(w1)) - 1, max(max(w1)) + 1];
    
    if j == 1
        texit("$$\omega$$ Over Time", "Time in [s]", "$$\omega$$ in [$$\frac{rad}{s}$$]")
    end
end

imwrite(im,map,'Eulered.gif','DelayTime',0,'LoopCount',inf) %g443800
    
% [root, ~] = GetCurrentRootAndScenario();
% TranslateModelToCenterOfMass(root, "Satellite1", C)
% SaveAttitude(t1, q1)
