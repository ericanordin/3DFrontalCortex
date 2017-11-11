function [] = PlotCoords(AP, ML, DV, Marker); 


x = -2 * (AP - 5.2);
y = 10 * ML + 60;
z = 10 * DV + 90;


hold on;
h = plot3(x, y, z, Marker); 
set(h, 'MarkerSize', 10);
hold off; 
