function [img, allNum, pivotPixel] = LoadImgStack(regionDir, shiftArray, imageHeight, pivotPixel) 

%%% EXTRACT AND SAVE IMAGE STACK

%Input
%regionDir: the subfolder containing the images for the brain region. 
%Relative to the main folder containing AnatomyScript and associated
%functions.
%shiftArray: expresses adjustments that need to be made to line the images
%up properly (see yShift in AnatomyScript)
%imageHeight: in mm. Consistent across Paxinos & Watson images. Used for
%shifting images up/down for equal start points. 

%Output
%img: matrix of slice data
%allNum: numbering of slices corresponding to img

try 
    
dec = 9; %Decimation factor: taking every 9th pixel

cwd = pwd; 
cd(regionDir);
files = dir('*.tif'); %Format of 2D images. All matching images in the 
%subfolder will be included.
num_files = length(files);

fprintf('\n%s: ', char(regionDir));

for i_file = 1:num_files
   fprintf(' %d', i_file); 
   filename = files(i_file).name;
   [temp_img, ~] = imread(filename);
   
   
   grayImg = rgb2gray(temp_img); %Reduces colour representation from 3 
   %values to 1 value
   colormap('gray'); %Black/white displayed as yellow/blue otherwise
   
   %Extract slice number from file name
   [~, nameNoExt, ~] = fileparts(filename);
   sliceNum = str2double(nameNoExt(end-2:end)); 
   %Assumes 3-digit designation at end of file
   
   yShift = shiftArray(sliceNum); 
   
   %P&W images are horizontally consistent and therefore only adjusted
   %vertically; an atlas that is not will have to implement a variation of
   %this algorithm for left/right shifting.
   if yShift ~= 0 %Image must be shifted up/down
       pixelUnitRatio = round(size(grayImg, 1)/imageHeight); %y-axis
       
       %Appropriate number of pixels to shift corresponding to yStart
       pixelShift = abs(round(pixelUnitRatio*yShift));
       
       tempImg = grayImg; %Matches size
       tempImg(:,:) = mode(mode(grayImg)); %Sets all of tempImg to background color for grayImg
       
       %Shifting assumes area being covered by shift is blank background so
       %data is not being lost. 
       if yShift > 0 %Shift image down
            tempImg(pixelShift+1:end, :) = grayImg(1:end-pixelShift, :);
       else %Shift image up
           tempImg(1:end-pixelShift, :) = grayImg(pixelShift+1:end, :);
       end

       grayImg = tempImg;
   end
   
   dec_img = grayImg(1:dec:end, 1:dec:end); %Decimate
   
   if i_file == 1 %Pre-allocates matrix size once image size has been established
       fullMatrixSize = zeros(size(dec_img,1), size(dec_img,2), num_files);
       fullMatrixSize(:,:,1) = dec_img;
       img = fullMatrixSize;
       
       allNum = zeros(size(img,3), 1);
   else
       img(:,:,i_file) = dec_img;
   end
   
   allNum(i_file) = sliceNum;
   
   
   
end
img(img>0) = 1; % Thresholds image, since otherwise TIF is 
%indexed (not binary). All pixels are either 1 or 0.

%Find furthest left black pixel
[~, columns] = find(img == 0);
%'columns' refer to those which contain at least one black pixel
minCol = min(columns); %Furthest left column containing black in the stack 
%of images for the brain region

if pivotPixel == -1 %Left-most point not yet set
    pivotPixel = minCol;
else
    if minCol < pivotPixel
        pivotPixel = minCol;
    end
end


cd(cwd); %Returns to master directory

catch ME
    fprintf(2, 'Error in LoadImgStack \n%s');
    fprintf(2, ME.message); 
    for k = 1:length(ME.stack)
        ME.stack(k) %Displays file, name, and line where error occurred
    end
    rethrow(ME);
end

