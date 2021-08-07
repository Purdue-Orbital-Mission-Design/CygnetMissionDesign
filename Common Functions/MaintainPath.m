function folder = MaintainPath()
    % Determine where your m-file's folder is.    
    folder = fileparts(which(mfilename));
    splitfolder = strsplit(folder, '/');
    prunePoint = length(cell2mat(splitfolder(end)));
    
    parentFolder = folder(1:length(folder) - prunePoint - 1);
    
    % Add that folder plus all subfolders to the path.
    addpath(genpath(parentFolder));
    
%     current_path = strsplit(path, ":");
%     
%     for i = 1:length(current_path)
%         path_entry = cell2mat(current_path(i));
%         if contains(path_entry, '.git')
%             rmpath(path_entry)
%         end
%     end
end