%% Figures for making video clips with ICL NUIM dataset: lr_kt0_pure / of_kt1

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
load([SaveDir '/LPRVO_video.mat']);


%% (1) camera view with clustered lines and single plane

% rotational motion
imgIdx = 2;
R_gc = R_gc_LPRVO(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;


% plane index and vpInfo for MW
pNV = pNV_LPRVO{imgIdx};
planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
vpInfo = vpInfo_LPRVO{imgIdx};


% surface normal vector
optsLPRVO.imagePyramidLevel = 1;
imageCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
[sNV, sPP] = estimateSurfaceNormalGradient_mex(imageCurForMW, depthCurForMW, cam, optsLPRVO);


% test first image
h_camview = figure('Position',[450 500 size(imageCurForMW,2) size(imageCurForMW,1)]); axes('Position',[0 0 1 1]);
plot_image_plane_inMW(pNV, planeIdx, sNV, sPP, imageCurForMW, optsLPRVO); hold on;      % AlphaData: 0.50
plots_image_lines_inMW(R_cM, vpInfo, imageCurForLine, cam, optsLPRVO); hold off;            % LineWidth: 3.0


for imgIdx = 2:M
    
    % rotational motion
    R_gc = R_gc_LPRVO(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    
    % plane index and vpInfo for MW
    pNV = pNV_LPRVO{imgIdx};
    planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
    vpInfo = vpInfo_LPRVO{imgIdx};
    
    
    % surface normal vector
    optsLPRVO.imagePyramidLevel = 1;
    imageCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    depthCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
    [sNV, sPP] = estimateSurfaceNormalGradient_mex(imageCurForMW, depthCurForMW, cam, optsLPRVO);
    
    
    % clustered lines and plane
    cla;
    plot_image_plane_inMW(pNV, planeIdx, sNV, sPP, imageCurForMW, optsLPRVO); hold on;
    plots_image_lines_inMW(R_cM, vpInfo, imageCurForMW, cam, optsLPRVO); hold off;
    pause(0.01); refresh(h_camview);
    
    
    % save images
    saveImg = getframe(h_camview);
    imwrite(saveImg.cdata , sprintf('figures/%06d.png', imgIdx));
end


%% (2) Gaussian sphere compass

% rotational motion
imgIdx = 2;
R_gc = R_gc_LPRVO(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;


% test first image
h_sphere = figure('Position',[800 150 800 800]); axes('Position',[0 0 1 1]);
plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
plot_MW_3Darrow(R_cM, 0.80); lighting phong; camlight right; hold off;
set(gcf,'color','w'); axis off; grid off; view(85,15);


for imgIdx = 2:M
    
    % rotational motion
    R_gc = R_gc_LPRVO(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    
    % test first image
    cla;
    plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
    plot_MW_3Darrow(R_cM, 0.80); lighting phong; camlight right; hold off;
    set(gcf,'color','w'); axis off; grid off; view(85,15);
    pause(0.01); refresh(h_sphere);
    
    
    % save images
    saveImg = getframe(h_sphere);
    imwrite(saveImg.cdata , sprintf('figures/%06d.png', imgIdx));
end


%% (3) camera view with all detected lines

% current RGB image
imgIdx = 1;
imageCurForLine = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
imageCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');


% line detection
lineDetector = optsLPRVO.lineDetector;
lineLength = optsLPRVO.lineLength;
dimageCurForLine = double(imageCurForLine);
if (strcmp(lineDetector,'lsd'))
    [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
elseif (strcmp(lineDetector,'gpa'))
    [lines, ~] = gpa(imageCurForLine, lineLength);
end
lines = extractUniqueLines(lines, cam);


% test first image
h_RGBwithLines = figure('Position',[450 500 size(imageCurForMW,2) size(imageCurForMW,1)]); axes('Position',[0 0 1 1]);
imshow(imageCurForMW,[]); hold on;
for k = 1:size(lines,1)
    plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',5.5);
end
hold off;


for imgIdx = 2:M
    
    % current RGB image
    imageCurForLine = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
    imageCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    
    
    % line detection
    dimageCurForLine = double(imageCurForLine);
    if (strcmp(lineDetector,'lsd'))
        [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
    elseif (strcmp(lineDetector,'gpa'))
        [lines, ~] = gpa(imageCurForLine, lineLength);
    end
    lines = extractUniqueLines(lines, cam);
    
    
    % all detected lines
    cla;
    imshow(imageCurForMW,[]); hold on;
    for k = 1:size(lines,1)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',5.5);
    end
    hold off;
    pause(0.01); refresh(h_RGBwithLines);
    
    
    % save images
    saveImg = getframe(h_RGBwithLines);
    imwrite(saveImg.cdata , sprintf('figures/%06d.png', imgIdx));
end


%% (4) depth camera view with grayscale

% current depth image
imgIdx = 1;
depthCur = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');


% test first image
h_DepthGray = figure('Position',[450 500 size(depthCur,2) size(depthCur,1)]); axes('Position',[0 0 1 1]);
imshow(depthCur, []);


for imgIdx = 2:M
    
    % current depth image
    depthCur = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
    
    
    % depth with colormap
    cla;
    imshow(depthCur, []);
    pause(0.01); refresh(h_DepthGray);
    
    
    % save images
    saveImg = getframe(h_DepthGray);
    imwrite(saveImg.cdata , sprintf('figures/%06d.png', imgIdx));
end















%% Figures for making video clips with TUM RGBD dataset: rgbd_dataset_freiburg3_long_office_household
%                                                                                  : rgbd_dataset_freiburg3_nostructure_notexture_near_withloop
%                                                                                  : rgbd_dataset_freiburg3_nostructure_texture_near_withloop

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
load([SaveDir '/LPRVO_video.mat']);


%% (1) camera view with clustered lines and single plane

% rotational motion
imgIdx = 2;
R_gc = R_gc_LPRVO(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;


% plane index and vpInfo for MW
pNV = pNV_LPRVO{imgIdx};
planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
vpInfo = vpInfo_LPRVO{imgIdx};


% surface normal vector
optsLPRVO.imagePyramidLevel = 1;
imageCurForMW = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'depth');
[sNV, sPP] = estimateSurfaceNormalGradient_mex(imageCurForMW, depthCurForMW, cam, optsLPRVO);


% test first image
h_camview = figure('Position',[450 500 size(imageCurForMW,2) size(imageCurForMW,1)]); axes('Position',[0 0 1 1]);
plot_image_plane_inMW(pNV, planeIdx, sNV, sPP, imageCurForMW, optsLPRVO); hold on;      % AlphaData: 0.50
plots_image_lines_inMW(R_cM, vpInfo, imageCurForLine, cam, optsLPRVO); hold off;            % LineWidth: 3.0


for imgIdx = 2:M
    
    % rotational motion
    R_gc = R_gc_LPRVO(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    
    % plane index and vpInfo for MW
    pNV = pNV_LPRVO{imgIdx};
    planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
    vpInfo = vpInfo_LPRVO{imgIdx};
    
    
    % surface normal vector
    optsLPRVO.imagePyramidLevel = 1;
    imageCurForMW = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'rgb');
    depthCurForMW = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'depth');
    [sNV, sPP] = estimateSurfaceNormalGradient_mex(imageCurForMW, depthCurForMW, cam, optsLPRVO);
    
    
    % clustered lines and plane
    cla;
    plot_image_plane_inMW(pNV, planeIdx, sNV, sPP, imageCurForMW, optsLPRVO); hold on;
    plots_image_lines_inMW(R_cM, vpInfo, imageCurForMW, cam, optsLPRVO); hold off;
    pause(0.01); refresh(h_camview);
    
    
    % save images
    saveImg = getframe(h_camview);
    imwrite(saveImg.cdata , sprintf('figures/%06d.png', imgIdx));
end


%% (2) Gaussian sphere compass

% rotational motion
imgIdx = 2;
R_gc = R_gc_LPRVO(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;


% test first image
h_sphere = figure('Position',[800 150 800 800]); axes('Position',[0 0 1 1]);
plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
plot_MW_3Darrow(R_cM, 0.80); lighting phong; camlight right; hold off;
set(gcf,'color','w'); axis off; grid off; view(85,15);


for imgIdx = 2:M
    
    % rotational motion
    R_gc = R_gc_LPRVO(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    
    % test first image
    cla;
    plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
    plot_MW_3Darrow(R_cM, 0.80); lighting phong; camlight right; hold off;
    set(gcf,'color','w'); axis off; grid off; view(85,15);
    pause(0.01); refresh(h_sphere);
    
    
    % save images
    saveImg = getframe(h_sphere);
    imwrite(saveImg.cdata , sprintf('figures/%06d.png', imgIdx));
end


%% (3) camera view with all detected lines

% current RGB image
imgIdx = 1;
imageCurForLine = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'gray');
imageCurForMW = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'rgb');


% line detection
lineDetector = optsLPRVO.lineDetector;
lineLength = optsLPRVO.lineLength;
dimageCurForLine = double(imageCurForLine);
if (strcmp(lineDetector,'lsd'))
    [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
elseif (strcmp(lineDetector,'gpa'))
    [lines, ~] = gpa(imageCurForLine, lineLength);
end
lines = extractUniqueLines(lines, cam);


% test first image
h_RGBwithLines = figure('Position',[450 500 size(imageCurForMW,2) size(imageCurForMW,1)]); axes('Position',[0 0 1 1]);
imshow(imageCurForMW,[]); hold on;
for k = 1:size(lines,1)
    plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',5.5);
end
hold off;


for imgIdx = 2:M
    
    % current RGB image
    imageCurForLine = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'gray');
    imageCurForMW = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'rgb');
    
    
    % line detection
    dimageCurForLine = double(imageCurForLine);
    if (strcmp(lineDetector,'lsd'))
        [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
    elseif (strcmp(lineDetector,'gpa'))
        [lines, ~] = gpa(imageCurForLine, lineLength);
    end
    lines = extractUniqueLines(lines, cam);
    
    
    % all detected lines
    cla;
    imshow(imageCurForMW,[]); hold on;
    for k = 1:size(lines,1)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',5.5);
    end
    hold off;
    pause(0.01); refresh(h_RGBwithLines);
    
    
    % save images
    saveImg = getframe(h_RGBwithLines);
    imwrite(saveImg.cdata , sprintf('figures/%06d.png', imgIdx));
end


%% (4) depth camera view with grayscale

% current depth image
imgIdx = 1;
depthCur = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'depth');


% test first image
h_DepthGray = figure('Position',[450 500 size(depthCur,2) size(depthCur,1)]); axes('Position',[0 0 1 1]);
imshow(depthCur, []);


for imgIdx = 2:M
    
    % current depth image
    depthCur = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'depth');
    
    
    % depth with colormap
    cla;
    imshow(depthCur, []);
    pause(0.01); refresh(h_DepthGray);
    
    
    % save images
    saveImg = getframe(h_DepthGray);
    imwrite(saveImg.cdata , sprintf('figures/%06d.png', imgIdx));
end




