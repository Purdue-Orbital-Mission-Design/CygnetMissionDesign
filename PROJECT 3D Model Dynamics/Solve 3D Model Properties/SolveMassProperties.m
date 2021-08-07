%   Function:   SolveMassProperties
%               
%   Desc.:      Computes mass properties for a given 3D model file
%               
%   Author:     Liam Robinson
%               
%   Edit Log:   [07-Aug-2021] Liam Robinson: Created
%               
%   Inputs:     objClassification = Folder name within /3D Models/
%               objName = File name of 3D model (.obj supported)
%               
%   Outputs:    m = Mass of 3D model [kg]
%               C = Center of mass of 3D model in model space [m] (3, 1)
%               I = Inertia matrix of model in [kg m^2] (3x3)

function [m, C, I] = SolveMassProperties(objClassification, objFile)
    fv = readObj(strcat('3D Models/', objClassification, '/', objFile));
    I = zeros(3, 3);
    C = zeros(3, 1);
    m = 0;

    for i = 1:length(fv.f.v)
        verts = fv.v(fv.f.v(i, :), :);
        
        a = verts(1, :);
        b = verts(2, :);
        c = verts(3, :);

        [dm, dv, dc, di] = AddTriangleContribution(a, b, c);
        I = I + di;
        C = C + dc;
        m = m + dm;
    end

    [m, C, I] = GetResults(m, C, I);
end
