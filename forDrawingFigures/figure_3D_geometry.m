%% figure_3D_geometry

clc;
clear;
close all;

addpath('addon/lsd_1.6');
addpath('addon/lsd_1.6/Matlab');


% ICL NUIM dataset (1~8)
expCase = 4;
setupParams_ICL_NUIM;


% load saved data in SaveDir
SaveDir = [datasetPath '/CVPR2018'];
load([SaveDir '/LPRVO.mat']);


%% main LPRVO part

% image
imgIdx = 356;
imageCurForLine = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
imageCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');


% initialize and seek the dominant MF
optsLPRVO.imagePyramidLevel = 1;
[R_cM, vpInfo, pNV, sNV, sPP] = seekManhattanWorld(imageCurForLine, imageCurForMW, depthCurForMW, cam, optsLPRVO);


%% plot the Gaussian sphere with great circle


% plot the Gaussian sphere
figure;
plot_unit_sphere(1, 18, 0.8); hold on; grid on; axis equal;


% plot first line's great circle
Kinv = inv(cam.K);
linedata = vpInfo(2).line(2).data;
ptEnd1_p_d = [linedata(1:2), 1].';
ptEnd2_p_d = [linedata(3:4), 1].';
ptEnd1_n_d = Kinv * ptEnd1_p_d;
ptEnd2_n_d = Kinv * ptEnd2_p_d;
ptEnd1_n_d = ptEnd1_n_d / norm(ptEnd1_n_d);
ptEnd2_n_d = ptEnd2_n_d / norm(ptEnd2_n_d);
plot_great_circle(ptEnd1_n_d, ptEnd2_n_d, 2, 'g', 'greatcircle');


% plot first line's great circle normal vector
circleNormal1 = cross(ptEnd1_n_d.', ptEnd2_n_d.');
circleNormal1 = circleNormal1 / norm(circleNormal1);
plot3([0 circleNormal1(1)],[0 circleNormal1(2)],[0 circleNormal1(3)], 'g', 'LineWidth', 2);


% plot (plane normal / circle normal) plane
VP1 = R_cM(:,1);
VP1 = VP1 / norm(VP1);
plot_great_circle(VP1, circleNormal1, 2, 'k', 'greatcircle');


% plot the Manhattan frame
plot_body_frame(R_cM, '-', 4); axis off;
f = FigureRotator(gca());






