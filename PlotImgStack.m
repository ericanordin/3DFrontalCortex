function [] = PlotImgStack(img, face_color); 

%%% BUILD SURFACE
% load img
img(img>0) = 1; % thresholds image, since otherwise GIF indexed
%All pixels are either 1 or 0

img = smooth3(img, 'box', [5 5 7]);
img = permute(img, [2 3 1]); % realign dimensions so that ap/ml/dv
img = flipdim(img,3);
% img = flipdim(img,2); % flip left/right
h_iso = patch(isosurface(img, 0.5));
isonormals(img, h_iso); % effect only really noticeable on zoom
%Sets VertexNormals property of img to those calculated by h_iso, which
%determines the shape and orientation of vertex patch

h_cap = patch(isocaps(img, 0.5, 'below'));


% %%% LIGHTING OPTIONS
% z_ratio = 1/ ((0.125/1) / (1/32));
% daspect([z_ratio, 1, 1]);
% face_color = [0.5, 0.6, 0.9];
 set(h_iso, 'FaceColor', face_color, 'EdgeColor', 'none');
 set(h_iso, 'SpecularColorReflectance', 0, 'SpecularExponent', 50, 'FaceAlpha', 0.4);
 set(h_cap, 'FaceColor', face_color, 'EdgeColor', 'none');
 set(h_cap, 'SpecularColorReflectance', 0, 'SpecularExponent', 50, 'FaceAlpha', 0.4);
% lighting phong;
 %   lightangle(190, 45);
%   lightangle(-20, 45);
%   lightangle(120, 20);
%   lightangle(80, 20);
%   lightangle(45, 0);
%view(160, 45);
%axis vis3d tight
%axis [0 12 0 100 0 100]);

%%% ADD EXTRA POINTS
% hold on;
% [num_ml, num_ap, num_dv] = size(img);
% num_pixels = [num_ap, num_ml, num_dv];
% % following limits are determined at time of cropping / extraction of image stack
% limits = [
%     -4, 3;
%     0, 6;
%     -8, -2;
% ];

% % random points
% pts = [
%     0.2, 2.3, -4
% ];
% num_pts = 30;
% rand_scale = 4;
% pts = rand_scale*randn(num_pts,3) + repmat(pts,num_pts,1);
%
% pts = [
%     0.2, 2.3, -4;
%     -2.8, -5.4, -6.6;
% ];
% % shift all points to one side
% pts(:,2) = abs(pts(:,2));
% 
% for i_coord = 1:3
%     pts(:,i_coord) = num_pixels(i_coord) * (pts(:,i_coord) - limits(i_coord,1)) / diff(limits(i_coord,:));
% end
% 
% % plot points
% h = plot3(pts(:,1), pts(:,2), pts(:,3), '.');
% marker_size = 50;
% set(h, 'MarkerSize', marker_size, 'Color', [1 0 0]);
% hold off;




%%% APPLY LABELS
% ticks = [0.25, 0.5, 0.75];
% i_row = 1;
% ap_tick_labels = ticks * diff(limits(i_row,:)) + limits(i_row,1);
% i_row = 2;
% ml_tick_labels = ticks * diff(limits(i_row,:)) + limits(i_row,1);
% i_row = 3;
% dv_tick_labels = ticks * diff(limits(i_row,:)) + limits(i_row,1);

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
% i_row = 1;
% ap_tick_labels = ticks * diff(limits(i_row,:)) + limits(i_row,1);
% i_row = 2;
% ml_tick_labels = ticks * diff(limits(i_row,:)) + limits(i_row,1);
% i_row = 3;
% dv_tick_labels = ticks * diff(limits(i_row,:)) + limits(i_row,1);
%  set(gca, ...
%      'XTick', round(num_ap*ticks), ...
%      'YTick', round(num_ml*ticks), ...
%      'ZTick', 1:11);
%  set(gca, ...
%      'XTickLabel', ap_tick_labels, ...
%      'YTickLabel', ml_tick_labels, ...
%      'ZTickLabel', dv_tick_labels);
