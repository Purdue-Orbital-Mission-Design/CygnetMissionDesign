function hull_triads = computeHullTriads(current_patch)
    hullPoints = convhull(current_patch.Vertices);
    hull_triads = zeros(length(current_patch.Faces) * 3, 3);
    for i = 1:length(hullPoints)
        hull_triads(i*3-2:i*3, :) = current_patch.Vertices(hullPoints(i, :), :);
    end
end