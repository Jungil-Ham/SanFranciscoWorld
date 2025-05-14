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

imageCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, 1, 'rgb');
depthCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, 1, 'depth');

% pixel and depth value

imageHeight = size(depthCurForMW, 1);
imageWidth = size(depthCurForMW, 2);

pixelPtsRef = zeros(3, imageHeight*imageWidth);
depthPtsRef = zeros(3, imageHeight*imageWidth);
pixelCnt = 0;
for v = 1:imageHeight
    for u = 1:imageWidth
        if ( (depthCurForMW(v,u) >= 0.1) && (depthCurForMW(v,u) <= 4.5) )
            pixelCnt = pixelCnt + 1;
            pixelPtsRef(:,pixelCnt) = [u; v; 1]; %3d point가 normalized 평면에서 표현된 픽셀 넘버
            depthPtsRef(:,pixelCnt) = depthCurForMW(v,u) * ones(3,1); %그 픽셀에 해당하는 깊이 값
            colorPtsRef(:,pixelCnt) = imageCurForMW(v,u) ;
        end
    end
end
pixelPtsRef(:,(pixelCnt+1):end) = [];
depthPtsRef(:,(pixelCnt+1):end) = [];

% 3D point cloud
normPtsRef = Kinv * pixelPtsRef;
pointCloudRef = normPtsRef .* depthPtsRef;
pointCloudRef = [pointCloudRef;ones(1,size(pointCloudRef,2))];
% ground truth trajectory in ICL NUIM dataset
R_gc_true = zeros(3,3,M);
p_gc_true = zeros(3,M);
T_gc_true = cell(1,M);
for k = 1:M
    % camera body frame
    R_gc_true(:,:,k) = q2r(ICLNUIMdataset.vicon.q_gc_Sync(:,k));
    p_gc_true(:,k) = ICLNUIMdataset.vicon.p_gc_Sync(:,k);
    T_gc_true{k} = [ R_gc_true(:,:,k), p_gc_true(:,k);
        zeros(1,3),           1; ];
end

depthPerimg = T_gc_true{1}*pointCloudRef;



%% (4) estimated trajectory and pointcloud - version 2
% draw 3D estimated trajectory with 3-D reconstruction results
h_trajectory = figure;
set(gcf,'color','w'); axis equal; axis off; view(0,-75);
set(gca,'Units','normalized','Position',[0 0 1 1]);
set(gcf,'Units','pixels','Position',[200 100 1600 1000]);

X3DptsGlobal_k =  depthPerimg;
X3DptsColor_k = colorPtsRef;
%for imgIdx = 1:M
    % initialize the figure
    cla;
    % draw 3-D reconstruction results
    %X3DptsGlobal_k = X3DptsGlobal_Save_forview{imgIdx};
    %X3DptsColor_k = X3DptsColor_Save{imgIdx};
    numPts = size(X3DptsGlobal_k,2);
    scatter3(X3DptsGlobal_k(1,:).' , X3DptsGlobal_k(2,:).' , X3DptsGlobal_k(3,:).' , 100*ones(numPts,1) , X3DptsColor_k.','.'); hold on;
    % draw moving trajectory
    plot3(stateEsti_LAPODEMO_forview(1,1:imgIdx),stateEsti_LAPODEMO_forview(2,1:imgIdx),stateEsti_LAPODEMO_forview(3,1:imgIdx),'Color','m','LineStyle','-','LineWidth',2.3);
    plot3(stateEsti_OPVO_forview(1,1:imgIdx),stateEsti_OPVO_forview(2,1:imgIdx),stateEsti_OPVO_forview(3,1:imgIdx),'Color',lineColorMaps(7,:),'LineStyle','-','LineWidth',1.3);
    plot3(stateTrue_forview(1,1:imgIdx),stateTrue_forview(2,1:imgIdx),stateTrue_forview(3,1:imgIdx),'Color','k','LineStyle','-','LineWidth',1.3);
    % draw camera body and frame
    RgcLAPODEMO_current = T_gc_LAPODEMO_forview{imgIdx}(1:3,1:3);
    pgcLAPODEMO_current = T_gc_LAPODEMO_forview{imgIdx}(1:3,4);
    image_current = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    plot_camera_frame(RgcLAPODEMO_current, pgcLAPODEMO_current, image_current, 0.6, 'm');
    % figure options
    set(gcf,'color','w'); axis equal; axis off; hold off; view(0,-75);      % viewpoint angle
    set(gca,'Units','normalized','Position',[0 0 1 1]);                         % axis size
    set(gcf,'Units','pixels','Position',[200 100 1600 1000]);                % figure size
    axis([-1.9672 3.9753 -1.106 2.4740 -2.8703 1.8167]);               % limit of each axis
    pause(0.01); refresh(h_trajectory);
    % save images
    saveImg = getframe(h_trajectory);
    imwrite(saveImg.cdata , sprintf('figuresTrajectory/%06d.png',imgIdx));
%end

%{
% if (toVisualize)
    figure; hold on; axis equal;
    L = 0.1; % coordinate axis length
    A = [0 0 0 1; L 0 0 1; 0 0 0 1; 0 L 0 1; 0 0 0 1; 0 0 L 1]';
    
    for k = 1:10:M
        T = T_gc_true{k};
        B = T * A;
        plot3(B(1,1:2),B(2,1:2),B(3,1:2),'-r','LineWidth',1); % x: red
        plot3(B(1,3:4),B(2,3:4),B(3,3:4),'-g','LineWidth',1); % y: green
        plot3(B(1,5:6),B(2,5:6),B(3,5:6),'-b','LineWidth',1); % z: blue
    end
    plot3(p_gc_true(1,:),p_gc_true(2,:),p_gc_true(3,:),'k','LineWidth',2);
    
    title('ground truth trajectory of cam0 frame')
    xlabel('x'); ylabel('y'); zlabel('z');
end
%}

% generate ground truth trajectory in vector form
stateTrue = zeros(6,M);
stateTrue(1:3,:) = p_gc_true;
for k = 1:size(p_gc_true,2)
    [yaw, pitch, roll] = dcm2angle(R_gc_true(:,:,k));
    stateTrue(4:6,k) = [roll; pitch; yaw];
end

[x3DptsCam,x3DptsColor] = getStereoPoints_MAV(imLeftDir, imRightDir, MAVdataset, cam, imgIdx, imLeftDir_synthetic);