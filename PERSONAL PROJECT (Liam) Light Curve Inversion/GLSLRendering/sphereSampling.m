function sphereVertices = sphereSampling(numFaces)
    spherePts = zeros(numFaces+1, numFaces+1, 3);
    [spherePts(:, :, 1), spherePts(:, :, 2), spherePts(:, :, 3)] = sphere(numFaces);
    numPts = numel(spherePts(:, :, 1));

    sphereVertices = zeros(numel(spherePts(:, :, 1)), 3);
    sphereVertices(:, 1) = reshape(spherePts(:, :, 1), numPts, 1);
    sphereVertices(:, 2) = reshape(spherePts(:, :, 2), numPts, 1);
    sphereVertices(:, 3) = reshape(spherePts(:, :, 3), numPts, 1);
end