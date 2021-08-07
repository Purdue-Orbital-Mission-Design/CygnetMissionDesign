%   Function:   RunSetup
%               
%   Desc.:      Creates environmental variables necessary for documentation
%               Functions. Runs MaintainPath to build path variables
%               
%   Author:     Liam Robinson
%               
%   Edit Log:   [07-Aug-2021] Liam Robinson: Created
%               
%   Inputs:     OrbitalName = String of "Firstname Lastname"
%               
%   Outputs:    None

function RunSetup(OrbitalName)
    % Sets the user's name as an environmental variable
    setenv("OrbitalName", OrbitalName)
    
    % Builds the path needed for repo use
    oldFolder = cd('Common Functions');
    MaintainPath;
    cd(oldFolder);
end