MaintainPath
CleanSlate

objFile = 'deer_triangulated.obj';
objClassification = 'Testing Models';
[m, C, I] = SolveMassProperties(objClassification, objFile);
current_patch = RenderObj(objFile, C);
initial_patch_state = struct('Faces', current_patch.Faces, 'Vertices', current_patch.Vertices);

times = struct('start', 0.0, 'step', 0.01, 'stop', 0.2);
massProp = struct('m', m, 'C', C, 'I', I);
w0 = [2; 5.0; 0.0];

[truthBRDF, truthTime] = computeBRDFForOmega(massProp, w0, times, initial_patch_state, current_patch);

w_guess = [2; 3; 0];

k = 1; %num equations == num variables
tol = 1e-10;

searching_for = [0];

old_c = [3];
del_c = [rand / 10];
new_c = del_c + old_c;

constants_pkg = struct( ...
    'w_guess', w_guess, ...
    'massProp', massProp, ...
    'times', times, ...
    'initial_patch_state', initial_patch_state, ...
    'current_patch', current_patch, ...
    'truthBRDF', truthBRDF);


old_v = findRMSForOmegaRun(old_c, constants_pkg);
new_v = findRMSForOmegaRun(new_c, constants_pkg);

i = 0;
while max(abs(new_v)) > tol && i < 100
    i = i + 1;

    [old_c, new_c, old_v] = KbyKNewtonsMethod(k, old_c, new_c, old_v, new_v, @findRMSForOmegaRun, constants_pkg);

    new_v = findRMSForOmegaRun(new_c, constants_pkg);
    
    disp(new_c)
end

disp(new_v)