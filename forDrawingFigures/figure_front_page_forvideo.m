%% figure_front_page_forvideo

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


%% single line & surface normal vectors

% read first image
imgIdx = 544;
imageCurForLine = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
imageCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');


% initialize and seek the dominant MF
optsLPRVO.imagePyramidLevel = 1;
[R_cM, vpInfo, pNV, sNV, sPP] = seekManhattanWorld(imageCurForLine, imageCurForMW, depthCurForMW, cam, optsLPRVO);
R_cM = inv(R_gc_LPRVO(:,:,imgIdx)) * R_gM;


%% plot original image with lines

% original image
figure;
imshow(imageCurForMW, []);
iptsetpref('ImshowBorder','tight');


% original image with a single line
figure;
imshow(imageCurForMW, []); hold on;
plots_extended_lines(R_cM, vpInfo, imageCurForLine, cam, optsLPRVO); hold off;   % LineWidth: 5.0
iptsetpref('ImshowBorder','tight');


%% 3D point cloud generation

% assign parameters
halfApexAngle = optsLPRVO.halfApexAngle;


% project normal vectors to each Manhattan frame axis
numNormalVector = size(sNV, 2);
surfaceAxisIndex = ones(1, numNormalVector) * -1000;
for a = 1:3
    % projection on each axis (x, y, z)
    R_Mc = [R_cM(:,mod(a+3,3)+1), R_cM(:,mod(a+4,3)+1), R_cM(:,mod(a+5,3)+1)].';
    n_j = R_Mc * sNV;
    
    % check within half apex angle
    lambda = sqrt(n_j(1,:).*n_j(1,:) + n_j(2,:).*n_j(2,:));
    index = find(lambda <= sin(halfApexAngle));
    surfaceAxisIndex(:, index) = a;
end


% recover 3D point cloud and RGB information
colorImage = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
depthImage = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
imageHeight = size(depthImage, 1);
imageWidth = size(depthImage, 2);

x3DptsCam = zeros(4, imageHeight*imageWidth);
x3DptsColor = zeros(3, imageHeight*imageWidth);
ptsCount = 0;
for k = 1:numNormalVector
    
    % axis and u,v coordinates
    a = surfaceAxisIndex(k);
    u = sPP(1,k);
    v = sPP(2,k);
    
    if (depthImage(v, u) >= 0.5 && depthImage(v, u) <= 8)
        ptsCount = ptsCount + 1;
        
        depth = depthImage(v, u);
        
        x3DptsCam(1, ptsCount) = ((u - cam.K(1,3)) / cam.K(1,1)) * depth;
        x3DptsCam(2, ptsCount) = ((v - cam.K(2,3)) / cam.K(2,2)) * depth;
        x3DptsCam(3, ptsCount) = depth;
        x3DptsCam(4, ptsCount) = 1;
        
        if (a == 1)
            % red
            x3DptsColor(1, ptsCount) = 150 / 255;
            x3DptsColor(2, ptsCount) = 0 / 255;
            x3DptsColor(3, ptsCount) = 0 / 255;
        else
            % other
            x3DptsColor(1, ptsCount) = double(colorImage(v, u, 1)) / 255;
            x3DptsColor(2, ptsCount) = double(colorImage(v, u, 2)) / 255;
            x3DptsColor(3, ptsCount) = double(colorImage(v, u, 3)) / 255;
        end
    end
end
x3DptsCam(:, (ptsCount+1):end) = [];
x3DptsColor(:, (ptsCount+1):end) = [];


% draw 3-D reconstruction results
figure;
numPts = size(x3DptsCam,2);
scatter3(x3DptsCam(1,:).' , x3DptsCam(2,:).' , x3DptsCam(3,:).' , 100*ones(numPts,1) , x3DptsColor.','.'); hold on;

% draw camera body and frame
T_cam = eye(4);
RgcLAPODEMO_current = T_cam(1:3,1:3);
pgcLAPODEMO_current = T_cam(1:3,4);
image_current = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
plot_camera_frame(RgcLAPODEMO_current, pgcLAPODEMO_current, image_current, 1.2, 'm'); hold off;

% figure options
set(gcf,'color','k'); axis equal; axis off;
f = FigureRotator(gca());








