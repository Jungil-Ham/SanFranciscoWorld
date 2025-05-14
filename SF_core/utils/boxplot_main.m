clc;
clear all;
close all;
addpath 'C:\SanFrancisco\forDrawingFigures'
load("boxplot\proposed.mat","rotationMatrixDifference");
load("boxplot\limap.mat","RMD_Values");
load("boxplot\ORB_L_careful.mat","RMD")
ORB_RMD=RMD;
load("boxplot\DROID_L_careful.mat","RMD");
% generate distinguishable line color
lineColorMaps = distinguishable_colors(10);

% 각 벡터의 크기 확인
len_rmd = length(rotationMatrixDifference);
len_orb_rmd = length(ORB_RMD);
len_rmd_droid = length(RMD);
len_rmd_values = length(RMD_Values);

% 최대 길이 계산
max_len = max([len_rmd, len_orb_rmd, len_rmd_droid, len_rmd_values]);

% 배열의 길이를 최대 길이에 맞추기
rotationMatrixDifference_padded = padarray(rotationMatrixDifference, [0 max_len-len_rmd], NaN, 'post');
ORB_RMD_padded = padarray(ORB_RMD, [0 max_len-len_orb_rmd], NaN, 'post');
RMD_padded = padarray(RMD, [0 max_len-len_rmd_droid], NaN, 'post');

% RMD_Values 배열은 특별하게 처리가 필요할 수 있음
RMD_Values_padded = RMD_Values;
if len_rmd_values < max_len
    RMD_Values_padded = [RMD_Values, repmat(NaN, 1, max_len-len_rmd_values)];
end

% 이제 모든 배열이 같은 길이를 가지고 있으므로 결합 가능
boxPlotData = [rotationMatrixDifference_padded.', ORB_RMD_padded.', RMD_padded.', RMD_Values_padded.'];
% plot boxplot
figure;
boxplot(boxPlotData);


% boxplot color
h_boxplot = findobj(gca,'Tag','Box');
faceAlpha = 0.7;

patch(get(h_boxplot(4),'XData'),get(h_boxplot(4),'YData'),lineColorMaps(1,:),'FaceAlpha',faceAlpha);
patch(get(h_boxplot(3),'XData'),get(h_boxplot(3),'YData'),lineColorMaps(2,:),'FaceAlpha',faceAlpha);
patch(get(h_boxplot(2),'XData'),get(h_boxplot(2),'YData'),lineColorMaps(3,:),'FaceAlpha',faceAlpha);
patch(get(h_boxplot(1),'XData'),get(h_boxplot(1),'YData'),lineColorMaps(6,:),'FaceAlpha',faceAlpha);


% x and y axis label
xtixloc = [1 2 3 4];                                                           %  label locations
xtix = {'Proposed','ORB-SLAM3','DROID-SLAM','LIMAP'};      %  labels name
set(gca,'XTickMode','auto','XTickLabel',xtix,'XTick',xtixloc);
grid on; axis tight; ylim([0 30]); set(gcf,'color','w');
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',16);
ylabel('Absolute Rotation Error [deg]','FontName','Times New Roman','FontSize',20);
set(gcf,'Units','pixels','Position',[800 350 740 480]);