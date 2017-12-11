function [] = PlotCoords(AP, ML, DV, Marker) 

%Determine mm/pixel by saving image with grid and counting pixels in
%photoshop
%+/- are pixel offsets that will need to be determined
%Coefficient indicates difference in size between pixels and microns
%Each stereotaxis unit can be thought of as a slice for ML and DV
x = -2 * (AP - 5.2); %Dependent on slice thickness (spacing between slices)
%Negative coefficient puts the AP measurement toward the front (further
%forward = more positive)
y = 10 * ML + 60;
z = 10 * DV + 90;


hold on;
h = plot3(x, y, z, Marker); 
set(h, 'MarkerSize', 10);
hold off; 
