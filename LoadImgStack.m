function [img, allNum] = LoadImgStack(regionDir, shiftArray, imageHeight) 

%%% EXTRACT AND SAVE IMAGE STACK

%Input
%regionDir: the subfolder containing the images for the brain region. 
%Relative to the main folder containing AnatomyScript and associated
%functions.
%shiftArray: expresses adjustments that need to be made to line the images
%up properly (see yShift in AnatomyScript)
%imageHeight: in mm. Consistent across Paxinos & Watson images.

%Output
%img: matrix of slice data
%allNum: numbering of slices corresponding to img

try 
    
dec = 9; %Decimation factor: taking every 9th pixel
x=y;

cwd = pwd; 
cd(regionDir);
files = dir('*.tif');
num_files = length(files);

fprintf('\n%s: ', char(regionDir));

for i_file = 1:num_files
   fprintf(' %d', i_file); 
   filename = files(i_file).name;
   [temp_img, ~] = imread(filename);
   
   
   grayImg = rgb2gray(temp_img);
   colormap('gray'); %Black/white displayed as yellow/blue otherwise
   
   
   [~, nameNoExt, ~] = fileparts(filename);
   sliceNum = str2double(nameNoExt(end-2:end)); 
   %Assumes 3-digit designation at end of file
   
   yStart = shiftArray(sliceNum);
   if yStart ~= 0
       pixelUnitRatio = round(size(grayImg, 1)/imageHeight); %y-axis
       
       %Shift by appropriate number of pixels corresponding to yStart
       pixelShift = abs(round(pixelUnitRatio*yStart));
       
       tempImg = grayImg; %Matches size
       tempImg(:,:) = mode(mode(grayImg)); %Sets all of tempImg to background color for grayImg
       
       if yStart > 0 %Shift image down
            tempImg(pixelShift+1:end, :) = grayImg(1:end-pixelShift, :);
       else %Shift image up
           tempImg(1:end-pixelShift, :) = grayImg(pixelShift+1:end, :);
       end

       grayImg = tempImg;
   end
   
   dec_img = grayImg(1:dec:end, 1:dec:end);
   
   if i_file == 1 %Pre-allocates matrix size once image size has been established
       fullMatrixSize = zeros(size(dec_img,1), size(dec_img,2), num_files);
       fullMatrixSize(:,:,1) = dec_img;
       img = fullMatrixSize;
       
       allNum = zeros(size(img,3), 1);
       allNum(1) = sliceNum;
   else
       img(:,:,i_file) = dec_img;
       allNum(i_file) = sliceNum;
   end
   
end
cd(cwd);

catch ME
    fprintf(2, 'Error in LoadImgStack \n%s');
    fprintf(2, ME.message); 
    for k = 1:length(ME.stack)
        ME.stack(k) %Displays file, name, and line where error occurred
    end
    rethrow(ME);
end

