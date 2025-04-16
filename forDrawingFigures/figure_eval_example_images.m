%% figure_eval_example_images
%% lr_kt0_pure

clc;
clear;
close all;


% ICL NUIM dataset (1~8)
expCase = 1;
setupParams_ICL_NUIM;


% load saved data in SaveDir
SaveDir = [datasetPath '/CVPR2018'];
load([SaveDir '/LPRVO.mat']);


%% plot original image

% image index
imgIdx = 956;


% RGB image
figure;
imageCur = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
imshow(imageCur);
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);


%% of_kt1

clc;
clear;
close all;


% ICL NUIM dataset (1~8)
expCase = 6;
setupParams_ICL_NUIM;


% load saved data in SaveDir
SaveDir = [datasetPath '/CVPR2018'];
load([SaveDir '/LPRVO.mat']);


%% plot original image

% image index
imgIdx = 544;


% RGB image
figure;
imageCur = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
imshow(imageCur);
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);


%% rgbd_dataset_freiburg3_nostructure_notexture_near_withloop

clc;
clear;
close all;


% TUM RGBD dataset (1~12)
expCase = 4;
setupParams_TUM_RGBD;


% load saved data in SaveDir
SaveDir = [datasetPath '/CVPR2018'];
load([SaveDir '/LPRVO.mat']);


%% plot original image

% image index
imgIdx = 116;


% RGB image
figure;
imageCur = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'rgb');
imshow(imageCur);
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);


%% rgbd_dataset_freiburg3_structure_notexture_far

clc;
clear;
close all;


% TUM RGBD dataset (1~12)
expCase = 7;
setupParams_TUM_RGBD;


% load saved data in SaveDir
SaveDir = [datasetPath '/CVPR2018'];
load([SaveDir '/LPRVO.mat']);


%% plot original image

% image index
imgIdx = 350;


% RGB image
figure;
imageCur = getImgInTUMRGBDdataset(datasetPath, TUMRGBDdataset, cam, imgIdx, 'rgb');
imshow(imageCur);
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);







