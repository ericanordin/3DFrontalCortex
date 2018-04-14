% % % Code to build a 3D reconstruction of the rat brain from 2D brain
% slices. This version uses images from Paxinos & Watson MRI Atlas 2015, but can
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
    %if-loop is skipped if images have already been loaded. Assumes that
    %the necessary variables are stored in the Workspace.
    
    %If variables are stored in a .mat file for later use, the following
    %variables must be included for this if-loop to be skipped
    %successfully:
    %Cells for all brain regions
    %loadedImages
    %xyImageSize
    
    imageFolders = {'Cortex/', 'A24a/', 'A24b/', 'A32D', 'A32V'};
    numRegions = length(imageFolders);
    
    %Cells hold data on brain regions
    %{1} = Matrix of pixel data. X/Y dimensions represent 2D image.
    %Each slice is stored in a separate layer in the Z dimension.
    %{2} = Figure numbers for brain region. Eg [3 4 5 6] if the region
    %starts on figure 3 and ends at figure 6 of the atlas.
    %{3} = Locations of slices corresponding to figures in {2} to
    %ensure regions are properly aligned and spaced. Measured in mm
    %relative to Bregma.
    %{4} = Region colour (for easy visual representation)
    %{5} = Approximated ideal isovalues to produce accurate smoothing. As
    %this value increases, adjacent brain regions overlap more in the 3D
    %reconstruction, but gaps are smaller.
    
    dataSets = 5; %The number of cells for each brain region
    masterData = cell(1,numRegions);
    
    
    for region = 1:numRegions
        regionData = {1,dataSets};
        
        switch imageFolders{region}
            case 'Cortex/'
                regionData{4} = [0.5, 0.5, 0.5]; %gray
                regionData{5} = 0.5;
            case 'A24a/'
                regionData{4} = [0.2, 0.2, 0.9]; %purple
                regionData{5} = 0.6;
            case 'A24b/'
                regionData{4} = [0.9, 0.9, 0.1]; %yellow
                regionData{5} = 0.5;
            case 'A32D/'
                regionData{4} = [0.8 0.5 0.5]; %pink
                regionData{5} = 0.7;
            case 'A32V/'
                regionData{4} = [0.5 0.8 0.5]; %green
                regionData{5} = 0.7;
            otherwise
                disp('Region ', imageFolders{region}, ' not assigned properties.');
                regionData{4} = [1 1 1];
                regionData{5} = 0.6;
        end
        
        masterData{region} = regionData;
    end
    
    
    
    
    masterImageDir = 'P&W MRI\';
    %Where all of the images are stored. Different brain regions are stored
    %in different subfolders.
    
    dataSheet = 'MRI_SliceData.xlsx';
    %The program draws key information regarding image details from an
    %excel spreadsheet. For a new atlas, a similar spreadsheet will have to
    %be created or a different method of importing key data must be
    %introduced.
    
    yShift = xlsread(strcat(masterImageDir, dataSheet), 'D2:D97');
    %P&W images are not all lined up vertically; some figures are shifted
    %up or down by 1 mm. This variable tracks the starting point for each
    %image so that the 0 point is the same for all when the 3D image is
    %constructed.
    
    bregma = xlsread(strcat(masterImageDir, dataSheet), 'B2:B97');
    %Bregma coordinates for slices
    
    %The scaling is the same for all P&W images. If an atlas is used in
    %which the scale changes between images, a larger array similar to
    %yshift or bregma must be created to store it and the 2D images scaled
    %accordingly.
    xyImageSize = zeros(1,2);
    %Image width:
    xyImageSize(1,1) = xlsread(strcat(masterImageDir, dataSheet), 'G4:G4');
    %Image height:
    xyImageSize(1,2) = xlsread(strcat(masterImageDir, dataSheet), 'F4:F4');
    
    pivotPixel = -1; %The left-most black pixel, used to determine how much
    %the white space must be extended to get properly mirrored hemispheres
    
    mainDir = pwd;
    
    try
        %Load images into Matlab
        
        [A32D_slices, A32D_num, pivotPixel] = LoadImgStack(strcat(masterImageDir, 'A32D\'), yShift, xyImageSize(1,2), pivotPixel);
        A32D_cell{1} = A32D_slices;
        A32D_cell{2} = A32D_num;
        A32D_cell = SetBregma(A32D_cell, bregma);
        
        [A24a_slices, A24a_num, pivotPixel] = LoadImgStack(strcat(masterImageDir, 'A24a\'), yShift, xyImageSize(1,2), pivotPixel);
        A24a_cell{1} = A24a_slices;
        A24a_cell{2} = A24a_num;
        A24a_cell = SetBregma(A24a_cell, bregma);
        
        [A24b_slices, A24b_num, pivotPixel] = LoadImgStack(strcat(masterImageDir, 'A24b\'), yShift, xyImageSize(1,2), pivotPixel);
        A24b_cell{1} = A24b_slices;
        A24b_cell{2} = A24b_num;
        A24b_cell = SetBregma(A24b_cell, bregma);
        
        [SkinSlices, SkinNum, pivotPixel] = LoadImgStack(strcat(masterImageDir, 'Cortex\'), yShift, xyImageSize(1,2), pivotPixel);
        Skin_cell{1} = SkinSlices;
        Skin_cell{2} = SkinNum;
        Skin_cell = SetBregma(Skin_cell, bregma);
        
        [A32V_slices, A32V_num, pivotPixel] = LoadImgStack(strcat(masterImageDir, 'A32V\'), yShift, xyImageSize(1,2), pivotPixel);
        A32V_cell{1} = A32V_slices;
        A32V_cell{2} = A32V_num;
        A32V_cell = SetBregma(A32V_cell, bregma);
        
    catch
        cd(mainDir);
        %Returns to primary directory if error occurs in LoadImgStack
        
        return;
    end
    
    pixelWidth = size(A24a_cell{1}, 2); %Could use any cell; all images are equally sized
    
    extendLength = pixelWidth - pivotPixel*2 + 1; %Number of pixels of
    %whitespace to extend images by to make the left-most black
    %pixel just right of the middle.
    extendLength = extendLength+3; %Smoothing causes regions to bite into
    %each other across the middle point. The isovalues of the brain regions
    %determine how many extra pixels should be added to extendLength to
    %minimize overlap.
    
    A32D_cell{1} = AdjustImgStack(A32D_cell{1}, extendLength);
    A24a_cell{1} = AdjustImgStack(A24a_cell{1}, extendLength);
    A24b_cell{1} = AdjustImgStack(A24b_cell{1}, extendLength);
    Skin_cell{1} = AdjustImgStack(Skin_cell{1}, extendLength);
    A32V_cell{1} = AdjustImgStack(A32V_cell{1}, extendLength);
    
    loadedImages = 1; %Indicates that image loading has been completed so
    %the if-loop does not have to be repeated when plotting repeatedly.
end

%Plot hemisphere and its mirror image for all brain regions.
%P&W images store right hemisphere data and assume left hemisphere is
%identical.
%Images containing both hemispheres only need to be plotted once.

PlotImgStack(A32D_cell, 0, xyImageSize);
PlotImgStack(A32D_cell, 1, xyImageSize);

PlotImgStack(A24a_cell, 0, xyImageSize);
PlotImgStack(A24a_cell, 1, xyImageSize);

PlotImgStack(A24b_cell, 0, xyImageSize);
PlotImgStack(A24b_cell, 1, xyImageSize);

PlotImgStack(Skin_cell, 0, xyImageSize);
PlotImgStack(Skin_cell, 1, xyImageSize);

PlotImgStack(A32V_cell, 0, xyImageSize);
PlotImgStack(A32V_cell, 1, xyImageSize);


%%% APPLY LABELS (for development purposes; labels and axes are removed at
%%% the end of the script)
%{
 set(gca, ...
     'XTick', 1:1:11, ...
     'YTick', 10:10:110, ...
     'ZTick', 0:10:100);
 set(gca, ...
     'XTickLabel', [4.7:-0.5:-0.3], ...
     'YTickLabel', [-5:1:5], ...
     'ZTickLabel', [-9:1:1]);

xlabel('AP');
ylabel('ML');
zlabel('DV');
%}

%3D image lighting
lighting phong;
lightangle(190, 45);
lightangle(-20, 45);
lightangle(120, 20);
lightangle(80, 20);
lightangle(45, 0);

axis vis3d tight equal %Reduce to size of image and freeze aspect ratio so
%that all axes have equal units.

view(30, 30);

%Plot electrode coordinates
%{
PlotCoords(Electrodes_Right(:, 1),Electrodes_Right(:, 2), Electrodes_Right(:, 3)', 'k.');
PlotCoords(Electrodes_Left(:, 1), Electrodes_Left(:, 2), Electrodes_Left(:, 3)', 'k.');
%}


set(gcf, 'Color', [1 1 1]); %White background
%Remove axis markings
set(gca, 'xtick', [], 'ytick', [], 'ztick', []);
axis off
%Image shrinks markedly when axes are included


