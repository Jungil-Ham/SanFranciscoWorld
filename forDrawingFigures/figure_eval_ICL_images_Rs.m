%% figure_eval_ICL_images_Rs
%% lr_kt0 @ imgIdx = 196, 931, 1478

clc;
clear;
close all;

addpath('addon/lsd_1.6');
addpath('addon/lsd_1.6/Matlab');


% ICL NUIM dataset (1~8)
expCase = 1;
setupParams_ICL_NUIM;


% load saved data in SaveDir
SaveDir = [datasetPath '/CVPR2018'];
load([SaveDir '/LPRVO.mat']);


%% plot plane & multiple lines / camera orientation with MW


% read first image
imgIdx = 196;
imageCurForLine = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
imageCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');


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
figure;
hold on; grid on; axis equal; view(110,30);
plot_Manhattan_camera_frame(R_cM, R_gc_LPRVO(:,:,imgIdx));
set(gcf,'color','w'); axis off;
plot_true_camera_frame(R_gc_true(:,:,imgIdx)); hold off;




%% of_kt1 @ imgIdx = 160, 530, 918

clc;
clear;
close all;

addpath('addon/lsd_1.6');
addpath('addon/lsd_1.6/Matlab');


% ICL NUIM dataset (1~8)
expCase = 6;
setupParams_ICL_NUIM;


% load saved data in SaveDir
SaveDir = [datasetPath '/CVPR2018'];
load([SaveDir '/LPRVO.mat']);


%% plot plane & multiple lines / camera orientation with MW


% read first image
imgIdx = 160;
imageCurForLine = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
imageCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');


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
figure;
hold on; grid on; axis equal; view(110,30);
plot_Manhattan_camera_frame(R_cM, R_gc_LPRVO(:,:,imgIdx));
set(gcf,'color','w'); axis off;
plot_true_camera_frame(R_gc_true(:,:,imgIdx)); hold off;


