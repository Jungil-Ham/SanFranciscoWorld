

boxPlotData = [RMD_LPRVO.', RMD_LPRVO_NO.', RMD_GOME.', RMD_OLVO.', RMD_OPVO.', RMD_ROVE.'];
boxPlotColorData = [[1,0,1]; [1,0,1]; lineColorMaps(1,:); lineColorMaps(2,:); lineColorMaps(3,:); lineColorMaps(6,:)];
    

boxPlotColorData = cell(1,6);
boxPlotColorData{1} = [1,0,1];
boxPlotColorData{2} = [1,0,1];
boxPlotColorData{3} = [1,0,1];
boxPlotColorData{4} = [1,0,1];
boxPlotColorData{5} = [1,0,1];
boxPlotColorData{6} = [1,0,1];

figure;
h_boxPlot = boxplot(boxPlotData, 'Whisker', 30, 'Colors', 'm')





% x and y axis label
xtixloc = [1 2 3 4 5 6];                                                    %  label locations
xtix = {'LPRVO','LPRVO-NO','GOME','OLVO','OPVO','ROVE'};      %  labels name
set(gca,'XTickMode','auto','XTickLabel',xtix,'XTick',xtixloc);
grid on; axis tight; ylim([0 30]); set(gcf,'color','w');
ylabel('Rotation Matrix Error [deg]','FontName','Times New Roman','FontSize',15);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',15);
set(gcf,'Units','pixels','Position',[800 350 640 480]);

