MaintainPath
CleanSlate

objFile = 'deer_triangulated.obj';
objClassification = 'Testing Models';
[m, C, I] = SolveMassProperties(objClassification, objFile);
current_patch = RenderObj(objFile, C);

times = struct('start', 0.0, 'step', 0.1, 'stop', 2);
massProp = struct('m', m, 'C', C, 'I', I);
w0 = [2; 5.0; 0.0];

initial_patch_state = struct('Faces', current_patch.Faces, 'Vertices', current_patch.Vertices);

[truthBRDF, truthTime] = computeBRDFForOmega(massProp, w0, times, initial_patch_state, current_patch);
[guessBRDF, ~] = computeBRDFForOmega(massProp, [1; 2; 3], times, initial_patch_state, current_patch);

figure
plot(truthTime, truthBRDF)
hold on
plot(truthTime, guessBRDF)

RMS = sqrt(mean((truthBRDF - guessBRDF) .^ 2));
