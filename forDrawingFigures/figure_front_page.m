%% figure_front_page

clc;
clear;
close all;

addpath('addon/lsd_1.6');
addpath('addon/lsd_1.6/Matlab');


% TUM RGBD dataset (1~12)
expCase = 4;
setupParams_TUM_RGBD;
imInit      = 1;
M           = 1093;

% are figures drawn?
% 1 : yes, draw figures to see current status
% 0 : no, just run LPRVO
toVisualize = 1;


% load TUM RGBD dataset data
rawTUMRGBDdataset = rawTUMRGBDdataset_load(datasetPath, freiburg_type);


% camera calibration parameters
[TUMRGBDdataset] = getSyncTUMRGBDdataset(rawTUMRGBDdataset, imInit, M);
optsLPRVO = load_param_LPRVO;
cam = initialize_cam_TUM_RGBD(TUMRGBDdataset, optsLPRVO.imagePyramidLevel);


%% load ground truth data


% ground truth trajectory in TUM RGBD dataset
R_gc_true = zeros(3,3,M);
p_gc_true = zeros(3,M);
T_gc_true = cell(1,M);
for k = 1:M
    % camera body frame
    R_gc_true(:,:,k) = q2r(TUMRGBDdataset.vicon.q_gc_Sync(:,k));
    p_gc_true(:,k) = TUMRGBDdataset.vicon.p_gc_Sync(:,k);
    T_gc_true{k} = [ R_gc_true(:,:,k), p_gc_true(:,k);
        zeros(1,3),           1; ];
end
if (toVisualize)
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


% generate ground truth trajectory in vector form
stateTrue = zeros(6,M);
stateTrue(1:3,:) = p_gc_true;
for k = 1:size(p_gc_true,2)
    [yaw, pitch, roll] = dcm2angle(R_gc_true(:,:,k));
    stateTrue(4:6,k) = [roll; pitch; yaw];
end


%% main LPRVO part

% image
imgIdx = 757;
imageCurForLine = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'gray');
imageCurForMW = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'depth');


% initialize and seek the dominant MF
optsLPRVO.imagePyramidLevel = 1;
[R_cM, vpInfo, pNV, sNV, sPP] = seekManhattanWorld(imageCurForLine, imageCurForMW, depthCurForMW, cam, optsLPRVO);


% find camera and VP orientation
R_gc1 = angle2rotmtx([-20*(pi/180); -58*(pi/180); 0*(pi/180)]).';
R_c1M = R_cM;
R_gM = R_gc1 * R_c1M;


%% plot original image with 1-line and 1-plane


% original image
figure;
imshow(imageCurForMW, []);
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);


% original image with 1-line
figure;
imshow(imageCurForMW, []); hold on;
plots_extended_lines(R_cM, vpInfo, imageCurForLine, cam, optsLPRVO); hold off;
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);


% original image with 1-plane
figure;
plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPRVO);
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);


%% plot the Manhattan frame


figure;
hold on; grid on; axis equal; view(130,30);
plot_Manhattan_camera_frame(R_cM, R_gc1);
set(gcf,'color','w'); axis off;
plot_true_camera_frame(R_gc1); hold off;





