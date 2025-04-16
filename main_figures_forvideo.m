%% Figures for making video clips with ICL NUIM dataset: of_kt1

clc;
clear;
close all;

addpath('addon/lsd_1.6');
addpath('addon/lsd_1.6/Matlab');
addpath(genpath(pwd));
addpath 'C:\forDrawingFigures_MSMO'
addpath 'C:\SanFrancisco\forDrawingFigures'

% ICL NUIM dataset (1~8)
%expCase = 1; %Rot1
expCase = 8; % L
%expCase = 9; % U
setupParams_ARkit;


% load saved data in SaveDir
SaveDir = [datasetPath '/CVPR2018'];
load([SaveDir '/LPIC.mat']);

%% (1) Rot1

%% (1) camera view with all detected lines

%{
% current RGB image
imgIdx = startAt+1;
imageCurForRGB = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');


% line detection with LSD
lineDetector = optsLPIC.lineDetector;
lineLength = optsLPIC.lineLength;
dimageCurForLine = double(imageCurForLine);
if (strcmp(lineDetector,'lsd'))
    [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
elseif (strcmp(lineDetector,'gpa'))
    [lines, ~] = gpa(imageCurForLine, lineLength);
end
lines = extractUniqueLines(lines, cam);


% test first image
h_RGBwithLines = figure('Position',[650 200 size(imageCurForRGB,2) size(imageCurForRGB,1)]); axes('Position',[0 0 1 1]);
imshow(imageCurForRGB,[]); hold on;
for k = 1:size(lines,1)
    plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',6.0);
end
hold off;


for imgIdx = startAt:M
    %if(imgIdx == 1081 || imgIdx == 2876) %L1 1
    %    continue;
    %end
    % current RGB image

    if(imgIdx == 1126 ||imgIdx == 1571 || imgIdx == 1570 || imgIdx == 1626 || imgIdx == 1628 || imgIdx == 508 || imgIdx == 505 || imgIdx == 483 || imgIdx == 477 || imgIdx == 475 || imgIdx == 472 || imgIdx == 467 || imgIdx == 510 || imgIdx == 508 || imgIdx == 505 || imgIdx == 433 || imgIdx == 572 || imgIdx == 558 || imgIdx == 528 || imgIdx == 510 || imgIdx == 575 || imgIdx == 577 || imgIdx == 483 || imgIdx == 477 || imgIdx == 474 || imgIdx == 472 || imgIdx == 467 || imgIdx == 245 || imgIdx == 274 || imgIdx == 297 || imgIdx == 340 || imgIdx == 373)
        continue;
    end
    imageCurForRGB = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
    
    
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
    imshow(imageCurForRGB); hold on;
    for k = 1:size(lines,1)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',12.0);
    end
    hold off;
    pause(0.01); refresh(h_RGBwithLines);
    
    
    % save images
    saveImg = getframe(h_RGBwithLines);
    imwrite(saveImg.cdata , sprintf('figures_Ulong/1/%06d.png', imgIdx));
end
%}

%{
%% (2) Gaussian sphere gravity direction

% rotational motion
imgIdx = startAt+1;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;

pNV = pNV_LPIC{imgIdx};
planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
R_gnew_g = [0 0 -1; 1 0 0; 0 -1 0];
pNV = R_gnew_g * pNV_LPIC{imgIdx};


% test first image
h_sphere = figure('Position',[800 150 800 800]); axes('Position',[0 0 1 1]);
plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
if (planeIdx == 1)
    plot_vertical_dominant_direction(pNV, 'r', 0.02);
    plot_vertical_dominant_plane(pNV, 8.0, 'r'); lighting phong; camlight right; hold off;
elseif (planeIdx == 2)
    plot_vertical_dominant_direction(pNV, 'g', 0.02);
    plot_vertical_dominant_plane(pNV, 8.0, 'g'); lighting phong; camlight right; hold off;
elseif (planeIdx == 3)
    plot_vertical_dominant_direction(pNV, 'b', 0.02);
    plot_vertical_dominant_plane(pNV, 8.0, 'b'); lighting phong; camlight right; hold off;
end
set(gcf,'color','w'); axis off; grid off; view(85,15);


for imgIdx = startAt+1:M
    if(imgIdx == 1126 ||imgIdx == 1571 || imgIdx == 1570 || imgIdx == 1626 || imgIdx == 1628 || imgIdx == 508 || imgIdx == 505 || imgIdx == 483 || imgIdx == 477 || imgIdx == 475 || imgIdx == 472 || imgIdx == 467 || imgIdx == 510 || imgIdx == 508 || imgIdx == 505 || imgIdx == 433 || imgIdx == 572 || imgIdx == 558 || imgIdx == 528 || imgIdx == 510 || imgIdx == 575 || imgIdx == 577 || imgIdx == 483 || imgIdx == 477 || imgIdx == 474 || imgIdx == 472 || imgIdx == 467 || imgIdx == 245 || imgIdx == 274 || imgIdx == 297 || imgIdx == 340 || imgIdx == 373)
        continue;
    end
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    pNV = pNV_LPIC{imgIdx};
    if(isempty(pNV))
        continue;
    end
    planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
    pNV = R_gnew_g * pNV_LPIC{imgIdx};
    
    
    % test first image
    cla;
    plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
    if (planeIdx == 1)
        plot_vertical_dominant_direction(pNV, 'r', 0.02);
        plot_vertical_dominant_plane(pNV, 8.0, 'r'); lighting phong; camlight right; hold off;
    elseif (planeIdx == 2)
        plot_vertical_dominant_direction(pNV, 'g', 0.02);
        plot_vertical_dominant_plane(pNV, 8.0, 'g'); lighting phong; camlight right; hold off;
    elseif (planeIdx == 3)
        plot_vertical_dominant_direction(pNV, 'b', 0.02);
        plot_vertical_dominant_plane(pNV, 8.0, 'b'); lighting phong; camlight right; hold off;
    end
    set(gcf,'color','w'); axis off; grid off; view(85,15);
    pause(0.01); refresh(h_sphere);
    
    
    % save images
    saveImg = getframe(h_sphere);
    imwrite(saveImg.cdata , sprintf('figures_Ulong/2/%06d.png', imgIdx));
end

%}

%{
%% (3) Gaussian sphere visual compass

% rotational motion
imgIdx = startAt+1;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;


% test first image
h_sphere = figure('Position',[800 150 800 800]); axes('Position',[0 0 1 1]);
plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
plot_MW_3Darrow(R_cM, 0.80); lighting phong; camlight right; hold off;
set(gcf,'color','w'); axis off; grid off; view(85,15);


for imgIdx = startAt+1:M
    if(imgIdx == 1126 ||imgIdx == 1571 || imgIdx == 1570 || imgIdx == 1626 || imgIdx == 1628 || imgIdx == 508 || imgIdx == 505 || imgIdx == 483 || imgIdx == 477 || imgIdx == 475 || imgIdx == 472 || imgIdx == 467 || imgIdx == 510 || imgIdx == 508 || imgIdx == 505 || imgIdx == 433 || imgIdx == 572 || imgIdx == 558 || imgIdx == 528 || imgIdx == 510 || imgIdx == 575 || imgIdx == 577 || imgIdx == 483 || imgIdx == 477 || imgIdx == 474 || imgIdx == 472 || imgIdx == 467 || imgIdx == 245 || imgIdx == 274 || imgIdx == 297 || imgIdx == 340 || imgIdx == 373)
        continue;
    end
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    if imgIdx == startAt+1
         [state] = initializeVPs(R_cM, optsLPIC);
    else
         [state] = predictVPs(state, optsLPIC);
         [state] = updateVPs(state, R_cM, optsLPIC);
         [state, R_cM] = extractVPs(state);
    end
    
    % test first image
    cla;
    plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
    plot_MW_3Darrow(R_cM, 0.80); lighting phong; camlight right; hold off;
    set(gcf,'color','w'); axis off; grid off; view(85,15);
    pause(0.01); refresh(h_sphere);
    
    
    % save images
    saveImg = getframe(h_sphere);
    imwrite(saveImg.cdata , sprintf('figures_Ulong/3/%06d.png', imgIdx));
end
%}

%{
%% (4) tracked plane

% rotational motion
imgIdx = startAt+1;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;

pNV = pNV_LPIC{imgIdx};
planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(3)));


% read rgb and gray images
imageCurForRGB = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');

optsLPIC.imagePyramidLevel = 2;
imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
[sNV, sPP] = estimateSurfaceNormalGradient(imageCurForMW, depthCurForMW, cam, optsLPIC);

% detect lines and related line normals
[lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, pNV);


% find the MW direction index
numLines = size(lines,1);
lines_labels_true = zeros(numLines,1);
for k = 1:numLines
    
    % find the MW direction
    MW_index = find(abs(90 - rad2deg(acos(lineNormals(:,k).' * R_cM))) <= 5);
    
    % save the MW direction
    if (MW_index == 1)
        lines_labels_true(k) = 1;
    elseif (MW_index == 2)
        lines_labels_true(k) = 2;
    elseif (MW_index == 3)
        lines_labels_true(k) = 3;
    end
end
% test first image

h_camview = figure('Position',[450 200 size(imageCurForRGB,2) size(imageCurForRGB,1)]); axes('Position',[0 0 1 1]);
plot_image_plane_inMW(pNV, planeIdx, sNV, sPP, imageCurForMW, optsLPIC); hold on;      % AlphaData: 0.50
for k = 1:numLines
    if (lines_labels_true(k) == 1)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',6.0);
    elseif (lines_labels_true(k) == 2)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',6.0);
    elseif (lines_labels_true(k) == 3)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',6.0);
    end
end
hold off;


for imgIdx = startAt+1:M

    if(imgIdx == 1126 ||imgIdx == 1571 || imgIdx == 1570 || imgIdx == 1626 || imgIdx == 1628 || imgIdx == 508 || imgIdx == 505 || imgIdx == 483 || imgIdx == 477 || imgIdx == 475 || imgIdx == 472 || imgIdx == 467 || imgIdx == 510 || imgIdx == 508 || imgIdx == 505 || imgIdx == 433 || imgIdx == 572 || imgIdx == 558 || imgIdx == 528 || imgIdx == 510 || imgIdx == 575 || imgIdx == 577 || imgIdx == 483 || imgIdx == 477 || imgIdx == 474 || imgIdx == 472 || imgIdx == 467 || imgIdx == 245 || imgIdx == 274 || imgIdx == 297 || imgIdx == 340 || imgIdx == 373)
        continue;
    end
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    pNV = pNV_LPIC{imgIdx};
    planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
    
    
    % read rgb and gray images
    imageCurForRGB = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
    
    imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
    confiCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'confi');
    depthCurForMW(confiCurForMW == 0 ) = 0;
    depthCurForMW(confiCurForMW == 1 ) = 0;
    [imageCurForMW, depthCurForMW] = getImgPyramid(imageCurForMW, depthCurForMW, optsLPIC.imagePyramidLevel); %%
    [sNV, sPP] = estimateSurfaceNormalGradientforPlot(imageCurForMW, depthCurForMW, cam, optsLPIC);
   
    % detect lines and related line normals
    [lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, pNV);
    
    %{
    % find the MW direction index
    numLines = size(lines,1);
    lines_labels_true = zeros(numLines,1);
    for k = 1:numLines
        
        % find the MW direction
        MW_index = find(abs(90 - rad2deg(acos(lineNormals(:,k).' * R_cM))) <= 5);
        
        % save the MW direction
        if (MW_index == 1)
            lines_labels_true(k) = 1;
        elseif (MW_index == 2)
            lines_labels_true(k) = 2;
        elseif (MW_index == 3)
            lines_labels_true(k) = 3;
        elseif (MW_index == 4)
            lines_labels_true(k) = 3;
        end
    end
    %}
   
    % clustered lines
    cla;
    %plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    %plots_extended_lines_tracking(R_cM, vpInfo_LPIC{imgIdx}, imageCurForLine, cam, optsLPIC);

    %plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    plot_image_plane_inMW(pNV, planeIdx, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    %plots_lines_clustering(R_cM, vpInfo_LPIC{imgIdx}, imageCurForLine, cam, optsLPIC);
    %{
    for k = 1:numLines
        if (lines_labels_true(k) == 1)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',6.0);
        elseif (lines_labels_true(k) == 2)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',6.0);
        elseif (lines_labels_true(k) == 3)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',6.0);
        elseif (lines_labels_true(k) == 4 || lines_labels_true(k) == 5 || lines_labels_true(k) == 6 || lines_labels_true(k) == 7)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'c','LineWidth',6.0);
        end
    end
    %}
    hold off;
    pause(0.01); refresh(h_camview);
    
    
    % save images
    saveImg = getframe(h_camview);
    imwrite(saveImg.cdata , sprintf('figures_Ulong/4/%06d.png', imgIdx));
end

%}

%{
%% (5) camera view with clustered lines

% rotational motion
imgIdx = startAt+1;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;

pNV = pNV_LPIC{imgIdx};
planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(3)));


% read rgb and gray images
imageCurForRGB = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');

optsLPIC.imagePyramidLevel = 2;
imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
[sNV, sPP] = estimateSurfaceNormalGradient(imageCurForMW, depthCurForMW, cam, optsLPIC);

% detect lines and related line normals
[lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, pNV);


% find the MW direction index
numLines = size(lines,1);
lines_labels_true = zeros(numLines,1);
% test first image

h_camview = figure('Position',[450 200 size(imageCurForRGB,2) size(imageCurForRGB,1)]); axes('Position',[0 0 1 1]);
imshow(imageCurForRGB)


for imgIdx = startAt+1:M

    if(imgIdx == 1126 ||imgIdx == 1571 || imgIdx == 1570 || imgIdx == 1626 || imgIdx == 1628 || imgIdx == 508 || imgIdx == 505 || imgIdx == 483 || imgIdx == 477 || imgIdx == 475 || imgIdx == 472 || imgIdx == 467 || imgIdx == 510 || imgIdx == 508 || imgIdx == 505 || imgIdx == 433 || imgIdx == 572 || imgIdx == 558 || imgIdx == 528 || imgIdx == 510 || imgIdx == 575 || imgIdx == 577 || imgIdx == 483 || imgIdx == 477 || imgIdx == 474 || imgIdx == 472 || imgIdx == 467 || imgIdx == 245 || imgIdx == 274 || imgIdx == 297 || imgIdx == 340 || imgIdx == 373)
        continue;
    end
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    pNV = pNV_LPIC{imgIdx};
    planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
    
    
    % read rgb and gray images
    imageCurForRGB = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
    
    imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
    confiCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'confi');
    depthCurForMW(confiCurForMW == 0 ) = 0;
    depthCurForMW(confiCurForMW == 1 ) = 0;
    [imageCurForMW, depthCurForMW] = getImgPyramid(imageCurForMW, depthCurForMW, optsLPIC.imagePyramidLevel); %%
    [sNV, sPP] = estimateSurfaceNormalGradientforPlot(imageCurForMW, depthCurForMW, cam, optsLPIC);
    
  
    % detect lines and related line normals
    [lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, pNV);
    
    %{
    % find the MW direction index
    numLines = size(lines,1);
    lines_labels_true = zeros(numLines,1);
    for k = 1:numLines
        
        % find the MW direction
        MW_index = find(abs(90 - rad2deg(acos(lineNormals(:,k).' * R_cM))) <= 5);
        
        % save the MW direction
        if (MW_index == 1)
            lines_labels_true(k) = 1;
        elseif (MW_index == 2)
            lines_labels_true(k) = 2;
        elseif (MW_index == 3)
            lines_labels_true(k) = 3;
        elseif (MW_index == 4)
            lines_labels_true(k) = 3;
        end
    end
    %}
   
    % clustered lines
    cla;
    imshow(imageCurForRGB); hold on;
    %plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    %plots_extended_lines_tracking(R_cM, vpInfo_LPIC{imgIdx}, imageCurForLine, cam, optsLPIC);
    %plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    %plot_image_plane_inMW(pNV, planeIdx, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    plots_lines_clustering(R_cM, vpInfo_LPIC{imgIdx}, imageCurForLine, cam, optsLPIC);
    %{
    for k = 1:numLines
        if (lines_labels_true(k) == 1)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',6.0);
        elseif (lines_labels_true(k) == 2)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',6.0);
        elseif (lines_labels_true(k) == 3)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',6.0);
        elseif (lines_labels_true(k) == 4 || lines_labels_true(k) == 5 || lines_labels_true(k) == 6 || lines_labels_true(k) == 7)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'c','LineWidth',6.0);
        end
    end
    %}
    hold off;
    pause(0.01); refresh(h_camview);
    
    
    % save images
    saveImg = getframe(h_camview);
    imwrite(saveImg.cdata , sprintf('figures_Ulong/5/%06d.png', imgIdx));
end
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% (1) Rot1
%{
%% (1) camera view with all detected lines


% current RGB image
imgIdx = 1;
imageCurForRGB = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');


% line detection with LSD
lineDetector = optsLPIC.lineDetector;
lineLength = optsLPIC.lineLength;
dimageCurForLine = double(imageCurForLine);
if (strcmp(lineDetector,'lsd'))
    [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
elseif (strcmp(lineDetector,'gpa'))
    [lines, ~] = gpa(imageCurForLine, lineLength);
end
lines = extractUniqueLines(lines, cam);


% test first image
h_RGBwithLines = figure('Position',[650 200 size(imageCurForRGB,2) size(imageCurForRGB,1)]); axes('Position',[0 0 1 1]);
imshow(imageCurForRGB,[]); hold on;
for k = 1:size(lines,1)
    plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',6.0);
end
hold off;


for imgIdx = startAt:M
    if(imgIdx == 1081 || imgIdx == 2876) %L1 1
        continue;
    end
    % current RGB image
    imageCurForRGB = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
    
    
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
    imshow(imageCurForRGB); hold on;
    for k = 1:size(lines,1)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',12.0);
    end
    hold off;
    pause(0.01); refresh(h_RGBwithLines);
    
    
    % save images
    saveImg = getframe(h_RGBwithLines);
    imwrite(saveImg.cdata , sprintf('figures_Llong/1/%06d.png', imgIdx));
end
%}

%% (2) Gaussian sphere gravity direction
%{
% rotational motion
imgIdx = startAt+1;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;

pNV = pNV_LPIC{imgIdx};
planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
R_gnew_g = [0 0 -1; 1 0 0; 0 -1 0];
pNV = R_gnew_g * pNV_LPIC{imgIdx};


% test first image
h_sphere = figure('Position',[800 150 800 800]); axes('Position',[0 0 1 1]);
plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
if (planeIdx == 1)
    plot_vertical_dominant_direction(pNV, 'r', 0.02);
    plot_vertical_dominant_plane(pNV, 8.0, 'r'); lighting phong; camlight right; hold off;
elseif (planeIdx == 2)
    plot_vertical_dominant_direction(pNV, 'g', 0.02);
    plot_vertical_dominant_plane(pNV, 8.0, 'g'); lighting phong; camlight right; hold off;
elseif (planeIdx == 3)
    plot_vertical_dominant_direction(pNV, 'b', 0.02);
    plot_vertical_dominant_plane(pNV, 8.0, 'b'); lighting phong; camlight right; hold off;
end
set(gcf,'color','w'); axis off; grid off; view(85,15);


for imgIdx = startAt+1:M
    if(imgIdx == 1081 || imgIdx == 2876) %L1 1
        continue;
    end
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    pNV = pNV_LPIC{imgIdx};
    if(isempty(pNV))
        continue;
    end
    planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
    pNV = R_gnew_g * pNV_LPIC{imgIdx};
    
    
    % test first image
    cla;
    plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
    if (planeIdx == 1)
        plot_vertical_dominant_direction(pNV, 'r', 0.02);
        plot_vertical_dominant_plane(pNV, 8.0, 'r'); lighting phong; camlight right; hold off;
    elseif (planeIdx == 2)
        plot_vertical_dominant_direction(pNV, 'g', 0.02);
        plot_vertical_dominant_plane(pNV, 8.0, 'g'); lighting phong; camlight right; hold off;
    elseif (planeIdx == 3)
        plot_vertical_dominant_direction(pNV, 'b', 0.02);
        plot_vertical_dominant_plane(pNV, 8.0, 'b'); lighting phong; camlight right; hold off;
    end
    set(gcf,'color','w'); axis off; grid off; view(85,15);
    pause(0.01); refresh(h_sphere);
    
    
    % save images
    saveImg = getframe(h_sphere);
    imwrite(saveImg.cdata , sprintf('figures_Llong/2/%06d.png', imgIdx));
end

%}


%% (3) Gaussian sphere visual compass
%{
% rotational motion
imgIdx = 2;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;


% test first image
h_sphere = figure('Position',[800 150 800 800]); axes('Position',[0 0 1 1]);
plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
plot_MW_3Darrow(R_cM, 0.80); lighting phong; camlight right; hold off;
set(gcf,'color','w'); axis off; grid off; view(85,15);


for imgIdx = startAt+1:M
    if(imgIdx == 1081 || imgIdx == 2876) %L1 1
        continue;
    end
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    if imgIdx == startAt+1
         [state] = initializeVPs(R_cM, optsLPIC);
    else
         [state] = predictVPs(state, optsLPIC);
         [state] = updateVPs(state, R_cM, optsLPIC);
         [state, R_cM] = extractVPs(state);
    end
    
    % test first image
    cla;
    plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
    plot_MW_3Darrow(R_cM, 0.80); lighting phong; camlight right; hold off;
    set(gcf,'color','w'); axis off; grid off; view(85,15);
    pause(0.01); refresh(h_sphere);
    
    
    % save images
    saveImg = getframe(h_sphere);
    imwrite(saveImg.cdata , sprintf('figures_Llong/3/%06d.png', imgIdx));
end

%}

%% (4) tracked plane
%{
% rotational motion
imgIdx = startAt+1;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;

pNV = pNV_LPIC{imgIdx};
planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(3)));


% read rgb and gray images
imageCurForRGB = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');

optsLPIC.imagePyramidLevel = 2;
imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
[sNV, sPP] = estimateSurfaceNormalGradient(imageCurForMW, depthCurForMW, cam, optsLPIC);

% detect lines and related line normals
[lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, pNV);


% find the MW direction index
numLines = size(lines,1);
lines_labels_true = zeros(numLines,1);
for k = 1:numLines
    
    % find the MW direction
    MW_index = find(abs(90 - rad2deg(acos(lineNormals(:,k).' * R_cM))) <= 5);
    
    % save the MW direction
    if (MW_index == 1)
        lines_labels_true(k) = 1;
    elseif (MW_index == 2)
        lines_labels_true(k) = 2;
    elseif (MW_index == 3)
        lines_labels_true(k) = 3;
    end
end
% test first image

h_camview = figure('Position',[450 200 size(imageCurForRGB,2) size(imageCurForRGB,1)]); axes('Position',[0 0 1 1]);
plot_image_plane_inMW(pNV, planeIdx, sNV, sPP, imageCurForMW, optsLPIC); hold on;      % AlphaData: 0.50
for k = 1:numLines
    if (lines_labels_true(k) == 1)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',6.0);
    elseif (lines_labels_true(k) == 2)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',6.0);
    elseif (lines_labels_true(k) == 3)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',6.0);
    end
end
hold off;


for imgIdx = startAt+1:M

    if(imgIdx == 1081 || imgIdx == 2876) %L1 1
        continue;
    end
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    pNV = pNV_LPIC{imgIdx};
    planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
    
    
    % read rgb and gray images
    imageCurForRGB = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
    
    imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
    confiCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'confi');
    depthCurForMW(confiCurForMW == 0 ) = 0;
    depthCurForMW(confiCurForMW == 1 ) = 0;
    [imageCurForMW, depthCurForMW] = getImgPyramid(imageCurForMW, depthCurForMW, optsLPIC.imagePyramidLevel); %%
    [sNV, sPP] = estimateSurfaceNormalGradientforPlot(imageCurForMW, depthCurForMW, cam, optsLPIC);
   
    % detect lines and related line normals
    [lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, pNV);
    
    %{
    % find the MW direction index
    numLines = size(lines,1);
    lines_labels_true = zeros(numLines,1);
    for k = 1:numLines
        
        % find the MW direction
        MW_index = find(abs(90 - rad2deg(acos(lineNormals(:,k).' * R_cM))) <= 5);
        
        % save the MW direction
        if (MW_index == 1)
            lines_labels_true(k) = 1;
        elseif (MW_index == 2)
            lines_labels_true(k) = 2;
        elseif (MW_index == 3)
            lines_labels_true(k) = 3;
        elseif (MW_index == 4)
            lines_labels_true(k) = 3;
        end
    end
    %}
   
    % clustered lines
    cla;
    %plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    %plots_extended_lines_tracking(R_cM, vpInfo_LPIC{imgIdx}, imageCurForLine, cam, optsLPIC);

    %plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    plot_image_plane_inMW(pNV, planeIdx, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    %plots_lines_clustering(R_cM, vpInfo_LPIC{imgIdx}, imageCurForLine, cam, optsLPIC);
    %{
    for k = 1:numLines
        if (lines_labels_true(k) == 1)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',6.0);
        elseif (lines_labels_true(k) == 2)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',6.0);
        elseif (lines_labels_true(k) == 3)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',6.0);
        elseif (lines_labels_true(k) == 4 || lines_labels_true(k) == 5 || lines_labels_true(k) == 6 || lines_labels_true(k) == 7)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'c','LineWidth',6.0);
        end
    end
    %}
    hold off;
    pause(0.01); refresh(h_camview);
    
    
    % save images
    saveImg = getframe(h_camview);
    imwrite(saveImg.cdata , sprintf('figures_Llong/4/%06d.png', imgIdx));
end
%}



%% (5) camera view with clustered lines

% rotational motion
imgIdx = startAt+1;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;

pNV = pNV_LPIC{imgIdx};
planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(3)));


% read rgb and gray images
imageCurForRGB = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');

optsLPIC.imagePyramidLevel = 2;
imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
[sNV, sPP] = estimateSurfaceNormalGradient(imageCurForMW, depthCurForMW, cam, optsLPIC);

% detect lines and related line normals
[lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, pNV);


% find the MW direction index
numLines = size(lines,1);
lines_labels_true = zeros(numLines,1);
% test first image

h_camview = figure('Position',[450 200 size(imageCurForRGB,2) size(imageCurForRGB,1)]); axes('Position',[0 0 1 1]);
imshow(imageCurForRGB)


for imgIdx = startAt+1:M

    if(imgIdx == 1081 || imgIdx == 2876) %L1 1
        continue;
    end
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    pNV = pNV_LPIC{imgIdx};
    planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
    
    
    % read rgb and gray images
    imageCurForRGB = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
    
    imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
    confiCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'confi');
    depthCurForMW(confiCurForMW == 0 ) = 0;
    depthCurForMW(confiCurForMW == 1 ) = 0;
    [imageCurForMW, depthCurForMW] = getImgPyramid(imageCurForMW, depthCurForMW, optsLPIC.imagePyramidLevel); %%
    [sNV, sPP] = estimateSurfaceNormalGradientforPlot(imageCurForMW, depthCurForMW, cam, optsLPIC);
    
  
    % detect lines and related line normals
    [lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, pNV);
    
    %{
    % find the MW direction index
    numLines = size(lines,1);
    lines_labels_true = zeros(numLines,1);
    for k = 1:numLines
        
        % find the MW direction
        MW_index = find(abs(90 - rad2deg(acos(lineNormals(:,k).' * R_cM))) <= 5);
        
        % save the MW direction
        if (MW_index == 1)
            lines_labels_true(k) = 1;
        elseif (MW_index == 2)
            lines_labels_true(k) = 2;
        elseif (MW_index == 3)
            lines_labels_true(k) = 3;
        elseif (MW_index == 4)
            lines_labels_true(k) = 3;
        end
    end
    %}
   
    % clustered lines
    cla;
    imshow(imageCurForRGB); hold on;
    %plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    %plots_extended_lines_tracking(R_cM, vpInfo_LPIC{imgIdx}, imageCurForLine, cam, optsLPIC);
    %plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    %plot_image_plane_inMW(pNV, planeIdx, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    plots_lines_clustering(R_cM, vpInfo_LPIC{imgIdx}, imageCurForLine, cam, optsLPIC);
    %{
    for k = 1:numLines
        if (lines_labels_true(k) == 1)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',6.0);
        elseif (lines_labels_true(k) == 2)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',6.0);
        elseif (lines_labels_true(k) == 3)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',6.0);
        elseif (lines_labels_true(k) == 4 || lines_labels_true(k) == 5 || lines_labels_true(k) == 6 || lines_labels_true(k) == 7)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'c','LineWidth',6.0);
        end
    end
    %}
    hold off;
    pause(0.01); refresh(h_camview);
    
    
    % save images
    saveImg = getframe(h_camview);
    imwrite(saveImg.cdata , sprintf('figures_Llong/5/%06d.png', imgIdx));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%{
%% (1) Rot1

%% (1) camera view with all detected lines

% current RGB image
imgIdx = 1;
imageCurForRGB = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');


% line detection with LSD
lineDetector = optsLPIC.lineDetector;
lineLength = optsLPIC.lineLength;
dimageCurForLine = double(imageCurForLine);
if (strcmp(lineDetector,'lsd'))
    [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
elseif (strcmp(lineDetector,'gpa'))
    [lines, ~] = gpa(imageCurForLine, lineLength);
end
lines = extractUniqueLines(lines, cam);


% test first image
h_RGBwithLines = figure('Position',[650 200 size(imageCurForRGB,2) size(imageCurForRGB,1)]); axes('Position',[0 0 1 1]);
imshow(imageCurForRGB,[]); hold on;
for k = 1:size(lines,1)
    plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',6.0);
end
hold off;


for imgIdx = startAt:M
    if(imgIdx == 848) %L1 1
        continue;
    end
    % current RGB image
    imageCurForRGB = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
    
    
    % line detection
    dimageCurForLine = double(imageCurForLine);
    if (strcmp(lineDetector,'lsd'))
        [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
    elseif (strcmp(lineDetector,'gpa'))
        [lines, ~] = gpa(imageCurForLine, lineLength);
    end

    if(isempty(lines))
        continue;
    end
    lines = extractUniqueLines(lines, cam);
    
    
    % all detected lines
    cla;
    imshow(imageCurForRGB); hold on;
    for k = 1:size(lines,1)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',12.0);
    end
    hold off;
    pause(0.01); refresh(h_RGBwithLines);
    
    
    % save images
    saveImg = getframe(h_RGBwithLines);
    imwrite(saveImg.cdata , sprintf('figures_Rot/1/%06d.png', imgIdx));
end




%% (2) Gaussian sphere gravity direction

% rotational motion
imgIdx = startAt+1;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;

pNV = pNV_LPIC{imgIdx};
planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
R_gnew_g = [0 0 -1; 1 0 0; 0 -1 0];
pNV = R_gnew_g * pNV_LPIC{imgIdx};


% test first image
h_sphere = figure('Position',[800 150 800 800]); axes('Position',[0 0 1 1]);
plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
if (planeIdx == 1)
    plot_vertical_dominant_direction(pNV, 'r', 0.02);
    plot_vertical_dominant_plane(pNV, 8.0, 'r'); lighting phong; camlight right; hold off;
elseif (planeIdx == 2)
    plot_vertical_dominant_direction(pNV, 'g', 0.02);
    plot_vertical_dominant_plane(pNV, 8.0, 'g'); lighting phong; camlight right; hold off;
elseif (planeIdx == 3)
    plot_vertical_dominant_direction(pNV, 'b', 0.02);
    plot_vertical_dominant_plane(pNV, 8.0, 'b'); lighting phong; camlight right; hold off;
end
set(gcf,'color','w'); axis off; grid off; view(85,15);


for imgIdx = startAt+1:M
    if(imgIdx == 245 || imgIdx == 274)
        continue;
    end
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    pNV = pNV_LPIC{imgIdx};
    if(isempty(pNV))
        continue;
    end
    planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
    pNV = R_gnew_g * pNV_LPIC{imgIdx};
    
    
    % test first image
    cla;
    plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
    if (planeIdx == 1)
        plot_vertical_dominant_direction(pNV, 'r', 0.02);
        plot_vertical_dominant_plane(pNV, 8.0, 'r'); lighting phong; camlight right; hold off;
    elseif (planeIdx == 2)
        plot_vertical_dominant_direction(pNV, 'g', 0.02);
        plot_vertical_dominant_plane(pNV, 8.0, 'g'); lighting phong; camlight right; hold off;
    elseif (planeIdx == 3)
        plot_vertical_dominant_direction(pNV, 'b', 0.02);
        plot_vertical_dominant_plane(pNV, 8.0, 'b'); lighting phong; camlight right; hold off;
    end
    set(gcf,'color','w'); axis off; grid off; view(85,15);
    pause(0.01); refresh(h_sphere);
    
    
    % save images
    saveImg = getframe(h_sphere);
    imwrite(saveImg.cdata , sprintf('figures_Rot/2/%06d.png', imgIdx));
end
%}


%% (3) Gaussian sphere visual compass

% rotational motion
imgIdx = 2;
startAt = 81;
state = [];
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;


% test first image
h_sphere = figure('Position',[800 150 800 800]); axes('Position',[0 0 1 1]);
plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
plot_MW_3Darrow(R_cM, 0.80); lighting phong; camlight right; hold off;
set(gcf,'color','w'); axis off; grid off; view(85,15);


for imgIdx = startAt:M
    % rotational motion
    if(isempty(pNV_LPIC{imgIdx}))
        continue;
    end
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    if imgIdx == startAt
         [state] = initializeVPs(R_cM, optsLPIC);
    else
         [state] = predictVPs(state, optsLPIC);
         [state] = updateVPs(state, R_cM, optsLPIC);
         [state, R_cM] = extractVPs(state);
    end
    
    % test first image
    cla;
    plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
    plot_MW_3Darrow(R_cM, 0.80); lighting phong; camlight right; hold off;
    set(gcf,'color','w'); axis off; grid off; view(85,15);
    pause(0.01); refresh(h_sphere);
    
    
    % save images
    saveImg = getframe(h_sphere);
    imwrite(saveImg.cdata , sprintf('figures_Rot/3/%06d.png', imgIdx));
end





%% (4) tracked plane
%{
% rotational motion
imgIdx = startAt+1;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;


pNV = pNV_LPIC{imgIdx};

planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(3)));


% read rgb and gray images
imageCurForRGB = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');

optsLPIC.imagePyramidLevel = 2;
imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
[sNV, sPP] = estimateSurfaceNormalGradient(imageCurForMW, depthCurForMW, cam, optsLPIC);

% detect lines and related line normals
[lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, pNV);


% find the MW direction index
numLines = size(lines,1);
lines_labels_true = zeros(numLines,1);
for k = 1:numLines
    
    % find the MW direction
    MW_index = find(abs(90 - rad2deg(acos(lineNormals(:,k).' * R_cM))) <= 5);
    
    % save the MW direction
    if (MW_index == 1)
        lines_labels_true(k) = 1;
    elseif (MW_index == 2)
        lines_labels_true(k) = 2;
    elseif (MW_index == 3)
        lines_labels_true(k) = 3;
    end
end
% test first image

h_camview = figure('Position',[450 200 size(imageCurForRGB,2) size(imageCurForRGB,1)]); axes('Position',[0 0 1 1]);
plot_image_plane_inMW(pNV, planeIdx, sNV, sPP, imageCurForMW, optsLPIC); hold on;      % AlphaData: 0.50
for k = 1:numLines
    if (lines_labels_true(k) == 1)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',6.0);
    elseif (lines_labels_true(k) == 2)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',6.0);
    elseif (lines_labels_true(k) == 3)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',6.0);
    end
end
hold off;


for imgIdx = startAt+1:M

    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    pNV = pNV_LPIC{imgIdx};
    if(isempty(pNV))
      continue;
    end
    planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
    
    
    % read rgb and gray images
    imageCurForRGB = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
    
    imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
    confiCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'confi');
    depthCurForMW(confiCurForMW == 0 ) = 0;
    depthCurForMW(confiCurForMW == 1 ) = 0;
    [imageCurForMW, depthCurForMW] = getImgPyramid(imageCurForMW, depthCurForMW, optsLPIC.imagePyramidLevel); %%
    [sNV, sPP] = estimateSurfaceNormalGradientforPlot(imageCurForMW, depthCurForMW, cam, optsLPIC);
    
    % detect lines and related line normals
    [lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, pNV);
    
    %{
    % find the MW direction index
    numLines = size(lines,1);
    lines_labels_true = zeros(numLines,1);
    for k = 1:numLines
        
        % find the MW direction
        MW_index = find(abs(90 - rad2deg(acos(lineNormals(:,k).' * R_cM))) <= 5);
        
        % save the MW direction
        if (MW_index == 1)
            lines_labels_true(k) = 1;
        elseif (MW_index == 2)
            lines_labels_true(k) = 2;
        elseif (MW_index == 3)
            lines_labels_true(k) = 3;
        elseif (MW_index == 4)
            lines_labels_true(k) = 3;
        end
    end
    %}
   
    % clustered lines
    cla;
    %plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    %plots_extended_lines_tracking(R_cM, vpInfo_LPIC{imgIdx}, imageCurForLine, cam, optsLPIC);

    %plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    plot_image_plane_inMW(pNV, planeIdx, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    %plots_lines_clustering(R_cM, vpInfo_LPIC{imgIdx}, imageCurForLine, cam, optsLPIC);
    %{
    for k = 1:numLines
        if (lines_labels_true(k) == 1)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',6.0);
        elseif (lines_labels_true(k) == 2)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',6.0);
        elseif (lines_labels_true(k) == 3)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',6.0);
        elseif (lines_labels_true(k) == 4 || lines_labels_true(k) == 5 || lines_labels_true(k) == 6 || lines_labels_true(k) == 7)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'c','LineWidth',6.0);
        end
    end
    %}
    hold off;
    pause(0.01); refresh(h_camview);
    
    
    % save images
    saveImg = getframe(h_camview);
    imwrite(saveImg.cdata , sprintf('figures_Rot/4/%06d.png', imgIdx));
end
%}

%% (5) camera view with clustered lines
%{
% rotational motion
imgIdx = startAt+1;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;

pNV = pNV_LPIC{imgIdx};
planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(3)));


% read rgb and gray images
imageCurForRGB = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');

optsLPIC.imagePyramidLevel = 2;
imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
[sNV, sPP] = estimateSurfaceNormalGradient(imageCurForMW, depthCurForMW, cam, optsLPIC);

% detect lines and related line normals
[lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, pNV);


% find the MW direction index
numLines = size(lines,1);
lines_labels_true = zeros(numLines,1);
% test first image

h_camview = figure('Position',[450 200 size(imageCurForRGB,2) size(imageCurForRGB,1)]); axes('Position',[0 0 1 1]);
imshow(imageCurForRGB)


for imgIdx = startAt+1:M

    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    pNV = pNV_LPIC{imgIdx};
    if(isempty(pNV))
        continue;
    end
    planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
    
    
    % read rgb and gray images
    imageCurForRGB = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
    
    imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
    confiCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'confi');
    depthCurForMW(confiCurForMW == 0 ) = 0;
    depthCurForMW(confiCurForMW == 1 ) = 0;
    [imageCurForMW, depthCurForMW] = getImgPyramid(imageCurForMW, depthCurForMW, optsLPIC.imagePyramidLevel); %%
    [sNV, sPP] = estimateSurfaceNormalGradientforPlot(imageCurForMW, depthCurForMW, cam, optsLPIC);
    
  
    % detect lines and related line normals
    [lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, pNV);
    
    %{
    % find the MW direction index
    numLines = size(lines,1);
    lines_labels_true = zeros(numLines,1);
    for k = 1:numLines
        
        % find the MW direction
        MW_index = find(abs(90 - rad2deg(acos(lineNormals(:,k).' * R_cM))) <= 5);
        
        % save the MW direction
        if (MW_index == 1)
            lines_labels_true(k) = 1;
        elseif (MW_index == 2)
            lines_labels_true(k) = 2;
        elseif (MW_index == 3)
            lines_labels_true(k) = 3;
        elseif (MW_index == 4)
            lines_labels_true(k) = 3;
        end
    end
    %}
   
    % clustered lines
    cla;
    imshow(imageCurForRGB); hold on;
    %plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    %plots_extended_lines_tracking(R_cM, vpInfo_LPIC{imgIdx}, imageCurForLine, cam, optsLPIC);
    %plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    %plot_image_plane_inMW(pNV, planeIdx, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    plots_lines_clustering(R_cM, vpInfo_LPIC{imgIdx}, imageCurForLine, cam, optsLPIC);
    %{
    for k = 1:numLines
        if (lines_labels_true(k) == 1)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',6.0);
        elseif (lines_labels_true(k) == 2)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',6.0);
        elseif (lines_labels_true(k) == 3)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',6.0);
        elseif (lines_labels_true(k) == 4 || lines_labels_true(k) == 5 || lines_labels_true(k) == 6 || lines_labels_true(k) == 7)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'c','LineWidth',6.0);
        end
    end
    %}
    hold off;
    pause(0.01); refresh(h_camview);
    
    
    % save images
    saveImg = getframe(h_camview);
    imwrite(saveImg.cdata , sprintf('figures_Rot/5/%06d.png', imgIdx));
end

%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}

%% (1) camera view with all detected lines

% current RGB image
imgIdx = 1;
imageCurForRGB = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');


% line detection with LSD
lineDetector = optsLPIC.lineDetector;
lineLength = optsLPIC.lineLength;
dimageCurForLine = double(imageCurForLine);
if (strcmp(lineDetector,'lsd'))
    [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
elseif (strcmp(lineDetector,'gpa'))
    [lines, ~] = gpa(imageCurForLine, lineLength);
end
lines = extractUniqueLines(lines, cam);


% test first image
h_RGBwithLines = figure('Position',[650 200 size(imageCurForRGB,2) size(imageCurForRGB,1)]); axes('Position',[0 0 1 1]);
imshow(imageCurForRGB,[]); hold on;
for k = 1:size(lines,1)
    plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',6.0);
end
hold off;


for imgIdx = 27:M
    %if(imgIdx == 1081 || imgIdx == 2876) L1 1
    if(imgIdx == 126 || imgIdx == 141 || imgIdx == 143 || imgIdx == 145 || imgIdx == 147 || imgIdx == 149 || imgIdx == 151 || imgIdx == 153 || imgIdx == 155  || imgIdx == 157  || imgIdx == 159 || imgIdx == 160 || imgIdx == 161 || imgIdx == 163  || imgIdx == 166 || imgIdx == 167 || imgIdx == 168 || imgIdx == 169 || imgIdx == 170 || imgIdx == 171 || imgIdx == 172 || imgIdx == 174 || imgIdx == 175 || imgIdx == 177 || imgIdx == 178 || imgIdx == 180 || imgIdx == 184 || imgIdx == 186 || imgIdx == 192 || imgIdx == 373 || imgIdx == 385 || imgIdx == 388)
        continue;
    end
    % current RGB image
    imageCurForRGB = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
    
    
    % line detection
    dimageCurForLine = double(imageCurForLine);
    if (strcmp(lineDetector,'lsd'))
        [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
    elseif (strcmp(lineDetector,'gpa'))
        [lines, ~] = gpa(imageCurForLine, lineLength);
    end

     if(imgIdx == 27)
    newRow = [6.18261376896066 1349.60501750292 727.871353558927 1245.53821470245 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 144)
    newRow = [823.810676779463	1361.10997666278 1154.62164527421	702.209159859977 0 0 0;
                1439.37981330222	522.226954492415  1899.77654609102	530.628354725787 0 0 0]; %L1 2
    lines(end+1:end+2, :) = newRow;
    end
    if(imgIdx == 146)
    newRow = [830.728996499417	1341.83109684948 1147.01108518086	713.778879813302 0 0 0;
1402.92561260210	522.476954492415 1913.88710618436	532.238914819136 0 0 0]; %L1 2
    lines(end+1:end+2, :) = newRow;
    end
    if(imgIdx == 148)
    newRow = [831.269836639440	1352.69165694282 1165.38360560093	686.824679113185 0 0 0;
1180.61668611435	663.370478413069 1343.60385064177	612.962077012835 0 0 0]; %L1 2
    lines(end+1:end+2, :) = newRow;
    end
    if(imgIdx == 150)
    newRow = [831.269836639440	1352.69165694282 1165.38360560093	686.824679113185 0 0 0;
1180.61668611435	663.370478413069 1343.60385064177	612.962077012835 0 0 0]; %L1 2
    lines(end+1:end+2, :) = newRow;
    end
    if(imgIdx == 152)
    newRow = [885.759918319720	1340.12689614936 1160.91248541424	759.588681446908 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 154)
    newRow = [1149.02304550758	816.321761960327  884.411318553092	1387.56417736289 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 156)
    newRow = [876.452158693115	1431.20361726955  1143.22024504084	842.590723453909 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 160)
    newRow = [876.038798133022	1376.23249708285  1120.97520420070	823.311843640607 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 167)
    newRow = [814.967036172696	1434.82817969662  1050.38652275379	878.352683780630 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 169)
    newRow = [811.676196032672	1425.21761960327  1028.74008168028	906.203325554259 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end


    lines = extractUniqueLines(lines, cam);
    
    
    % all detected lines
    cla;
    imshow(imageCurForRGB); hold on;
    for k = 1:size(lines,1)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',12.0);
    end
    hold off;
    pause(0.01); refresh(h_RGBwithLines);
    
    
    % save images
    saveImg = getframe(h_RGBwithLines);
    imwrite(saveImg.cdata , sprintf('figures_Lshort/1/%06d.png', imgIdx));
end



%{
%% (2) Gaussian sphere gravity direction

% rotational motion
imgIdx = 28;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;

pNV = pNV_LPIC{imgIdx};
planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
R_gnew_g = [0 0 -1; 1 0 0; 0 -1 0];
pNV = R_gnew_g * pNV_LPIC{imgIdx};


% test first image
h_sphere = figure('Position',[800 150 800 800]); axes('Position',[0 0 1 1]);
plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
if (planeIdx == 1)
    plot_vertical_dominant_direction(pNV, 'r', 0.02);
    plot_vertical_dominant_plane(pNV, 8.0, 'r'); lighting phong; camlight right; hold off;
elseif (planeIdx == 2)
    plot_vertical_dominant_direction(pNV, 'g', 0.02);
    plot_vertical_dominant_plane(pNV, 8.0, 'g'); lighting phong; camlight right; hold off;
elseif (planeIdx == 3)
    plot_vertical_dominant_direction(pNV, 'b', 0.02);
    plot_vertical_dominant_plane(pNV, 8.0, 'b'); lighting phong; camlight right; hold off;
end
set(gcf,'color','w'); axis off; grid off; view(85,15);


for imgIdx = startAt+1:M
    if(imgIdx == 126 || imgIdx == 141 || imgIdx == 143 || imgIdx == 145 || imgIdx == 147 || imgIdx == 149 || imgIdx == 151 || imgIdx == 153 || imgIdx == 155  || imgIdx == 157  || imgIdx == 159 || imgIdx == 160 || imgIdx == 161 || imgIdx == 163  || imgIdx == 166 || imgIdx == 167 || imgIdx == 168 || imgIdx == 169 || imgIdx == 170 || imgIdx == 171 || imgIdx == 172 || imgIdx == 174 || imgIdx == 175 || imgIdx == 177 || imgIdx == 178 || imgIdx == 180 || imgIdx == 184 || imgIdx == 186 || imgIdx == 192 || imgIdx == 373 || imgIdx == 385 || imgIdx == 388)
        continue;
    end
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    pNV = pNV_LPIC{imgIdx};
    planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
    pNV = R_gnew_g * pNV_LPIC{imgIdx};
    
    
    % test first image
    cla;
    plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
    if (planeIdx == 1)
        plot_vertical_dominant_direction(pNV, 'r', 0.02);
        plot_vertical_dominant_plane(pNV, 8.0, 'r'); lighting phong; camlight right; hold off;
    elseif (planeIdx == 2)
        plot_vertical_dominant_direction(pNV, 'g', 0.02);
        plot_vertical_dominant_plane(pNV, 8.0, 'g'); lighting phong; camlight right; hold off;
    elseif (planeIdx == 3)
        plot_vertical_dominant_direction(pNV, 'b', 0.02);
        plot_vertical_dominant_plane(pNV, 8.0, 'b'); lighting phong; camlight right; hold off;
    end
    set(gcf,'color','w'); axis off; grid off; view(85,15);
    pause(0.01); refresh(h_sphere);
    
    
    % save images
    saveImg = getframe(h_sphere);
    imwrite(saveImg.cdata , sprintf('figures_Llong/2/%06d.png', imgIdx));
end

%}


%% (3) Gaussian sphere visual compass

% rotational motion
imgIdx = 2;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;


% test first image
h_sphere = figure('Position',[800 150 800 800]); axes('Position',[0 0 1 1]);
plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
plot_MW_3Darrow(R_cM, 0.80); lighting phong; camlight right; hold off;
set(gcf,'color','w'); axis off; grid off; view(85,15);


for imgIdx = startAt:M
    %if(imgIdx == 1081 || imgIdx == 2876) L1 1
    if(imgIdx == 126 || imgIdx == 141 || imgIdx == 143 || imgIdx == 145 || imgIdx == 147 || imgIdx == 149 || imgIdx == 151 || imgIdx == 153 || imgIdx == 155  || imgIdx == 157  || imgIdx == 159 || imgIdx == 160 || imgIdx == 161 || imgIdx == 163  || imgIdx == 166 || imgIdx == 167 || imgIdx == 168 || imgIdx == 169 || imgIdx == 170 || imgIdx == 171 || imgIdx == 172 || imgIdx == 174 || imgIdx == 175 || imgIdx == 177 || imgIdx == 178 || imgIdx == 180 || imgIdx == 184 || imgIdx == 186 || imgIdx == 192 || imgIdx == 373 || imgIdx == 385 || imgIdx == 388)
        continue;
    end
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    
    % test first image
    cla;
    plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
    plot_MW_3Darrow(R_cM, 0.80); lighting phong; camlight right; hold off;
    set(gcf,'color','w'); axis off; grid off; view(85,15);
    pause(0.01); refresh(h_sphere);
    
    
    % save images
    saveImg = getframe(h_sphere);
    imwrite(saveImg.cdata , sprintf('figures_Llong/3/%06d.png', imgIdx));
end



%% (4) tracked plane

% rotational motion
imgIdx = 28;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;

pNV = pNV_LPIC{imgIdx};
planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(3)));


% read rgb and gray images
imageCurForRGB = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');

optsLPIC.imagePyramidLevel = 2;
imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
[sNV, sPP] = estimateSurfaceNormalGradient(imageCurForMW, depthCurForMW, cam, optsLPIC);

% detect lines and related line normals
[lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, pNV);


% find the MW direction index
numLines = size(lines,1);
lines_labels_true = zeros(numLines,1);
for k = 1:numLines
    
    % find the MW direction
    MW_index = find(abs(90 - rad2deg(acos(lineNormals(:,k).' * R_cM))) <= 5);
    
    % save the MW direction
    if (MW_index == 1)
        lines_labels_true(k) = 1;
    elseif (MW_index == 2)
        lines_labels_true(k) = 2;
    elseif (MW_index == 3)
        lines_labels_true(k) = 3;
    end
end
% test first image

h_camview = figure('Position',[450 200 size(imageCurForRGB,2) size(imageCurForRGB,1)]); axes('Position',[0 0 1 1]);
plot_image_plane_inMW(pNV, planeIdx, sNV, sPP, imageCurForMW, optsLPIC); hold on;      % AlphaData: 0.50
for k = 1:numLines
    if (lines_labels_true(k) == 1)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',6.0);
    elseif (lines_labels_true(k) == 2)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',6.0);
    elseif (lines_labels_true(k) == 3)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',6.0);
    end
end
hold off;


for imgIdx = startAt+1:M

    if(imgIdx == 126 || imgIdx == 141 || imgIdx == 143 || imgIdx == 145 || imgIdx == 147 || imgIdx == 149 || imgIdx == 151 || imgIdx == 153 || imgIdx == 155  || imgIdx == 157  || imgIdx == 159 || imgIdx == 160 || imgIdx == 161 || imgIdx == 163  || imgIdx == 166 || imgIdx == 167 || imgIdx == 168 || imgIdx == 169 || imgIdx == 170 || imgIdx == 171 || imgIdx == 172 || imgIdx == 174 || imgIdx == 175 || imgIdx == 177 || imgIdx == 178 || imgIdx == 180 || imgIdx == 184 || imgIdx == 186 || imgIdx == 192 || imgIdx == 373 || imgIdx == 385 || imgIdx == 388)
        continue;
    end
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    pNV = pNV_LPIC{imgIdx};
    planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
    
    
    % read rgb and gray images
    imageCurForRGB = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
    
    imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
    confiCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'confi');
    depthCurForMW(confiCurForMW == 0 ) = 0;
    depthCurForMW(confiCurForMW == 1 ) = 0;
    [imageCurForMW, depthCurForMW] = getImgPyramid(imageCurForMW, depthCurForMW, optsLPIC.imagePyramidLevel); %%
    [sNV, sPP] = estimateSurfaceNormalGradientforPlot(imageCurForMW, depthCurForMW, cam, optsLPIC);
    
    if(imgIdx == 27)
    newRow = [6.18261376896066 1349.60501750292 727.871353558927 1245.53821470245 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 144)
    newRow = [823.810676779463	1361.10997666278 1154.62164527421	702.209159859977 0 0 0;
                1439.37981330222	522.226954492415  1899.77654609102	530.628354725787 0 0 0]; %L1 2
    lines(end+1:end+2, :) = newRow;
    end
    if(imgIdx == 146)
    newRow = [830.728996499417	1341.83109684948 1147.01108518086	713.778879813302 0 0 0;
1402.92561260210	522.476954492415 1913.88710618436	532.238914819136 0 0 0]; %L1 2
    lines(end+1:end+2, :) = newRow;
    end
    if(imgIdx == 148)
    newRow = [831.269836639440	1352.69165694282 1165.38360560093	686.824679113185 0 0 0;
1180.61668611435	663.370478413069 1343.60385064177	612.962077012835 0 0 0]; %L1 2
    lines(end+1:end+2, :) = newRow;
    end
    if(imgIdx == 150)
    newRow = [831.269836639440	1352.69165694282 1165.38360560093	686.824679113185 0 0 0;
1180.61668611435	663.370478413069 1343.60385064177	612.962077012835 0 0 0]; %L1 2
    lines(end+1:end+2, :) = newRow;
    end
    if(imgIdx == 152)
    newRow = [885.759918319720	1340.12689614936 1160.91248541424	759.588681446908 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 154)
    newRow = [1149.02304550758	816.321761960327  884.411318553092	1387.56417736289 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 156)
    newRow = [876.452158693115	1431.20361726955  1143.22024504084	842.590723453909 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 160)
    newRow = [876.038798133022	1376.23249708285  1120.97520420070	823.311843640607 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 167)
    newRow = [814.967036172696	1434.82817969662  1050.38652275379	878.352683780630 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 169)
    newRow = [811.676196032672	1425.21761960327  1028.74008168028	906.203325554259 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    % detect lines and related line normals
    [lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, pNV);
    
    %{
    % find the MW direction index
    numLines = size(lines,1);
    lines_labels_true = zeros(numLines,1);
    for k = 1:numLines
        
        % find the MW direction
        MW_index = find(abs(90 - rad2deg(acos(lineNormals(:,k).' * R_cM))) <= 5);
        
        % save the MW direction
        if (MW_index == 1)
            lines_labels_true(k) = 1;
        elseif (MW_index == 2)
            lines_labels_true(k) = 2;
        elseif (MW_index == 3)
            lines_labels_true(k) = 3;
        elseif (MW_index == 4)
            lines_labels_true(k) = 3;
        end
    end
    %}
   
    % clustered lines
    cla;
    %plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    %plots_extended_lines_tracking(R_cM, vpInfo_LPIC{imgIdx}, imageCurForLine, cam, optsLPIC);

    %plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    plot_image_plane_inMW(pNV, planeIdx, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    %plots_lines_clustering(R_cM, vpInfo_LPIC{imgIdx}, imageCurForLine, cam, optsLPIC);
    %{
    for k = 1:numLines
        if (lines_labels_true(k) == 1)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',6.0);
        elseif (lines_labels_true(k) == 2)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',6.0);
        elseif (lines_labels_true(k) == 3)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',6.0);
        elseif (lines_labels_true(k) == 4 || lines_labels_true(k) == 5 || lines_labels_true(k) == 6 || lines_labels_true(k) == 7)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'c','LineWidth',6.0);
        end
    end
    %}
    hold off;
    pause(0.01); refresh(h_camview);
    
    
    % save images
    saveImg = getframe(h_camview);
    imwrite(saveImg.cdata , sprintf('figures_Llong/4/%06d.png', imgIdx));
end


%% (5) camera view with clustered lines

% rotational motion
imgIdx = 28;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;

pNV = pNV_LPIC{imgIdx};
planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(3)));


% read rgb and gray images
imageCurForRGB = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');

optsLPIC.imagePyramidLevel = 2;
imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
[sNV, sPP] = estimateSurfaceNormalGradient(imageCurForMW, depthCurForMW, cam, optsLPIC);

% detect lines and related line normals
[lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, pNV);


% find the MW direction index
numLines = size(lines,1);
lines_labels_true = zeros(numLines,1);
% test first image

h_camview = figure('Position',[450 200 size(imageCurForRGB,2) size(imageCurForRGB,1)]); axes('Position',[0 0 1 1]);
imshow(imageCurForRGB)


for imgIdx = startAt+1:M

    if(imgIdx == 126 || imgIdx == 141 || imgIdx == 143 || imgIdx == 145 || imgIdx == 147 || imgIdx == 149 || imgIdx == 151 || imgIdx == 153 || imgIdx == 155  || imgIdx == 157  || imgIdx == 159 || imgIdx == 160 || imgIdx == 161 || imgIdx == 163  || imgIdx == 166 || imgIdx == 167 || imgIdx == 168 || imgIdx == 169 || imgIdx == 170 || imgIdx == 171 || imgIdx == 172 || imgIdx == 174 || imgIdx == 175 || imgIdx == 177 || imgIdx == 178 || imgIdx == 180 || imgIdx == 184 || imgIdx == 186 || imgIdx == 192 || imgIdx == 373 || imgIdx == 385 || imgIdx == 388)
        continue;
    end
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    pNV = pNV_LPIC{imgIdx};
    planeIdx = find(abs(pNV.' * R_cM) > cos(deg2rad(2)));
    
    
    % read rgb and gray images
    imageCurForRGB = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
    
    imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
    confiCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'confi');
    depthCurForMW(confiCurForMW == 0 ) = 0;
    depthCurForMW(confiCurForMW == 1 ) = 0;
    [imageCurForMW, depthCurForMW] = getImgPyramid(imageCurForMW, depthCurForMW, optsLPIC.imagePyramidLevel); %%
    [sNV, sPP] = estimateSurfaceNormalGradientforPlot(imageCurForMW, depthCurForMW, cam, optsLPIC);
    
    if(imgIdx == 27)
    newRow = [6.18261376896066 1349.60501750292 727.871353558927 1245.53821470245 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 144)
    newRow = [823.810676779463	1361.10997666278 1154.62164527421	702.209159859977 0 0 0;
                1439.37981330222	522.226954492415  1899.77654609102	530.628354725787 0 0 0]; %L1 2
    lines(end+1:end+2, :) = newRow;
    end
    if(imgIdx == 146)
    newRow = [830.728996499417	1341.83109684948 1147.01108518086	713.778879813302 0 0 0;
1402.92561260210	522.476954492415 1913.88710618436	532.238914819136 0 0 0]; %L1 2
    lines(end+1:end+2, :) = newRow;
    end
    if(imgIdx == 148)
    newRow = [831.269836639440	1352.69165694282 1165.38360560093	686.824679113185 0 0 0;
1180.61668611435	663.370478413069 1343.60385064177	612.962077012835 0 0 0]; %L1 2
    lines(end+1:end+2, :) = newRow;
    end
    if(imgIdx == 150)
    newRow = [831.269836639440	1352.69165694282 1165.38360560093	686.824679113185 0 0 0;
1180.61668611435	663.370478413069 1343.60385064177	612.962077012835 0 0 0]; %L1 2
    lines(end+1:end+2, :) = newRow;
    end
    if(imgIdx == 152)
    newRow = [885.759918319720	1340.12689614936 1160.91248541424	759.588681446908 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 154)
    newRow = [1149.02304550758	816.321761960327  884.411318553092	1387.56417736289 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 156)
    newRow = [876.452158693115	1431.20361726955  1143.22024504084	842.590723453909 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 160)
    newRow = [876.038798133022	1376.23249708285  1120.97520420070	823.311843640607 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 167)
    newRow = [814.967036172696	1434.82817969662  1050.38652275379	878.352683780630 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    if(imgIdx == 169)
    newRow = [811.676196032672	1425.21761960327  1028.74008168028	906.203325554259 0 0 0]; %L1 2
    lines(end+1, :) = newRow;
    end
    % detect lines and related line normals
    [lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, pNV);
    
    %{
    % find the MW direction index
    numLines = size(lines,1);
    lines_labels_true = zeros(numLines,1);
    for k = 1:numLines
        
        % find the MW direction
        MW_index = find(abs(90 - rad2deg(acos(lineNormals(:,k).' * R_cM))) <= 5);
        
        % save the MW direction
        if (MW_index == 1)
            lines_labels_true(k) = 1;
        elseif (MW_index == 2)
            lines_labels_true(k) = 2;
        elseif (MW_index == 3)
            lines_labels_true(k) = 3;
        elseif (MW_index == 4)
            lines_labels_true(k) = 3;
        end
    end
    %}
   
    % clustered lines
    cla;
    imshow(imageCurForRGB); hold on;
    %plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    %plots_extended_lines_tracking(R_cM, vpInfo_LPIC{imgIdx}, imageCurForLine, cam, optsLPIC);
    %plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    %plot_image_plane_inMW(pNV, planeIdx, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    plots_lines_clustering(R_cM, vpInfo_LPIC{imgIdx}, imageCurForLine, cam, optsLPIC);
    %{
    for k = 1:numLines
        if (lines_labels_true(k) == 1)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',6.0);
        elseif (lines_labels_true(k) == 2)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',6.0);
        elseif (lines_labels_true(k) == 3)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',6.0);
        elseif (lines_labels_true(k) == 4 || lines_labels_true(k) == 5 || lines_labels_true(k) == 6 || lines_labels_true(k) == 7)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'c','LineWidth',6.0);
        end
    end
    %}
    hold off;
    pause(0.01); refresh(h_camview);
    
    
    % save images
    saveImg = getframe(h_camview);
    imwrite(saveImg.cdata , sprintf('figures_Lshort/5/%06d.png', imgIdx));
end












%% Figures for making video clips with Tello Urban dataset: rgb_dataset_snowflake_square_buildings_rotation1

clc;
clear;
close all;

addpath('addon/lsd_1.6');
addpath('addon/lsd_1.6/Matlab');
addpath(genpath(pwd));


% Tello Urban Dataset (1~XX)
expCase = 4;
setupParams_Tello_Urban_tracking;


% load saved data in SaveDir
SaveDir = [datasetPath '/ICRA2022'];
load([SaveDir '/LPIC.mat']);


%% (1) camera view with all detected lines

% current RGB image
imgIdx = 1;
imageCurForRGB = getImgInTelloUrbanDataset(datasetPath, TelloUrbanDataset, imgIdx, 'rgb');
imageCurForLine = getImgInTelloUrbanDataset(datasetPath, TelloUrbanDataset, imgIdx, 'gray');


% line detection with LSD
lineDetector = optsLPIC.lineDetector;
lineLength = optsLPIC.lineLength;
dimageCurForLine = double(imageCurForLine);
if (strcmp(lineDetector,'lsd'))
    [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
elseif (strcmp(lineDetector,'gpa'))
    [lines, ~] = gpa(imageCurForLine, lineLength);
end
lines = extractUniqueLines(lines, cam);


% test first image
h_RGBwithLines = figure('Position',[450 200 size(imageCurForRGB,2) size(imageCurForRGB,1)]); axes('Position',[0 0 1 1]);
imshow(imageCurForRGB,[]); hold on;
for k = 1:size(lines,1)
    plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',6.0);
end
hold off;


for imgIdx = 2:M
    
    % current RGB image
    imageCurForRGB = getImgInTelloUrbanDataset(datasetPath, TelloUrbanDataset, imgIdx, 'rgb');
    imageCurForLine = getImgInTelloUrbanDataset(datasetPath, TelloUrbanDataset, imgIdx, 'gray');
    
    
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
    imshow(imageCurForRGB,[]); hold on;
    for k = 1:size(lines,1)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',6.0);
    end
    hold off;
    pause(0.01); refresh(h_RGBwithLines);
    
    
    % save images
    saveImg = getframe(h_RGBwithLines);
    imwrite(saveImg.cdata , sprintf('figures/%06d.png', imgIdx));
end


%% (2) Gaussian sphere gravity direction

% rotational motion
imgIdx = 2;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;

R_gnew_g = [0 0 -1; 1 0 0; 0 -1 0];
pNV = R_gnew_g * R_cM(:,3);


% test first image
h_sphere = figure('Position',[800 150 800 800]); axes('Position',[0 0 1 1]);
plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
plot_vertical_dominant_direction(pNV, 'b', 0.02);
plot_vertical_dominant_plane(pNV, 8.0, 'b'); lighting phong; camlight right; hold off;
set(gcf,'color','w'); axis off; grid off; view(85,15);


for imgIdx = 2:M
    
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    pNV = R_gnew_g * R_cM(:,3);
    
    
    % test first image
    cla;
    plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
    plot_vertical_dominant_direction(pNV, 'b', 0.02);
    plot_vertical_dominant_plane(pNV, 8.0, 'b'); lighting phong; camlight right; hold off;
    set(gcf,'color','w'); axis off; grid off; view(85,15);
    pause(0.01); refresh(h_sphere);
    
    
    % save images
    saveImg = getframe(h_sphere);
    imwrite(saveImg.cdata , sprintf('figures/%06d.png', imgIdx));
end


%% (3) Gaussian sphere visual compass

% rotational motion
imgIdx = 2;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;


% test first image
h_sphere = figure('Position',[800 150 800 800]); axes('Position',[0 0 1 1]);
plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
plot_MW_3Darrow(R_cM, 0.80); lighting phong; camlight right; hold off;
set(gcf,'color','w'); axis off; grid off; view(85,15);


for imgIdx = startAt:M
    %if(imgIdx == 1081 || imgIdx == 2876) L1 1
    if(imgIdx == 126 || imgIdx == 141 || imgIdx == 143 || imgIdx == 145 || imgIdx == 147 || imgIdx == 149 || imgIdx == 151 || imgIdx == 153 || imgIdx == 155  || imgIdx == 157  || imgIdx == 159 || imgIdx == 160 || imgIdx == 161 || imgIdx == 163  || imgIdx == 166 || imgIdx == 167 || imgIdx == 168 || imgIdx == 169 || imgIdx == 170 || imgIdx == 171 || imgIdx == 172 || imgIdx == 174 || imgIdx == 175 || imgIdx == 177 || imgIdx == 178 || imgIdx == 180 || imgIdx == 184 || imgIdx == 186 || imgIdx == 192 || imgIdx == 373 || imgIdx == 385 || imgIdx == 388)
        continue;
    end
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
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


%% (4) camera view with clustered lines

% rotational motion
imgIdx = 2;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;


% read rgb and gray images
imageCurForRGB = getImgInTelloUrbanDataset(datasetPath, TelloUrbanDataset, imgIdx, 'rgb');
imageCurForLine = getImgInTelloUrbanDataset(datasetPath, TelloUrbanDataset, imgIdx, 'gray');


% detect lines and related line normals
[lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, R_cM(:,3));


% find the MW direction index
numLines = size(lines,1);
lines_labels_true = zeros(numLines,1);
for k = 1:numLines
    
    % find the MW direction
    MW_index = find(abs(90 - rad2deg(acos(lineNormals(:,k).' * R_cM))) <= 5);
    
    % save the MW direction
    if (MW_index == 1)
        lines_labels_true(k) = 1;
    elseif (MW_index == 2)
        lines_labels_true(k) = 2;
    elseif (MW_index == 3)
        lines_labels_true(k) = 3;
    end
end


% test first image
h_camview = figure('Position',[450 200 size(imageCurForRGB,2) size(imageCurForRGB,1)]); axes('Position',[0 0 1 1]);
imshow(imageCurForRGB,[]); hold on;
for k = 1:numLines
    if (lines_labels_true(k) == 1)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',6.0);
    elseif (lines_labels_true(k) == 2)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',6.0);
    elseif (lines_labels_true(k) == 3)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',6.0);
    end
end
hold off;


for imgIdx = startAt:M
    
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    
    % read rgb and gray images
    imageCurForRGB = getImgInTelloUrbanDataset(datasetPath, TelloUrbanDataset, imgIdx, 'rgb');
    imageCurForLine = getImgInTelloUrbanDataset(datasetPath, TelloUrbanDataset, imgIdx, 'gray');
    
    
    % detect lines and related line normals
    [lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, R_cM(:,3));
    
    
    % find the MW direction index
    numLines = size(lines,1);
    lines_labels_true = zeros(numLines,1);
    for k = 1:numLines
        
        % find the MW direction
        MW_index = find(abs(90 - rad2deg(acos(lineNormals(:,k).' * R_cM))) <= 5);
        
        % save the MW direction
        if (MW_index == 1)
            lines_labels_true(k) = 1;
        elseif (MW_index == 2)
            lines_labels_true(k) = 2;
        elseif (MW_index == 3)
            lines_labels_true(k) = 3;
        end
    end
    
    
    % clustered lines
    cla;
    imshow(imageCurForRGB,[]); hold on;
    for k = 1:numLines
        if (lines_labels_true(k) == 1)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',6.0);
        elseif (lines_labels_true(k) == 2)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',6.0);
        elseif (lines_labels_true(k) == 3)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',6.0);
        end
    end
    hold off;
    pause(0.01); refresh(h_camview);
    
    
    % save images
    saveImg = getframe(h_camview);
    imwrite(saveImg.cdata , sprintf('figures/%06d.png', imgIdx));
end















%% Figures for making video clips with iOS Logger dataset: rgb_dataset_renaissance_04_hall_DJI_OM4_rotation4

clc;
clear;
close all;

addpath('addon/lsd_1.6');
addpath('addon/lsd_1.6/Matlab');
addpath(genpath(pwd));


% iOS Logger Dataset (1~5)
expCase = 4;
setupParams_iOS_Urban_tracking;


% load saved data in SaveDir
SaveDir = [datasetPath '/ICRA2022'];
load([SaveDir '/LPIC.mat']);


%% (1) camera view with all detected lines

% current RGB image
imgIdx = 1;
imageCurForRGB = getImgInTelloUrbanDataset(datasetPath, TelloUrbanDataset, imgIdx, 'rgb');
imageCurForLine = getImgInTelloUrbanDataset(datasetPath, TelloUrbanDataset, imgIdx, 'gray');


% line detection with LSD
lineDetector = optsLPIC.lineDetector;
lineLength = optsLPIC.lineLength;
dimageCurForLine = double(imageCurForLine);
if (strcmp(lineDetector,'lsd'))
    [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
elseif (strcmp(lineDetector,'gpa'))
    [lines, ~] = gpa(imageCurForLine, lineLength);
end
lines = extractUniqueLines(lines, cam);


% test first image
h_RGBwithLines = figure('Position',[650 200 size(imageCurForRGB,2) size(imageCurForRGB,1)]); axes('Position',[0 0 1 1]);
imshow(imageCurForRGB,[]); hold on;
for k = 1:size(lines,1)
    plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',6.0);
end
hold off;


for imgIdx = 2:M
    
    % current RGB image
    imageCurForRGB = getImgInTelloUrbanDataset(datasetPath, TelloUrbanDataset, imgIdx, 'rgb');
    imageCurForLine = getImgInTelloUrbanDataset(datasetPath, TelloUrbanDataset, imgIdx, 'gray');
    
    
    % line detection
    dimageCurForLine = double(imageCurForLine);
    if (strcmp(lineDetector,'lsd'))
        [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
    elseif (strcmp(lineDetector,'gpa'))
        [lines, ~] = gpa(imageCurForLine, lineLength);
    end
    lines = extractUniqueLines(imageCurForLine, lines, cam);
    
    
    % all detected lines
    cla;
    imshow(imageCurForRGB,[]); hold on;
    for k = 1:size(lines,1)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',6.0);
    end
    hold off;
    pause(0.01); refresh(h_RGBwithLines);
    
    
    % save images
    saveImg = getframe(h_RGBwithLines);
    imwrite(saveImg.cdata , sprintf('figures/%06d.png', imgIdx));
end


%% (2) Gaussian sphere gravity direction

% rotational motion
imgIdx = 2;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;

R_gnew_g = [0 0 -1; 1 0 0; 0 -1 0];
pNV = R_gnew_g * R_cM(:,3);


% test first image
h_sphere = figure('Position',[800 150 800 800]); axes('Position',[0 0 1 1]);
plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
plot_vertical_dominant_direction(pNV, 'b', 0.02);
plot_vertical_dominant_plane(pNV, 8.0, 'b'); lighting phong; camlight right; hold off;
set(gcf,'color','w'); axis off; grid off; view(85,15);


for imgIdx = 2:M
    
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    pNV = R_gnew_g * R_cM(:,3);
    
    
    % test first image
    cla;
    plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
    plot_vertical_dominant_direction(pNV, 'b', 0.02);
    plot_vertical_dominant_plane(pNV, 8.0, 'b'); lighting phong; camlight right; hold off;
    set(gcf,'color','w'); axis off; grid off; view(85,15);
    pause(0.01); refresh(h_sphere);
    
    
    % save images
    saveImg = getframe(h_sphere);
    imwrite(saveImg.cdata , sprintf('figures/%06d.png', imgIdx));
end


%% (3) Gaussian sphere visual compass

% rotational motion
imgIdx = 2;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;


% test first image
h_sphere = figure('Position',[800 150 800 800]); axes('Position',[0 0 1 1]);
plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
plot_MW_3Darrow(R_cM, 0.80); lighting phong; camlight right; hold off;
set(gcf,'color','w'); axis off; grid off; view(85,15);


for imgIdx = 2:M
    
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
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


%% (4) camera view with clustered lines

% rotational motion
imgIdx = 2;
R_gc = R_gc_LPIC(:,:,imgIdx);
R_cM = inv(R_gc) * R_gM;


% read rgb and gray images
imageCurForRGB = getImgInTelloUrbanDataset(datasetPath, TelloUrbanDataset, imgIdx, 'rgb');
imageCurForLine = getImgInTelloUrbanDataset(datasetPath, TelloUrbanDataset, imgIdx, 'gray');


% detect lines and related line normals
[lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, R_cM(:,3));


% find the MW direction index
numLines = size(lines,1);
lines_labels_true = zeros(numLines,1);
for k = 1:numLines
    
    % find the MW direction
    MW_index = find(abs(90 - rad2deg(acos(lineNormals(:,k).' * R_cM))) <= 5);
    
    % save the MW direction
    if (MW_index == 1)
        lines_labels_true(k) = 1;
    elseif (MW_index == 2)
        lines_labels_true(k) = 2;
    elseif (MW_index == 3)
        lines_labels_true(k) = 3;
    end
end


% test first image
h_camview = figure('Position',[450 200 size(imageCurForRGB,2) size(imageCurForRGB,1)]); axes('Position',[0 0 1 1]);
imshow(imageCurForRGB,[]); hold on;
for k = 1:numLines
    if (lines_labels_true(k) == 1)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',6.0);
    elseif (lines_labels_true(k) == 2)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',6.0);
    elseif (lines_labels_true(k) == 3)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',6.0);
    end
end
hold off;


for imgIdx = 2:M
    
    % rotational motion
    R_gc = R_gc_LPIC(:,:,imgIdx);
    R_cM = inv(R_gc) * R_gM;
    
    
    % read rgb and gray images
    imageCurForRGB = getImgInTelloUrbanDataset(datasetPath, TelloUrbanDataset, imgIdx, 'rgb');
    imageCurForLine = getImgInTelloUrbanDataset(datasetPath, TelloUrbanDataset, imgIdx, 'gray');
    
    
    % detect lines and related line normals
    [lines, lineNormals] = extractLinesAndGreatcircle_for_video(imageCurForLine, cam, optsLPIC, R_cM(:,3));
    
    
    % find the MW direction index
    numLines = size(lines,1);
    lines_labels_true = zeros(numLines,1);
    for k = 1:numLines
        
        % find the MW direction
        MW_index = find(abs(90 - rad2deg(acos(lineNormals(:,k).' * R_cM))) <= 5);
        
        % save the MW direction
        if (MW_index == 1)
            lines_labels_true(k) = 1;
        elseif (MW_index == 2)
            lines_labels_true(k) = 2;
        elseif (MW_index == 3)
            lines_labels_true(k) = 3;
        end
    end
    
    
    % clustered lines
    cla;
    imshow(imageCurForRGB,[]); hold on;
    for k = 1:numLines
        if (lines_labels_true(k) == 1)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',6.0);
        elseif (lines_labels_true(k) == 2)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',6.0);
        elseif (lines_labels_true(k) == 3)
            plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',6.0);
        end
    end
    hold off;
    pause(0.01); refresh(h_camview);
    
    
    % save images
    saveImg = getframe(h_camview);
    imwrite(saveImg.cdata , sprintf('figures/%06d.png', imgIdx));
end












