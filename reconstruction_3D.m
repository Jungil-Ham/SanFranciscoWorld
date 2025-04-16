clc;
close all;
clear variables; %clear classes;
dbstop if error;

addpath('forDrawingFigures');

datasetPath = './oryong2';
            
imInit      = 1;       % first image index, (1-based index)
M           = 200;  % number of images


% load ICL NUIM dataset data
rawICLNUIMdataset = rawSTSCdataset_load(datasetPath);
process_data(datasetPath);

% camera calibration parameters
[ICLNUIMdataset] = getSyncTUMRGBDdataset(rawICLNUIMdataset, imInit, M);
optsLPIC = load_param_LPIC;
cam = initialize_cam_STSC(ICLNUIMdataset, optsLPIC.imagePyramidLevel);

K = cam.KD_pyramid(:,:,1);
Kinv = inv(K);

%% visualize rgb, depth, and confidence images

% image index
h_trajectory = figure;
f = FigureRotator(gca());

%set(gcf,'color','w'); axis equal; axis off; view(0,-75);
%set(gca,'Units','normalized','Position',[0 0 1 1]);
%set(gcf,'Units','pixels','Position',[200 100 1600 1000]);
for imgIdx = 1:M
% read color, depth, and confidence images
colorImage = imread([datasetPath sprintf('/rgb_new/%d.png', imgIdx)]);
depthImage = imread([datasetPath sprintf('/depth_new/%d.png', imgIdx)]);
confImage = imread([datasetPath sprintf('/confidence_new/%d.png', imgIdx)]);

colorImageResized = imresize(colorImage, [size(depthImage)]);

% ground truth trajectory in ICL NUIM dataset
R_gc_true = zeros(3,3,M);
p_gc_true = zeros(3,M);
T_gc_true = cell(1,M);

% camera body frame
R_gc_true(:,:,imgIdx) = q2r(ICLNUIMdataset.vicon.q_gc_Sync(:,imgIdx));
p_gc_true(:,imgIdx) = ICLNUIMdataset.vicon.p_gc_Sync(:,imgIdx);
T_gc_true{imgIdx} = [ R_gc_true(:,:,imgIdx), p_gc_true(:,imgIdx);
        zeros(1,3),           1; ];

% 3) plot 3D point cloud with color, depth images
load([datasetPath '/camera_matrix.mat']);
depthImage(confImage == 0) = 0;
[x3DptsCam, x3DptsColor] = generateColored3DPoints(colorImageResized, double(depthImage)/1000, 0, K, 1);
x3DptsCam = T_gc_true{imgIdx}*x3DptsCam;

numPts = size(x3DptsCam,2);
scatter3(x3DptsCam(3,:).' , x3DptsCam(1,:).' , x3DptsCam(2,:).' , 100*ones(numPts,1) , x3DptsColor.','.'); axis equal; hold on;
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% draw moving trajectory
%plot3(stateEsti_LAPODEMO_forview(1,1:imgIdx),stateEsti_LAPODEMO_forview(2,1:imgIdx),stateEsti_LAPODEMO_forview(3,1:imgIdx),'Color','m','LineStyle','-','LineWidth',2.3);
%plot3(stateEsti_OPVO_forview(1,1:imgIdx),stateEsti_OPVO_forview(2,1:imgIdx),stateEsti_OPVO_forview(3,1:imgIdx),'Color',lineColorMaps(7,:),'LineStyle','-','LineWidth',1.3);
%plot3(stateTrue_forview(1,1:imgIdx),stateTrue_forview(2,1:imgIdx),stateTrue_forview(3,1:imgIdx),'Color','k','LineStyle','-','LineWidth',1.3);
plot3(p_gc_true(3,1:imgIdx),p_gc_true(1,1:imgIdx),p_gc_true(2,1:imgIdx),'Color','m','LineStyle','-','LineWidth',3);
% draw camera body and frame
%RgcLAPODEMO_current = T_gc_LAPODEMO_forview{imgIdx}(1:3,1:3);
%pgcLAPODEMO_current = T_gc_LAPODEMO_forview{imgIdx}(1:3,4);
%image_current = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
%plot_camera_frame(RgcLAPODEMO_current, pgcLAPODEMO_current, image_current, 0.6, 'm');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% figure options
set(gcf,'color','w'); axis equal; hold off; view(0,0);      % viewpoint angle
%set(gca, 'ZDir', 'reverse');
set(gca,'Units','normalized','Position',[0 0 1 1]);                         % axis size
set(gcf,'Units','pixels','Position',[200 100 1600 1000]);                % figure size
axis([-10 2 -2 2 -2 5]);               % limit of each axis
pause(0.01); refresh(h_trajectory);

end
% figure options


%///////////////////////////////////////////////////////////////////////////////////%

%{
% 4) plot 6-DoF camera poses from Apple ARKit (VIO)
load([datasetPath '/odometry.mat']);

figure; hold on; grid on; axis equal;
L = 0.3; % coordinate axis length
A = [0 0 0 1; L 0 0 1; 0 0 0 1; 0 L 0 1; 0 0 0 1; 0 0 L 1]';
for k = 1:60:length(T_gc_ARKit)
    T = T_gc_ARKit{k};
    B = T * A;
    plot3(B(1,1:2),B(2,1:2),B(3,1:2),'-r','LineWidth',1);    % x: red
    plot3(B(1,3:4),B(2,3:4),B(3,3:4),'-g','LineWidth',1);   % y: green
    plot3(B(1,5:6),B(2,5:6),B(3,5:6),'-b','LineWidth',1);   % z: blue
end
plot3(p_gc_ARKit(1,:),p_gc_ARKit(2,:),p_gc_ARKit(3,:),'k','LineWidth',2);
plot_inertial_frame(0.5); xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');

% figure options
f = FigureRotator(gca());
%}









