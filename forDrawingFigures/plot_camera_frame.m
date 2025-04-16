function [h] = plot_camera_frame(R_gc, p_gc, image, camScale, camBodyColor)
% Project:    Astrobee's mapping and localization system
% Function:  plot_camera_frame
%
% Description:
%   draw current camera frame in the current figure
%
% Example:
%   OUTPUT:
%   h: figure handler
%
%
%   INPUT:
%   R_gc: rotation matrix of camera frame (T_gc(1:3,1:3))
%   p_gc: position vector of camera frame (T_gc(1:3,4))
%   image: image captured at the current camera frame (gray or RGB)
%   camScale: scale of camera body and frame
%   camBodyColor: color of camera body (NOT FRAME - FRAME is RGB (XYZ))
%
%
%
% NOTE:
%   Copyright 2016 Intelligent Robotics Group, NASA ARC
%
% Author: Pyojin Kim
% Email: pjinkim1215@gmail.com
% Website:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% log:
% 2016-07-06: ing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%


% option parameters
rows = size(image,1);
cols = size(image,2);


% define the camera body and frame
camBody = zeros(3,4);
camBody(:,1) = camScale * [(cols/2);-(rows/2);(rows-50)] / 1000;
camBody(:,2) = camScale * [-(cols/2);-(rows/2);(rows-50)] / 1000;
camBody(:,3) = camScale * [-(cols/2);(rows/2);(rows-50)] / 1000;
camBody(:,4) = camScale * [(cols/2);(rows/2);(rows-50)] / 1000;

camFrame = camScale * ((rows/2) / 1000) * eye(3);


% rotate the camera body and frame from {C} to {G}
camBody = R_gc * camBody;
camFrame  = R_gc * camFrame;


% translate the camera body and frame
camBody = camBody + [p_gc(1:3) p_gc(1:3) p_gc(1:3) p_gc(1:3)];
camFrame = camFrame + [p_gc(1:3) p_gc(1:3) p_gc(1:3)];



% draw the camera body
h1 = line([camBody(1,1) p_gc(1)],[camBody(2,1) p_gc(2)],[camBody(3,1) p_gc(3)],'Color', camBodyColor, 'LineWidth', 2);
h2 = line([camBody(1,2) p_gc(1)],[camBody(2,2) p_gc(2)],[camBody(3,2) p_gc(3)],'Color', camBodyColor, 'LineWidth', 2);
h3 = line([camBody(1,3) p_gc(1)],[camBody(2,3) p_gc(2)],[camBody(3,3) p_gc(3)],'Color', camBodyColor, 'LineWidth', 2);
h4 = line([camBody(1,4) p_gc(1)],[camBody(2,4) p_gc(2)],[camBody(3,4) p_gc(3)],'Color', camBodyColor, 'LineWidth', 2);

h5 = line([camBody(1,1) camBody(1,2)],[camBody(2,1) camBody(2,2)],[camBody(3,1) camBody(3,2)],'Color', camBodyColor, 'LineWidth', 2);
h6 = line([camBody(1,2) camBody(1,3)],[camBody(2,2) camBody(2,3)],[camBody(3,2) camBody(3,3)],'Color', camBodyColor, 'LineWidth', 2);
h7 = line([camBody(1,3) camBody(1,4)],[camBody(2,3) camBody(2,4)],[camBody(3,3) camBody(3,4)],'Color', camBodyColor, 'LineWidth', 2);
h8 = line([camBody(1,4) camBody(1,1)],[camBody(2,4) camBody(2,1)],[camBody(3,4) camBody(3,1)],'Color', camBodyColor, 'LineWidth', 2);

% draw the image at the camera body
x_image_corners = [camBody(1,2),camBody(1,1);
    camBody(1,3),camBody(1,4)];
y_image_corners = [camBody(2,2),camBody(2,1);
    camBody(2,3),camBody(2,4)];
z_image_corners = [camBody(3,2),camBody(3,1);
    camBody(3,3),camBody(3,4)];
h9 = surf(x_image_corners,y_image_corners,z_image_corners,'CData',image,'FaceColor','texturemap');


% draw the camera frame
h10 = line([camFrame(1,1) p_gc(1)],[camFrame(2,1) p_gc(2)],[camFrame(3,1) p_gc(3)],'Color','r','LineWidth',2);
h11 = line([camFrame(1,2) p_gc(1)],[camFrame(2,2) p_gc(2)],[camFrame(3,2) p_gc(3)],'Color','g','LineWidth',2);
h12 = line([camFrame(1,3) p_gc(1)],[camFrame(2,3) p_gc(2)],[camFrame(3,3) p_gc(3)],'Color','b','LineWidth',2);


% figure handler
h = cell(1,12);
h{1} = h1;
h{2} = h2;
h{3} = h3;
h{4} = h4;
h{5} = h5;
h{6} = h6;
h{7} = h7;
h{8} = h8;
h{9} = h9;
h{10} = h10;
h{11} = h11;
h{12} = h12;


end