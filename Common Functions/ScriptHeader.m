%   Function:   ScriptHeader
%               
%   Desc.:      Copies the script header template to the clipboard
%               
%   Author:     Liam Robinson
%               
%   Edit Log:   [07-Aug-2021] Liam Robinson: Created
%               
%   Inputs:     None
%               
%   Outputs:    None, although a string is copied to the user's clipboard

function ScriptHeader()
    clipboard('copy', sprintf(strcat(...
    '%%   Script:     \n', ...
    '%%               \n', ...
    '%%   Use:        \n', ...
    '%%               \n', ...
    "%%   Author:     " + getenv("OrbitalName") + "\n", ...
    '%%               \n', ...
    "%%   Edit Log:   [" + date + "] " + getenv("OrbitalName") + ": Created" + "\n", ...
    '%%               \n', ...
    '%%   Media Out:  \n')))
end

% Completed Example:

%   Script:     SCRIPT_Surface_Plotter
%               
%   Use:        Calculates the visible surface of a model from a given
%               vector over time, writing plot out as a .gif
%               
%   Author:     Liam Robinson
%               
%   Edit Log:   [07-Aug-2021] Liam Robinson: Created
%               [08-Aug-2021] Mitch Daniels: Fixed .gif pronunciation
%               
%   Media Out:  [SurfacePlot.gif] 
%               /Media Files/3D Model Dynamics/SurfacePlot.gif