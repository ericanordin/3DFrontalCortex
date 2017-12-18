% % % Code to make a 3D reconstruction of the rat brain, based on images
% from Swanson.  Images from Swanson corresponding to brain sections are
% made into images corresponding to 11 sections in the AP plane (frontal
% sections) [4.7:-0.5:-0.3], note that the Swanson sections are slightly
% off (+/- 0.05) from regular sections.  
% Eyal Kimchi, Kumar Narayanan, Mark Laubach, 2006.  Based on Eyal's code,
% adapted by Kumar.


clf
%% Coordinates: ap/ml/dv

%%%%%%%%%%%%%%%%%%%%%%%%%%%%Coordinates of electrode arrays estimated from
%%%%%%%%%%%%%%%%%%%%%%%%%%%%histology

%{
Electrodes_Right = [
    1.8494    0.1175   -3.4000
    1.8787    0.3387   -3.4000
    1.8348    0.6429   -3.4000
    1.6740    0.8779   -3.4000
    1.6447    0.2419   -3.4000
    1.7178    0.4078   -3.4000
    1.6594    0.6290   -3.4000
    1.5278    0.7811   -3.4000
    1.4693    0.2281   -3.4000
    1.2500    0.2281   -3.4000
    1.4108    0.5599   -3.4000
    1.3085    0.7120   -3.4000
    1.0307    0.1728   -3.4000
    1.0453    0.3802   -3.4000
    1.0453    0.6152   -3.4000
    0.9868    0.7396   -3.4000
];

Electrodes_Left = [
    3.3465   -0.8364   -3.7000
    3.3904   -0.6290   -3.7000
    3.4927   -0.4217   -3.7000
    3.4927   -0.1866   -3.7000
    3.1418   -0.8364   -3.7000
    3.2295   -0.5737   -3.7000
    3.2295   -0.4493   -3.7000
    3.2734   -0.1866   -3.7000
    3.2003   -0.1452   -3.7000
    3.1418   -0.0484   -3.7000
    3.0687   -0.0760   -3.7000
    3.1126   -0.1866   -3.7000
    2.9518   -0.8502   -3.7000
    2.9371   -0.5323   -3.7000
    2.8933   -0.2558   -3.7000
    2.9518   -0.0760   -3.7000
];
%}

if ~exist('loadedImages', 'var')
%Cells hold data on brain regions
%{1} = Matrix of pixel data
%{2} = Figure range for images of region
%{3} = Bregma locations of slices corresponding to images in {2}
%{4} = Region colour
PLcell = {1,4};
Skincell = {1,4};
ILcell = {1,4};
CG1cell = {1,4};

PLcell{4} = [0.5, 0.5, 0.8]; %purple
Skincell{4} = [0.5, 0.5, 0.5]; %gray
ILcell{4} = [0.8 0.5 0.5]; %pink
CG1cell{4} = [0.5 0.8 0.5]; %green

masterImageDir = 'Paxinos & Watson\';
yShift = xlsread(strcat(masterImageDir, 'SliceData.xlsx'), 'K2:K61'); 
%Indicates where the scale on the image starts so that slices are lined up
%properly
nextSpace = xlsread(strcat(masterImageDir, 'SliceData.xlsx'), 'C2:C61');

[PLslices, PLnum] = LoadImgStack(strcat(masterImageDir, 'PL\'), yShift);
PLcell{1} = PLslices;
PLcell{2} = PLnum;
PLcell{3} = nextSpace(PLnum);

%PlotImgStack(PLslices, PLcolor);
[SkinSlices, SkinNum] = LoadImgStack(strcat(masterImageDir, 'Cortex\'), yShift);
Skincell{1} = SkinSlices;
Skincell{2} = SkinNum;
Skincell{3} = nextSpace(SkinNum);

[ILslices, ILnum] = LoadImgStack(strcat(masterImageDir, 'IL\'), yShift);
ILcell{1} = ILslices;
ILcell{2} = ILnum;
ILcell{3} = nextSpace(ILnum);

[CG1slices, CG1num] = LoadImgStack(strcat(masterImageDir, 'CG1\'), yShift);
CG1cell{1} = CG1slices;
CG1cell{2} = CG1num;
CG1cell{3} = nextSpace(CG1num);

loadedImages = 1;
end

PlotImgStack(PLcell, 0);
PlotImgStack(PLcell, 1);

PlotImgStack(Skincell, 0);
PlotImgStack(Skincell, 1);

PlotImgStack(ILcell, 0);
PlotImgStack(ILcell, 1);

PlotImgStack(CG1cell, 0);
PlotImgStack(CG1cell, 1);




 lighting phong;
    lightangle(190, 45);
   lightangle(-20, 45);
  lightangle(120, 20);
  lightangle(80, 20);
  lightangle(45, 0);
view(-90, 0);
 axis vis3d tight %Reduce to size of image and freeze aspect ratio
 %Matlab's default setting seems to allow the tick marks to set the
 %spacing, giving the aspect ratio (see PlotImgStack)
 
 %{
PlotCoords(Electrodes_Right(:, 1),Electrodes_Right(:, 2), Electrodes_Right(:, 3)', 'k.'); 
PlotCoords(Electrodes_Left(:, 1), Electrodes_Left(:, 2), Electrodes_Left(:, 3)', 'k.'); 
%}


set(gcf, 'Color', [1 1 1])
 set(gca, 'xtick', [], 'ytick', [], 'ztick', []); 
 axis off


