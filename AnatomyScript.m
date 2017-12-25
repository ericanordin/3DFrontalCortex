% % % Code to build a 3D reconstruction of the rat brain from 2D brain 
% slices. This version uses images from Paxinos & Watson 6th ed, but can
% be modified for a different atlas.
% Erica Nordin, 2017.
% Based on code by Eyal Kimchi and Kumar Narayanan.


clf

%% Electrode Coordinates should be in ap/ml/dv form when loaded
%{
Eg:

Electrodes = [
    1.8494    0.1175   -3.4000
    1.8787    0.3387   -3.4000
    1.8348    0.6429   -3.4000
];
%}

if ~exist('loadedImages', 'var')
    %if-loop is skipped if it has already been completed once. Assumes that
    %the necessary variables are stored in the Workspace.
    
    %If variables are stored in a .mat file for later use, the following
    %variables must be included for this if-loop to be skipped
    %successfully:
    %Cells for all brain regions
    %loadedImages
    %xyImageSize
    
    %Cells hold data on brain regions
    %{1} = Matrix of pixel data. X/Y dimensions represent 2D image. 
    %Each slice is stored in a separate layer in the Z dimension.
    %{2} = Figure numbers for brain region. Eg [3 4 5 6] if the region 
    %starts on figure 3 and ends at figure 6 of the atlas.
    %{3} = Bregma locations of slices corresponding to figures in {2} to 
    %ensure regions are properly aligned and spaced.
    %{4} = Region colour (for easy visual representation)
    %{5} = Amount of smoothing. As this value increases, adjacent brain 
    %regions overlap more in the 3D reconstruction, but gaps are smaller.
    
    PLcell = {1,5};
    Skincell = {1,5};
    ILcell = {1,5};
    CG1cell = {1,5};
    
    PLcell{4} = [0.5, 0.5, 0.8]; %purple
    Skincell{4} = [0.5, 0.5, 0.5]; %gray
    ILcell{4} = [0.8 0.5 0.5]; %pink
    CG1cell{4} = [0.5 0.8 0.5]; %green
    
    %Approximated ideal isovalues for producing an accurate 3D
    %representation minimizing smoothing artefacts. 
    PLcell{5} = 0.58;
    Skincell{5} = 0.5;
    ILcell{5} = 0.6;
    CG1cell{5} = 0.48;
    
    masterImageDir = 'Paxinos & Watson\';
    %Where all of the images are stored. Different brain regions are stored
    %in different subfolders.
    
    %The program draws key information regarding image details from an
    %excel spreadsheet. For a new atlas, a similar spreadsheet will have to
    %be created or a different method of importing key data must be
    %introduced.
    
    yShift = xlsread(strcat(masterImageDir, 'SliceData.xlsx'), 'K2:K61');
    %P&W images are not all lined up vertically; some figures are shifted
    %up or down by 1 mm. This variable tracks the starting point for each
    %image so that the 0 point is the same for all when the 3D image is
    %constructed.
    
    bregma = xlsread(strcat(masterImageDir, 'SliceData.xlsx'), 'C2:C61');
    %Bregma coordinates for slices
    
    %The scaling is the same for all P&W images. If an atlas is used in
    %which the scale changes between images, a larger array similar to 
    %yshift or bregma must be created to store it and the 2D images scaled
    %accordingly.
    xyImageSize = zeros(1,2);
    %Image width:
    xyImageSize(1,1) = xlsread(strcat(masterImageDir, 'SliceData.xlsx'), 'F2:F2');
    %Image height:
    xyImageSize(1,2) = xlsread(strcat(masterImageDir, 'SliceData.xlsx'), 'J2:J2');
    
    %Load images into Matlab
    
    [ILslices, ILnum] = LoadImgStack(strcat(masterImageDir, 'IL\'), yShift);
    ILcell{1} = ILslices;
    ILcell{2} = ILnum;
    ILcell{3} = bregma(ILnum);
    
    [PLslices, PLnum] = LoadImgStack(strcat(masterImageDir, 'PL\'), yShift);
    PLcell{1} = PLslices;
    PLcell{2} = PLnum;
    PLcell{3} = bregma(PLnum);
    
    [SkinSlices, SkinNum] = LoadImgStack(strcat(masterImageDir, 'Cortex\'), yShift);
    Skincell{1} = SkinSlices;
    Skincell{2} = SkinNum;
    Skincell{3} = bregma(SkinNum);
    
    [CG1slices, CG1num] = LoadImgStack(strcat(masterImageDir, 'CG1\'), yShift);
    CG1cell{1} = CG1slices;
    CG1cell{2} = CG1num;
    CG1cell{3} = bregma(CG1num);
    
    loadedImages = 1; %Indicates that image loading has been completed so 
    %this step does not have to be repeated when plotting repeatedly.
end

%Plot hemisphere and its mirror image for all brain regions. 
%P&W images store right hemisphere data and assume left hemisphere is
%identical.
%Images containing both hemispheres only need to be plotted once.

PlotImgStack(ILcell, 0, xyImageSize);
PlotImgStack(ILcell, 1, xyImageSize);

PlotImgStack(PLcell, 0, xyImageSize);
PlotImgStack(PLcell, 1, xyImageSize);

PlotImgStack(Skincell, 0, xyImageSize);
PlotImgStack(Skincell, 1, xyImageSize);

PlotImgStack(CG1cell, 0, xyImageSize);
PlotImgStack(CG1cell, 1, xyImageSize);


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

lighting phong;
lightangle(190, 45);
lightangle(-20, 45);
lightangle(120, 20);
lightangle(80, 20);
lightangle(45, 0);
%view(30, 30);
axis vis3d tight equal %Reduce to size of image and freeze aspect ratio
%Matlab's default setting seems to allow the tick marks to set the
%spacing, giving the aspect ratio (see PlotImgStack)

%{
PlotCoords(Electrodes_Right(:, 1),Electrodes_Right(:, 2), Electrodes_Right(:, 3)', 'k.');
PlotCoords(Electrodes_Left(:, 1), Electrodes_Left(:, 2), Electrodes_Left(:, 3)', 'k.');
%}


set(gcf, 'Color', [1 1 1])
set(gca, 'xtick', [], 'ytick', [], 'ztick', []);
axis off


