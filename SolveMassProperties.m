function [m, C, I] = SolveMassProperties(objFile)
    fv = readObj(objFile);
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
