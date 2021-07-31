function PlotBasis(vecs)
    hold on
    for i = 1:length(vecs)
        sc = 10;
        plot3([0; vecs(1, i)] * sc, [0; vecs(2, i)] * sc, [0; vecs(3, i)] * sc, 'LineWidth', 2)
    end
end