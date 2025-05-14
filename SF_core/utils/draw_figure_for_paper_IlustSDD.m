addpath('../forDrawingFigures_MSMO/');
close all;
load('IllustSDD.mat');
imageCurForRGB = imread('1156.png');
colors = {'r', 'g', 'b', 'c', 'm', 'y', [0.4, 0.26, 0.13], [0, 0.4470, 0.7410], [0.5, 0, 0.5], [0, 0.5, 0.5], [0.5, 0.5, 0], [1, 0.75, 0.8], [0.6, 0.4, 0.2], [0.75, 0.75, 0.75], [1, 1, 0.5], [0.5, 0.5, 1], [0.587, 0.766, 0.628], [0.838, 0.698, 0.875], [0.360, 0.022, 0.132], [0.463, 0.069, 0.436], [0.416, 0.989, 0.289], [0.950, 0.965, 0.931], [0.875, 0.731, 0.508], [0.563, 0.028, 0.279], [0.563, 0.787, 0.181], [0.959, 0.210, 0.841], [0.612, 0.568, 0.395], [0.028, 0.775, 0.751], [0.324, 0.581, 0.114], [0.777, 0.219, 0.308]};

title('Line Clustering')
figure(11);
imshow(imageCurForRGB)
for k = 1:size(clusteredLinesIdx,2)
    linesInVP = lines(clusteredLinesIdx{k},:);
    numLinesInVP = size(linesInVP,1);
    for j = 1:numLinesInVP
    lines_2d = linesInVP(j,1:4); 
    line([lines_2d(1,1) lines_2d(1,3)], [lines_2d(1,2) lines_2d(1,4)], 'Color', ...
         [0.8500 0.3250 0.0980], 'LineWidth',7)
    end
end
title('Line Clustering')

figure;
imshow(imageCurForRGB, []); hold on;
for k = 1:size(clusteredLinesIdx,2)
    linesInVP = lines(clusteredLinesIdx{k},:);
    numLinesInVP = size(linesInVP,1);
    for j = 1:numLinesInVP
    lines_2d = linesInVP(j,1:4); 
    line([lines_2d(1,1) lines_2d(1,3)], [lines_2d(1,2) lines_2d(1,4)], 'Color', ...
         colors{k}, 'LineWidth',5)
    end
end
set(gca,'units','pixels'); x = get(gca,'position');
set(gcf,'units','pixels'); y = get(gcf,'position');
set(gcf,'position',[y(1) y(2) x(3) x(4)]);
set(gca,'units','normalized','position',[0 0 1 1]);
title('Line Clustering')

h1 = figure(2);
plot_unit_sphere(1, 20, 0.5); hold on; grid on; axis equal;
plot_image_Gaussian_sphere_York_Urban(imageCurForRGB);
f = FigureRotator(gca());
for k = 1:slp_leng
    % original horizontal direction
    
    h1 = mArrow3([0;0;0],R_SLP(:,k),'color',colors{k},'stemWidth',0.01);
    % inverse horizontal direction
    h2 = mArrow3([0;0;0],-R_SLP(:,k),'color',colors{k},'stemWidth',0.01);
    if (k>3)
    plot_horizontal_dominant_plane(R_SLP(:,k), 2.0, colors{k});
    end
end
for k = 1:numUnLines
    plot3([0 -greatcircleNormal(nonAssociatedIdx(k),1)],[0 -greatcircleNormal(nonAssociatedIdx(k),2)],[0 -greatcircleNormal(nonAssociatedIdx(k),3)],'o','MarkerSize',10,'LineWidth',1.5,'Color','k','MarkerFaceColor',[180/255,180/255,180/255]); hold on;
end
hold off; axis off;  
set(gca, 'XDir','reverse');
f = FigureRotator(gca());
set(gcf,'Units','pixels','Position',[900 120 750 750]);




h1 = figure(3);
plot_unit_sphere(1, 20, 0.5); hold on; grid on; axis equal;
%plot_image_Gaussian_sphere_York_Urban(imageCurForRGB);
f = FigureRotator(gca());
for k = 1:slp_leng
    if (k<4)
    % original horizontal direction
    h1 = mArrow3([0;0;0],R_SLP(:,k),'color',colors{k},'stemWidth',0.01);
    % inverse horizontal direction
    h2 = mArrow3([0;0;0],-R_SLP(:,k),'color',colors{k},'stemWidth',0.01);
    end
    if (k>3)
    plot_horizontal_dominant_plane(R_SLP(:,k), 2.0, colors{k});
    end
end
for k = 1:numUnLines
    plot3([0 -greatcircleNormal(nonAssociatedIdx(k),1)],[0 -greatcircleNormal(nonAssociatedIdx(k),2)],[0 -greatcircleNormal(nonAssociatedIdx(k),3)],'o','MarkerSize',10,'LineWidth',1.5,'Color','k','MarkerFaceColor',[180/255,180/255,180/255]); hold on;
end
% plot ellipse around normal vector of great circle (only for figure_stabbing_intervals.m)
for k = 1:numUnLines
    plot_ellipse_edge(-greatcircleNormal(nonAssociatedIdx(k),:), -0.995, 2.5, 'k');
end
hold off; axis off;  
set(gca, 'XDir','reverse');
f = FigureRotator(gca());
set(gcf,'Units','pixels','Position',[900 120 750 750]);


% copy current figure as vector graphics format
copygraphics(gcf,'ContentType','image','BackgroundColor','none');


% for legend
figure;
h_VDD = plot3([0 1],[0 1],[0 1],'Color','g','LineWidth',3.0); hold on;
h_normal = plot3(1,1,1,'o','MarkerSize',8,'LineWidth',1.5,'Color','k','MarkerFaceColor',[180/255,180/255,180/255]); hold off;
set(gcf,'color','w'); axis equal; grid off;
legend([h_VDD h_normal],{'VDD','Sloping Line Normals'},'Orientation','vertical','FontSize',15,'FontName','Times New Roman');


figure; set(gcf,'color','w'); grid on;
xlim([-40 50]); set(gca,'xtick',[-40:10:50]);
ylim([0 23]); set(gca,'ytick',[1:1:22]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',20);
xlabel('Candidate Interval Angle \theta [deg]','FontName','Times New Roman','FontSize',24);
ylabel('Image Line Index','FontName','Times New Roman','FontSize',24);
set(gcf,'Units','pixels','Position',[600 200 1200 650]);  % modify figure size

