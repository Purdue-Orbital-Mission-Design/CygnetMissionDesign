%   Function:   FunctionHeader
%               
%   Desc.:      Copies the function header template to the clipboard
%               
%   Author:     Liam Robinson
%               
%   Edit Log:   [07-Aug-2021] Liam Robinson: Created
%               
%   Inputs:     None
%               
%   Outputs:    None, although a string is copied to the user's clipboard

function FunctionHeader()
    clipboard('copy', sprintf(strcat(...
    '%%   Function:   \n', ...
    '%%               \n', ...
    '%%   Desc.:      \n', ...
    '%%               \n', ...
    "%%   Author:     " + getenv("OrbitalName") + "\n", ...
    '%%               \n', ...
    "%%   Edit Log:   [" + date + "] " + getenv("OrbitalName") + ": Created" + "\n", ...
    '%%               \n', ...
    '%%   Inputs:     \n', ...
    '%%               \n', ...
    '%%   Outputs:    \n')))
end

% Completed Example:

%   Function:   DragFunction
%
%   Desc:       Computes the total drag force and moment on a 3D model
%               
%   Author:     Mitch Daniels
%
%   Edit Log:   [07-Aug-2021] Mitch Daniels: Created
%               [08-Aug-2021] Liam Robinson: Fixed center of mass calculation
%               
%   Inputs:     ModelString = Relative file path to 3D model
%               IncomingVector = Inertial direction of drag force
%               AtmosphericDensity = Air density in [pa]
%
%   Outputs:    AppliedForce = Net force applied to model
%               AppliedMoment = Net moment applied to model