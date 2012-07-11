function fileList = getAllFiles(dirName,extension,excludeDir)
% fileList = getAllFiles(dirName,extension,excludeDir)
%   dirName : path to top folder
%   extension : picture extension, e.g. 'jpg'
%   ecludeDir : cell containing full paths of directories to ignore


  if nargin<3
      excludeDir = {};
  end
  if nargin<2
      extension = '*';
  end

  dirData = dir(dirName);      %# Get the data for the current directory
  dirFiles = dir([dirName '\*.' extension]); %# Get only files with extension
  dirIndex = [dirData.isdir];  %# Find the index for directories

  if sum(strcmp(excludeDir,dirName))==0
      fileList = {dirFiles.name}';  %'# Get a list of the files
      if ~isempty(fileList)
        fileList = cellfun(@(x) fullfile(dirName,x),...  %# Prepend path to files
                           fileList,'UniformOutput',false);
      end
  else
      fileList = {};
  end
  subDirs = {dirData(dirIndex).name};  %# Get a list of the subdirectories
  validIndex = ~ismember(subDirs,{'.','..'});  %# Find index of subdirectories
                                               %#   that are not '.' or '..'
  for iDir = find(validIndex)                  %# Loop over valid subdirectories
    nextDir = fullfile(dirName,subDirs{iDir});    %# Get the subdirectory path
    fileList = [fileList; getAllFiles(nextDir,extension,excludeDir)];  %# Recursively call getAllFiles
  end

end