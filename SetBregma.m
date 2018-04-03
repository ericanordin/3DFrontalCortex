function [regionCell] = SetBregma(regionCell, bregma)
%SetBregma assigns anterior/posterior coordinates to the region and extends
%boundaries to fill gaps between coronal slices.
%   MATLAB's isosurface function treats the last slice as the back border
%   of the region, leaving a gap in the border between
%   anterior/posterior regions. This function extends the front and back of
%   each region to the middle of the gap to fill it.

%Input:
%regionCell contains data for the region. See AnatomyScript for details.
%bregma contains the a/p measurements for each coronal slice in the atlas.

%Output:
%regionCell - same as input, but with bregma information included

bregmaForRegion = bregma(regionCell{2}); %Retrieve bregma coordinates for
%coronal slices being used for reconstruction

%Adjust front
frontSlice = regionCell{2}(1);
if frontSlice ~= 1
    sliceWidth = bregma(frontSlice) - bregma(frontSlice-1);
    bregmaForRegion(1) = bregmaForRegion(1) - sliceWidth/2;
end

%Adjust back
backSlice = regionCell{2}(end);
if backSlice ~= length(bregma)
    sliceWidth = bregma(backSlice+1) - bregma(backSlice);
    bregmaForRegion(end) = bregmaForRegion(end) + sliceWidth/2;
end

regionCell{3} = bregmaForRegion; 
%Set bregma coordinates for use in 3D reconstruction
end

