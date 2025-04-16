%% figure_plane_tracking

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


%% plot surface normal vectors & camera orientation with MW

% read first image
imgIdx = 350;
imageCurForLine = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
imageCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');


% initialize and seek the dominant MF
optsLPRVO.imagePyramidLevel = 1;
[R_cM, vpInfo, pNV, sNV, sPP] = seekManhattanWorld(imageCurForLine, imageCurForMW, depthCurForMW, cam, optsLPRVO);
R_cM = inv(R_gc_LPRVO(:,:,imgIdx)) * R_gM;


% plot 1-plane
figure;
plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPRVO);    % AlphaData: 0.60
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);


% plot normal vector tracking
optsLPRVO.halfApexAngle = deg2rad(10);
figure;
plot_plane_sphere(pNV, sNV, optsLPRVO);                                 % change z-axis color in plot_body_frame
set(gcf,'color','w'); axis off; grid off; view(0, -75);
set(gcf,'Units','pixels','Position',[800 150 800 800]);


% for legend
figure;
h_plane = plot3(sNV(1,1:2), sNV(2,1:2), sNV(3,1:2),'Color','r','LineWidth',2.5); hold on;
h_sNV = plot3(sNV(1,1:2), sNV(2,1:2), sNV(3,1:2),'.','Color','k','MarkerSize',15); hold off;
set(gcf,'color','w'); axis equal; grid off;
legend([h_plane h_sNV],{'Dominant Plane','Surface Normals'},'Orientation','vertical','FontSize',15,'FontName','Times New Roman');








