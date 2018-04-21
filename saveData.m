%Once AnatomyScript is run, MATLAB variables can be saved to a .mat file
%to bypass the "if ~exist('loadedImages', 'var')" loop.
%Note that this script does not prevent overwrite for files created on the
%same day.
dateAppend = date;
saveFileName = strcat('AnatomyScriptData_', dateAppend);
saveFileName = strcat(masterImageDir, saveFileName);
saveFileName = strcat(saveFileName, '.mat');
save(saveFileName, 'loadedImages', 'xyImageSize', 'masterData', 'numRegions');


