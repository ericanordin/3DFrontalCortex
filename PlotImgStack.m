function PlotImgStack(imgCell, flipSlice, imageDim)

%%% BUILD SURFACE
% load 2D image array and construct 3D image

%Input:
%imgCell contains the four fields outlined in AnatomyScript
%flipSlice indicates whether the image is to be flipped to plot the opposite
%hemisphere
%imageDim = width (1) and height (2) of the images in mm. Assumed to be constant
%for every image.

isovalue = imgCell{5}; %Approximate measure of how much the image is smoothed

if flipSlice == 1
    img = flip(imgCell{1},2);
else
    img = imgCell{1};
end

img(img>0) = 1; % thresholds image, since otherwise GIF indexed (not binary)
%All pixels are either 1 or 0

zRange = imgCell{3}; %Slice locations
xRange = [0:(imageDim(1)/(size(img,1)-1)):imageDim(1)]; %Divvy width by pixels
yRange = [0:(imageDim(2)/(size(img,2)-1)):imageDim(2)]; %Divvy height by pixels

img = smooth3(img, 'box', [5 5 7]);
img = permute(img, [2 3 1]); % realign dimensions to ap/ml/dv
%x = slice y (467 pixels)
%y = image number (equal to number of slices)
%z = slice x (434 pixels)
img = flip(img,3); %Flips up/down

h_iso = patch(isosurface(zRange, yRange, xRange, img, isovalue));
%isovalue = threshold (marks inside vs outside object)
%Higher isovalue = more smoothing. The isovalue is custom chosen for each
%brain region to create a maximally uniform image (minimizing gaps and
%overlap).
%Isosurface creates vertices of shell
%Patch creates polygons surrounding shell via vertices

isonormals(imgCell{1}, h_iso); % effect only really noticeable on zoom
%Sets VertexNormals property of img to those calculated by h_iso, which
%determines the shape and orientation of vertex patch

h_cap = patch(isocaps(zRange, yRange, xRange, img, isovalue, 'below'));
%Fills cropped areas with surface


% %%% LIGHTING OPTIONS

 set(h_iso, 'FaceColor', imgCell{4}, 'EdgeColor', 'none');
 set(h_iso, 'SpecularColorReflectance', 0, 'SpecularExponent', 50, 'FaceAlpha', 0.2);
 set(h_cap, 'FaceColor', imgCell{4}, 'EdgeColor', 'none');
 set(h_cap, 'SpecularColorReflectance', 0, 'SpecularExponent', 50, 'FaceAlpha', 0.2);

 %set(gca, 'XTick', zRange(1):zRange(end));
%%% APPLY LABELS
%{
 set(gca, ...
     'XTick', 1:1:11, ...
     'YTick', 10:10:110, ...
     'ZTick', 0:10:100);
 set(gca, ...
     'XTickLabel', [4.7:-0.5:-0.3], ...
     'YTickLabel', [-5:1:5], ...
     'ZTickLabel', [-9:1:1]);
%}
%xlabel('AP');
%ylabel('ML');
%zlabel('DV');

