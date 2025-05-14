
addpath('../forDrawingFigures_MSMO/');
load('matForFigures/L2_pipeline.mat');
imageCurForRGB = imread('1215.png');

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

h1 = figure(13);
plot_unit_sphere(1, 20, 0.5); hold on; grid on; axis equal;
f = FigureRotator(gca());
for k = 1:3
    % original horizontal direction
    h1 = mArrow3([0;0;0],R_SLP(:,k),'color',colors{k},'stemWidth',0.01);
    % inverse horizontal direction
    h2 = mArrow3([0;0;0],-R_SLP(:,k),'color',colors{k},'stemWidth',0.01);
    
    plot_horizontal_dominant_plane(R_SLP(:,k), 4.0, colors{k});
end
% plot ellipse around normal vector of great circle (only for figure_stabbing_intervals.m)
hold off; axis off;  
set(gca, 'XDir','reverse');
%f = FigureRotator(gca());
set(gcf,'Units','pixels','Position',[900 120 750 750]);

imageCurForRGB = imread('1216_vDD.png');
h1 = figure(8);
plot_unit_sphere(1, 20, 0.5); hold on; grid on; axis equal;
plot_image_Gaussian_sphere_York_Urban(imageCurForRGB);
f = FigureRotator(gca());
for k = 1:3
    % original horizontal direction
    h1 = mArrow3([0;0;0],R_SLP(:,k),'color',colors{k},'stemWidth',0.01);
    % inverse horizontal direction
    h2 = mArrow3([0;0;0],-R_SLP(:,k),'color',colors{k},'stemWidth',0.01);

    if(k==2)
    plot_horizontal_dominant_plane(R_SLP(:,k), 4.0, colors{k});
    end
end
for k = 1:1
    plot3([0 -greatcircleNormal(k,1)],[0 -greatcircleNormal(k,2)],[0 -greatcircleNormal(k,3)],'o','MarkerSize',10,'LineWidth',1.5,'Color','k','MarkerFaceColor','g'); hold on;
    plot3([0 -greatcircleNormal(k,1)],[0 -greatcircleNormal(k,2)],[0 -greatcircleNormal(k,3)],'MarkerSize',10,'LineWidth',3,'Color','g','MarkerFaceColor',[180/255,180/255,180/255]);
end
% plot ellipse around normal vector of great circle (only for figure_stabbing_intervals.m)
hold off; axis off;  
set(gca, 'XDir','reverse');
%f = FigureRotator(gca());
set(gcf,'Units','pixels','Position',[900 120 750 750]);


imageCurForRGB = imread('1216_sDD.png');
h1 = figure(11);
plot_unit_sphere(1, 20, 0.5); hold on; grid on; axis equal;
plot_image_Gaussian_sphere_York_Urban(imageCurForRGB);
f = FigureRotator(gca());
for k = 1:4
    % original horizontal direction
    h1 = mArrow3([0;0;0],R_SLP(:,k),'color',colors{k},'stemWidth',0.01);
    % inverse horizontal direction
    h2 = mArrow3([0;0;0],-R_SLP(:,k),'color',colors{k},'stemWidth',0.01);

    if(k==4)
    plot_horizontal_dominant_plane(R_SLP(:,k), 4.0, colors{k});
    end
end
for k = 2:2
    plot3([0 -greatcircleNormal(k,1)],[0 -greatcircleNormal(k,2)],[0 -greatcircleNormal(k,3)],'o','MarkerSize',10,'LineWidth',1.5,'Color','k','MarkerFaceColor','c'); hold on;
    plot3([0 -greatcircleNormal(k,1)],[0 -greatcircleNormal(k,2)],[0 -greatcircleNormal(k,3)],'MarkerSize',10,'LineWidth',3,'Color','c','MarkerFaceColor',[180/255,180/255,180/255]);
end
% plot ellipse around normal vector of great circle (only for figure_stabbing_intervals.m)
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

