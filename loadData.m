%Used to load MATLAB variables to bypass the 
%"if ~exist('loadedImages', 'var')" loop in AnatomyScript.

[loadFileName, loadFilePath] = uigetfile;
loadFileName = strcat(loadFilePath, loadFileName);
load(loadFileName);