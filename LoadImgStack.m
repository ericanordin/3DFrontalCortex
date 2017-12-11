function [img] = LoadImgStack(dir_stack); 

%%% EXTRACT AND SAVE IMAGE STACK
% Preprocessing parameters
% center = 512;
% width = 500; % equals 6mm from middle (32 ppmm)
% top = 200; % 6mm again
% height = 500;
%  crop_rows = [top:top+height];
%  crop_cols = [center:center+width];
dec = 9; %Decimation factor: taking every 9th pixel

  %crop_rows = [1:830];
  %crop_cols = [1:1090];

cwd = pwd; 
cd(dir_stack);
%files = dir('*.gif');
files = dir('*.tif');
num_files = length(files);
%img = zeros(1,1,num_files);

fprintf('\n%s: ', char(dir_stack));

for i_file = 1:num_files
   fprintf(' %d', i_file); 
   filename = files(i_file).name;
   [temp_img, temp_map] = imread(filename);
   %image(temp_img);
   grayImg = rgb2gray(temp_img);
   %grayColormap = rgb2gray(temp_map);
   %image(grayImg);
   colormap('gray');
   
   %crop_img = grayImg(crop_rows, crop_cols);
   %dec_img = crop_img(1:dec:end, 1:dec:end);
   
   dec_img = grayImg(1:dec:end, 1:dec:end);
   
   %image(dec_img);
%    subplot(3, 1, 1);
%    imagesc(temp_img);
%    axis image;
%    subplot(3, 1, 2);
%    imagesc(crop_img);
%    axis image;
%    subplot(3, 1, 3);
%    imagesc(dec_img);
%    axis image;
   img(:,:,i_file) = dec_img;
   if i_file == 1
       fullMatrixSize = zeros(size(img,1), size(img,2), num_files);
       fullMatrixSize(:,:,1) = img(:,:,1);
       img = fullMatrixSize;
   end
   
   %image(img(:,:,i_file));
end
cd(cwd);

