%% figure_supplementary_York_Urban_1 (4, 36, 66, 96)

clc;
clear;
close all;

addpath('addon/lsd_1.6');
addpath('addon/lsd_1.6/Matlab');
addpath(genpath(pwd));


% York Urban Dataset (1~XX)
expCase = 1;
setupParams_York_Urban;


% load saved data in SaveDir
SaveDir = [datasetPath '/IROS2021'];
load([SaveDir '/MWMS.mat']);


%% plot original image with raw lines

% selected image index
imgIdx = 4;


% read gray image & labeled lines
[imageCurForRGB, lines, lines_labels_true] = getImgInYorkUrbanDataset(datasetPath, YorkUrbanDataset, imgIdx, 'rgb');


% plot original image and raw lines
figure;
imshow(imageCurForRGB, []); hold on;
for k = 1:size(lines,1)
    plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'c','LineWidth',3.0);
end
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);


%% plot RGB image with clustered lines

% plot RGB image with clustered lines
figure;
imshow(imageCurForRGB, []); hold on;
for k = 1:size(lines,1)
    if (lines_labels_true(k) == 1)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'g','LineWidth',5.0);
    elseif (lines_labels_true(k) == 2)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'b','LineWidth',5.0);
    elseif (lines_labels_true(k) == 3)
        plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'r','LineWidth',5.0);
    end
end
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);


%% plot normal vectors on the Gaussian sphere

% read gray image & labeled lines & R_cM
[imageCurForRGB, lines, lines_labels_true] = getImgInYorkUrbanDataset(datasetPath, YorkUrbanDataset, imgIdx, 'rgb');
R_cM = R_cM_MWMS{imgIdx};


% detect lines and related line normals
[~, greatcirclePoints, ~] = extractGreatcircle(imageCurForRGB, lines, cam);
greatcirclePoints = greatcirclePoints.';


% plot normal vectors on the Gaussian sphere
figure;
plot_unit_sphere(1, 20, 0.5); hold on; grid on; axis equal;
plot_image_Gaussian_sphere_York_Urban(imageCurForRGB);
for k = 1:size(lines,1)
    if (lines_labels_true(k) == 1)
        plot_great_circle(greatcirclePoints(1:3,k),greatcirclePoints(4:6,k),2.0,'g','arc');
    elseif (lines_labels_true(k) == 2)
        plot_great_circle(greatcirclePoints(1:3,k),greatcirclePoints(4:6,k),2.0,'b','arc');
    elseif (lines_labels_true(k) == 3)
        plot_great_circle(greatcirclePoints(1:3,k),greatcirclePoints(4:6,k),2.0,'r','arc');
    else
        k
    end
end
plot_line_normals_unit_sphere_York_Urban(imageCurForRGB, lines, cam, R_cM, optsMWMS);
plot_MW_unit_sphere(R_cM); hold off; axis off;         % LineWidth : 5.0
set(gca, 'XDir','reverse');
f = FigureRotator(gca());
set(gcf,'Units','pixels','Position',[900 120 750 750]);


% copy current figure as vector graphics format
copygraphics(gcf,'ContentType','image','BackgroundColor','none');


% for legend
figure;
h_VDD = plot3([0 1],[0 1],[0 1],'Color','b','LineWidth',3.0); hold on;
h_normal = plot3(1,1,1,'o','MarkerSize',8,'LineWidth',1.5,'Color','k','MarkerFaceColor',[180/255,180/255,180/255]); hold off;
set(gcf,'color','w'); axis equal; grid off;
legend([h_VDD h_normal],{'Ground Plane Direction','Normals of Great Circles'},'Orientation','vertical','FontSize',15,'FontName','Times New Roman');








