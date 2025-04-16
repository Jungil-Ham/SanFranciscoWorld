%% figure_eval_RANSAC

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


%% plot plane & multiple lines with normal RANSAC

% read first image
imgIdx = 194;
imageCurForLine = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'gray');
imageCurForMW = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'depth');


% initialize and seek the dominant MF
optsLPRVO.lineInlierThreshold = 7;
optsLPRVO.imagePyramidLevel = 1;
[R_cM, vpInfo, pNV, sNV, sPP] = seekManhattanWorld_normalRANSAC(imageCurForLine, imageCurForMW, depthCurForMW, cam, optsLPRVO);


% plot 1-plane & multiple lines
figure;
plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPRVO); hold on;               % AlphaData: 0.60
plots_extended_lines(R_cM, vpInfo, imageCurForLine, cam, optsLPRVO); hold off;   % LineWidth: 5.0
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);


%% plot plane & multiple lines with proposed RANSAC

% read first image
imgIdx = 194;
imageCurForLine = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'gray');
imageCurForMW = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'depth');


% initialize and seek the dominant MF
optsLPRVO.lineInlierThreshold = 1;
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




