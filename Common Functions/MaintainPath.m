%   Function:   MaintainPath
%
%   Desc:       Adds all repository folders to MATLAB path so that scripts
%               can reference all necessary functions
%
%   Author:     Liam Robinson
%
%   Edit Log:   [07-Aug-2021] Liam Robinson: Created
%               
%   Inputs:     None
%
%   Outputs:    repositorySubfolders = String of all file paths in parent folder

function repositorySubfolders = MaintainPath()
    % Determine where your m-file's folder is.    
    folder = fileparts(which(mfilename));
    splitfolder = strsplit(folder, '/');
    prunePoint = length(cell2mat(splitfolder(end)));
    
    % Moves up to the parent folder by deleting the current folder
    repositorySubfolders = folder(1:length(folder) - prunePoint - 1);
    
    % Add that folder plus all subfolders to the path.
    addpath(genpath(repositorySubfolders));
    savepath;
end