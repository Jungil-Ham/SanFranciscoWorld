clear all
close all

addpath('addon/lsd_1.6');
addpath('addon/lsd_1.6/Matlab');
addpath('MatlabProgressBar');
addpath(genpath(pwd))

expCase = 3;
setupParams_STSC;
imgIdx = 1;

rawICLNUIMdataset = rawSTSCdataset_load(datasetPath);


[ICLNUIMdataset] = getSyncTUMRGBDdataset(rawICLNUIMdataset, imInit, M);

cam = initialize_cam_STSC(ICLNUIMdataset, 1); % optsLPRVO.imagePyramidLevel = 1

%imageCur = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
%imageCur = imread('./14.png');
imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
%imageCurForLine = uint8(rgb2gray(imageCur));
lineLength = 150;
dimageCurForLine = double(imageCurForLine);


[lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
colors = ['r', 'g', 'b', 'c', 'm', 'y', 'k'];
figure
imshow(imageCurForLine)
lines_2d = zeros(4,size(lines,1));
for k = 1:size(lines_2d,2)
    lines_2d(:,k) = lines(k,1:4); 
    line([lines_2d(1,k) lines_2d(3,k)], [lines_2d(2,k) lines_2d(4,k)], 'Color', ...
         'y', 'LineWidth',5)
        
end