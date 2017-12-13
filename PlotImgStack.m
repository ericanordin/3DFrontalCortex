function PlotImgStack(img, face_color)

%%% BUILD SURFACE
% load 2D img array and construct 3D image

img(img>0) = 1; % thresholds image, since otherwise GIF indexed (not binary)
%All pixels are either 1 or 0

img = smooth3(img, 'box', [5 5 7]);
img = permute(img, [2 3 1]); % realign dimensions so that ap/ml/dv
img = flipdim(img,3); %Flips up/down
% img = flipdim(img,2); % flip left/right
h_iso = patch(isosurface(img, 0.5));
%isovalue (0.5) = threshold (marks inside vs outside object)
%Isosurface creates vertices of shell
%Patch creates polygons surrounding shell via vertices

isonormals(img, h_iso); % effect only really noticeable on zoom
%Sets VertexNormals property of img to those calculated by h_iso, which
%determines the shape and orientation of vertex patch

h_cap = patch(isocaps(img, 0.5, 'below'));
%Fills cropped areas with surface


% %%% LIGHTING OPTIONS

 set(h_iso, 'FaceColor', face_color, 'EdgeColor', 'none');
 set(h_iso, 'SpecularColorReflectance', 0, 'SpecularExponent', 50, 'FaceAlpha', 0.4);
 set(h_cap, 'FaceColor', face_color, 'EdgeColor', 'none');
 set(h_cap, 'SpecularColorReflectance', 0, 'SpecularExponent', 50, 'FaceAlpha', 0.4);

%%% APPLY LABELS

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

