function [] = PlotCoords(AP, ML, DV, Marker) 

%This function has not been adapted for Paxinos & Watson. Conversion
%between AP/ML/DV measurements and location in the image will differ based
%on the atlas measurements.
%To establish the conversion, save image with grid and count pixels in
%photoshop to determine mm/pixel

%+/- are pixel offsets that will need to be determined
%Coefficient indicates difference in size between pixels and microns

x = -2 * (AP - 5.2); %Dependent on slice thickness (spacing between slices)
%Negative coefficient puts the AP measurement toward the front (further
%forward = more positive)

%Each stereotaxic unit can be thought of as a slice for ML and DV
y = 10 * ML + 60;
z = 10 * DV + 90;


hold on;
h = plot3(x, y, z, Marker); 
set(h, 'MarkerSize', 10);
hold off; 
