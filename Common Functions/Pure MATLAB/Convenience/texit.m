function texit(titleText, xLabelText, yLabelText, varargin)

a = gca;
a.TickLabelInterpreter = 'latex';
a.YLabel.Interpreter = 'latex';
a.XLabel.Interpreter = 'latex';
a.ZLabel.Interpreter = 'latex';
a.Title.Interpreter = 'latex';

title(titleText)
xlabel(xLabelText)
ylabel(yLabelText)

if(~isempty(varargin))
    legend(varargin{1})
end

if(size(a.Legend) ~= 0)
    a.Legend.Interpreter = 'latex';
    a.Legend.FontSize = 12;
end

a.Title.FontSize = 18;
a.XLabel.FontSize = 14;
a.YLabel.FontSize = 14;
a.ZLabel.FontSize = 14;

grid on