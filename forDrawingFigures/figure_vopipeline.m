%% figure_vopipeline

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


%% plot original image

% image index
imgIdx = 393;


% RGB image
figure;
imageCur = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
imshow(imageCur);
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);


% depth image
figure;
depthCur = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
imshow(depthCur, []); colormap(gca, jet);
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);


%% plot lines and plane

% read first image
imageCurForLine = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
imageCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');


% initialize and seek the dominant MF
optsLPRVO.imagePyramidLevel = 1;
[R_cM, vpInfo, pNV, sNV, sPP] = seekManhattanWorld(imageCurForLine, imageCurForMW, depthCurForMW, cam, optsLPRVO);


% assign current parameters
lineDetector = optsLPRVO.lineDetector;
lineLength = optsLPRVO.lineLength;


% line detection
dimageCurForLine = double(imageCurForLine);
if (strcmp(lineDetector,'lsd'))
    [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
elseif (strcmp(lineDetector,'gpa'))
    [lines, ~] = gpa(imageCurForLine, lineLength);
end
lines = extractUniqueLines(lines, cam);


% plot image and lines
figure;
imshow(imageCurForMW,[]); hold on;
for k = 1:size(lines,1)
    plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',8.0);
end
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);


% plot 1-plane with 3D point cloud
figure;
plot_plane_pointCloud(pNV, sNV, sPP, imageCurForMW, depthCurForMW, cam, optsLPRVO);
view(-13,-90);
f = FigureRotator(gca());


%% plot 1-line and 1-plane RANSAC

% plot the Gaussian sphere
figure;
plot_unit_sphere(1, 18, 0.8); hold on; grid on; axis equal;


% plot great circles of lines
Kinv = inv(cam.K);
for k = 1:vpInfo(2).n
    linedata = vpInfo(2).line(k).data;
    ptEnd1_p_d = [linedata(1:2), 1].';
    ptEnd2_p_d = [linedata(3:4), 1].';
    ptEnd1_n_d = Kinv * ptEnd1_p_d;
    ptEnd2_n_d = Kinv * ptEnd2_p_d;
    ptEnd1_n_d = ptEnd1_n_d / norm(ptEnd1_n_d);
    ptEnd2_n_d = ptEnd2_n_d / norm(ptEnd2_n_d);
    plot_great_circle(ptEnd1_n_d, ptEnd2_n_d, 4, 'g', 'greatcircle');
end
for k = 1:vpInfo(3).n
    linedata = vpInfo(3).line(k).data;
    ptEnd1_p_d = [linedata(1:2), 1].';
    ptEnd2_p_d = [linedata(3:4), 1].';
    ptEnd1_n_d = Kinv * ptEnd1_p_d;
    ptEnd2_n_d = Kinv * ptEnd2_p_d;
    ptEnd1_n_d = ptEnd1_n_d / norm(ptEnd1_n_d);
    ptEnd2_n_d = ptEnd2_n_d / norm(ptEnd2_n_d);
    plot_great_circle(ptEnd1_n_d, ptEnd2_n_d, 4, 'b', 'greatcircle');
end


% plot the Manhattan frame
plot_body_frame(R_cM, '-', 6);
set(gcf,'color','w'); axis off; grid off; view(0, -75);
set(gcf,'Units','pixels','Position',[800 150 800 800]);
f = FigureRotator(gca());


%% plot nonlinear optimization with orthogonal distance

% plot plane & lines
figure;
plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPRVO); hold on;
plots_extended_lines(R_cM, vpInfo, imageCurForLine, cam, optsLPRVO); hold off;
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);




