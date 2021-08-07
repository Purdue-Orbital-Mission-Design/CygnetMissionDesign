function [root, scenario] = GetCurrentRootAndScenario()
    % Connect an instance of STK
    uiApplication = actxGetRunningServer('STK12.Application');

    % Get our IAgStkObjectRoot interface
    root = uiApplication.Personality2;
    scenario = root.CurrentScenario;
end