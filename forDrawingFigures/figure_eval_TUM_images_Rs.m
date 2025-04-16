%% figure_eval_TUM_images_Rs
%% rgbd_dataset_freiburg3_long_office_household @ imgIdx = 50, 1040, 1865

clc;
clear;
close all;

addpath('addon/lsd_1.6');
addpath('addon/lsd_1.6/Matlab');


% TUM RGBD dataset (1~12)
expCase = 3;
setupParams_TUM_RGBD;


% load saved data in SaveDir
SaveDir = [datasetPath '/CVPR2018'];
load([SaveDir '/LPRVO.mat']);


%% plot plane & multiple lines / camera orientation with MW


% read first image
imgIdx = 50;
imageCurForLine = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'gray');
imageCurForMW = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'depth');


% initialize and seek the dominant MF
optsLPRVO.imagePyramidLevel = 1;
[R_cM, vpInfo, pNV, sNV, sPP] = seekManhattanWorld(imageCurForLine, imageCurForMW, depthCurForMW, cam, optsLPRVO);
R_cM = inv(R_gc_LPRVO(:,:,imgIdx)) * R_gM;


% plot 1-plane & multiple lines
figure;
plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPRVO); hold on;               % AlphaData: 0.60
plots_extended_lines(R_cM, vpInfo, imageCurForLine, cam, optsLPRVO); hold off;   % LineWidth: 5.0
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);


% plot drift-free camera orientation with MW
R_gc_LPRVO_forview = inv(R_gc_LPRVO(:,:,1)) * R_gc_LPRVO(:,:,imgIdx);
R_gc_true_forview = inv(R_gc_true(:,:,1)) * R_gc_true(:,:,imgIdx);
figure;
hold on; grid on; axis equal; view(110,30);
plot_Manhattan_camera_frame(R_cM, R_gc_LPRVO_forview);
set(gcf,'color','w'); axis off;
plot_true_camera_frame(R_gc_true_forview); hold off;




%% rgbd_dataset_freiburg3_nostructure_notexture_near_withloop @ imgIdx = 40, 80, 148

clc;
clear;
close all;

addpath('addon/lsd_1.6');
addpath('addon/lsd_1.6/Matlab');


% TUM RGBD dataset (1~12)
expCase = 4;
setupParams_TUM_RGBD;


% load saved data in SaveDir
SaveDir = [datasetPath '/CVPR2018'];
load([SaveDir '/LPRVO.mat']);


%% plot plane & multiple lines / camera orientation with MW


% read first image
imgIdx = 40;
imageCurForLine = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'gray');
imageCurForMW = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'depth');


% initialize and seek the dominant MF
optsLPRVO.imagePyramidLevel = 1;
[R_cM, vpInfo, pNV, sNV, sPP] = seekManhattanWorld(imageCurForLine, imageCurForMW, depthCurForMW, cam, optsLPRVO);
R_cM = inv(R_gc_LPRVO(:,:,imgIdx)) * R_gM;


% plot 1-plane & multiple lines
figure;
plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPRVO); hold on;               % AlphaData: 0.60
plots_extended_lines(R_cM, vpInfo, imageCurForLine, cam, optsLPRVO); hold off;   % LineWidth: 5.0
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);


% plot drift-free camera orientation with MW
R_gc_LPRVO_forview = inv(R_gc_LPRVO(:,:,1)) * R_gc_LPRVO(:,:,imgIdx);
R_gc_true_forview = inv(R_gc_true(:,:,1)) * R_gc_true(:,:,imgIdx);
figure;
hold on; grid on; axis equal; view(110,30);
plot_Manhattan_camera_frame(R_cM, R_gc_LPRVO_forview);
set(gcf,'color','w'); axis off;
plot_true_camera_frame(R_gc_true_forview); hold off;

