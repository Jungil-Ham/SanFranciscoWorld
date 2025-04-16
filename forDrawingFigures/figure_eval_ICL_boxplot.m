%% figure_eval_ICL_boxplot

clc;
clear;
close all;


% ICL NUIM dataset (1~8)
expCase = 2;
setupParams_ICL_NUIM;


% load saved data in SaveDir
SaveDir = [datasetPath '/CVPR2018'];
load([SaveDir '/LPRVO.mat']);
load([SaveDir '/LPRVO_NO.mat']);
load([SaveDir '/GOME.mat']);
load([SaveDir '/OLVO.mat']);
load([SaveDir '/OPVO.mat']);
load([SaveDir '/ROVE.mat']);


%% plot boxplot with 6 VO methods


% generate distinguishable line color
lineColorMaps = distinguishable_colors(10);


% re-arrange boxplot data
boxPlotData = [RMD_LPRVO.', RMD_LPRVO_NO.', RMD_GOME.', RMD_OLVO.', RMD_OPVO.', RMD_ROVE.'];


% plot boxplot
figure;
boxplot(boxPlotData);


% boxplot color
h_boxplot = findobj(gca,'Tag','Box');
faceAlpha = 0.7;
patch(get(h_boxplot(6),'XData'),get(h_boxplot(6),'YData'),'m','FaceAlpha',faceAlpha);
patch(get(h_boxplot(5),'XData'),get(h_boxplot(5),'YData'),'m','FaceAlpha',faceAlpha);
patch(get(h_boxplot(4),'XData'),get(h_boxplot(4),'YData'),lineColorMaps(1,:),'FaceAlpha',faceAlpha);
patch(get(h_boxplot(3),'XData'),get(h_boxplot(3),'YData'),lineColorMaps(2,:),'FaceAlpha',faceAlpha);
patch(get(h_boxplot(2),'XData'),get(h_boxplot(2),'YData'),lineColorMaps(3,:),'FaceAlpha',faceAlpha);
patch(get(h_boxplot(1),'XData'),get(h_boxplot(1),'YData'),lineColorMaps(6,:),'FaceAlpha',faceAlpha);


% x and y axis label
xtixloc = [1 2 3 4 5 6];                                                           %  label locations
xtix = {'Proposed','Proposed(NO)','GOME','OLRE','OPRE','ROVE'};      %  labels name
set(gca,'XTickMode','auto','XTickLabel',xtix,'XTick',xtixloc);
grid on; axis tight; ylim([0 30]); set(gcf,'color','w');
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',16);
ylabel('Absolute Rotation Error [deg]','FontName','Times New Roman','FontSize',20);
set(gcf,'Units','pixels','Position',[800 350 740 480]);






