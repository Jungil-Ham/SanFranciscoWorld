%% main script for plotting TUM RGBD dataset

clc;
clear;
close all;


% TUM RGBD dataset (1~12)
expCase = 1;
setupParams_TUM_RGBD;


% load saved data in SaveDir
SaveDir = [datasetPath '/CVPR2018'];
load([SaveDir '/LPRVO.mat']);
load([SaveDir '/LPRVO_NO.mat']);
load([SaveDir '/GOME.mat']);
load([SaveDir '/OLVO.mat']);
load([SaveDir '/OPVO.mat']);
load([SaveDir '/ROVE.mat']);


%% RMD and standard deviation


% 1. MEAN of RMD of each VO method
fprintf('*********[MEAN of RMD]************\n')
fprintf('[LPRVO] MEAN of RMD [deg] : %f \n' , RMD_MEAN_LPRVO);
fprintf('[LPRVO_NO] MEAN of RMD [deg] : %f \n' , RMD_MEAN_LPRVO_NO);
fprintf('[GOME] MEAN of RMD [deg] : %f \n' , RMD_MEAN_GOME);
fprintf('[OLVO] MEAN of RMD [deg] : %f \n' , RMD_MEAN_OLVO);
fprintf('[OPVO] MEAN of RMD [deg] : %f \n' , RMD_MEAN_OPVO);
fprintf('[ROVE] MEAN of RMD [deg] : %f \n' , RMD_MEAN_ROVE);
fprintf('*******************************\n')


% 2. std. of RMD of each VO method
fprintf('*********[std. of RMD]************\n')
fprintf('[LPRVO] std. of RMD [deg] : %f \n' , std(RMD_LPRVO));
fprintf('[LPRVO_NO] std. of RMD [deg] : %f \n' , std(RMD_LPRVO_NO));
fprintf('[GOME] std. of RMD [deg] : %f \n' , std(RMD_GOME));
fprintf('[OLVO] std. of RMD [deg] : %f \n' , std(RMD_OLVO));
fprintf('[OPVO] std. of RMD [deg] : %f \n' , std(RMD_OPVO));
fprintf('[ROVE] std. of RMD [deg] : %f \n' , std(RMD_ROVE));
fprintf('*******************************\n')


%% plot camera orientation estimation results


% generate distinguishable line color
lineColorMaps = distinguishable_colors(10);


% plot roll, pitch, yaw estimation results separately
figure;
subplot(3,1,1)
h_true = plot(stateTrue(4,:),'k','LineWidth',1.7); hold on;
h_LPRVO = plot(stateEsti_LPRVO(1,:),'Color','m','LineStyle','-','LineWidth',2.0);
h_GOME = plot(stateEsti_GOME(1,:),'Color',lineColorMaps(1,:),'LineStyle','--','LineWidth',1.5);
h_OLVO = plot(stateEsti_OLVO(1,:),'Color',lineColorMaps(2,:),'LineStyle','-.','LineWidth',1.5);
h_OPVO = plot(stateEsti_OPVO(1,:),'Color',lineColorMaps(3,:),'LineStyle',':','LineWidth',1.8);
h_ROVE = plot(stateEsti_ROVE(1,:),'Color',lineColorMaps(6,:),'LineStyle','-','LineWidth',1.8); hold off;
set(gcf,'color','w'); set(gca,'xtick',[]); axis tight;
ylabel('Roll [rad]','FontName','Times New Roman','FontSize',13);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',13);
legend([h_true h_LPRVO h_GOME h_OLVO h_OPVO h_ROVE],{'True','Proposed','GOME','OLVO','OPVO','ROVE'},...
    'Orientation','Vertical','FontSize',13,'FontName','Times New Roman');

subplot(3,1,2)
plot(stateTrue(5,:),'k','LineWidth',1.7); hold on;
plot(stateEsti_LPRVO(2,:),'Color','m','LineStyle','-','LineWidth',2.0);
plot(stateEsti_GOME(2,:),'Color',lineColorMaps(1,:),'LineStyle','--','LineWidth',1.5);
plot(stateEsti_OLVO(2,:),'Color',lineColorMaps(2,:),'LineStyle','-.','LineWidth',1.5);
plot(stateEsti_OPVO(2,:),'Color',lineColorMaps(3,:),'LineStyle',':','LineWidth',1.8);
plot(stateEsti_ROVE(2,:),'Color',lineColorMaps(6,:),'LineStyle','-','LineWidth',1.8); hold off;
set(gca,'xtick',[]); axis tight;
ylabel('Pitch [rad]','FontName','Times New Roman','FontSize',13);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',13);

subplot(3,1,3)
plot(stateTrue(6,:),'k','LineWidth',1.7); hold on;
plot(stateEsti_LPRVO(3,:),'Color','m','LineStyle','-','LineWidth',2.0);
plot(stateEsti_GOME(3,:),'Color',lineColorMaps(1,:),'LineStyle','--','LineWidth',1.5);
plot(stateEsti_OLVO(3,:),'Color',lineColorMaps(2,:),'LineStyle','-.','LineWidth',1.5);
plot(stateEsti_OPVO(3,:),'Color',lineColorMaps(3,:),'LineStyle',':','LineWidth',1.8);
plot(stateEsti_ROVE(3,:),'Color',lineColorMaps(6,:),'LineStyle','-','LineWidth',1.8); hold off;
axis tight;
xlabel('Frame number','FontName','Times New Roman','FontSize',13);
ylabel('Yaw [rad]','FontName','Times New Roman','FontSize',13);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',14);
set(gcf,'Units','pixels','Position',[800 350 640 480]);  % modify figure size


%% plot the RMD


figure;
h_LPRVO = plot(RMD_LPRVO,'Color','m','LineStyle','-','LineWidth',2.0); hold on;
h_GOME = plot(RMD_GOME,'Color',lineColorMaps(1,:),'LineStyle','--','LineWidth',1.5);
h_OLVO = plot(RMD_OLVO,'Color',lineColorMaps(2,:),'LineStyle','-.','LineWidth',1.5);
h_OPVO = plot(RMD_OPVO,'Color',lineColorMaps(3,:),'LineStyle',':','LineWidth',1.8);
h_ROVE = plot(RMD_ROVE,'Color',lineColorMaps(6,:),'LineStyle','-','LineWidth',1.8); hold off;
set(gcf,'color','w'); axis tight;
xlabel('Frame number','FontName','Times New Roman','FontSize',13);
ylabel('RMD [deg]','FontName','Times New Roman','FontSize',13);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',13);
legend([h_LPRVO h_GOME h_OLVO h_OPVO h_ROVE],{'Proposed','GOME','OLVO','OPVO','ROVE'},...
    'Orientation','Vertical','FontSize',15,'FontName','Times New Roman');
set(gcf,'Units','pixels','Position',[800 350 640 480]);  % modify figure size


%% plot boxplot of RMD


boxPlotData = [RMD_LPRVO.', RMD_LPRVO_NO.', RMD_GOME.', RMD_OLVO.', RMD_OPVO.', RMD_ROVE.'];

figure;
h_boxPlot = boxplot(boxPlotData, 'Whisker', 30, 'Colors', 'rgbm');


% x and y axis label
xtixloc = [1 2 3 4 5 6];                                                    %  label locations
xtix = {'LPRVO','LPRVO-NO','GOME','OLVO','OPVO','ROVE'};      %  labels name
set(gca,'XTickMode','auto','XTickLabel',xtix,'XTick',xtixloc);
grid on; axis tight; ylim([0 30]); set(gcf,'color','w');
ylabel('Rotation Matrix Error [deg]','FontName','Times New Roman','FontSize',15);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',15);
set(gcf,'Units','pixels','Position',[800 350 640 480]);



