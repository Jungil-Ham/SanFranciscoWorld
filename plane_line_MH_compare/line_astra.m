clc;
clear all;
close all;
fx = 534.883484;
fy = 534.883484;
cx = 316.479248;
cy = 238.092361;
colors = ['r', 'g', 'b', 'c', 'm', 'y', 'k'];
cam = [fx,  0, cx; 0, fy, cy; 0,  0,  1];
Kinv = inv(cam);
imageCur=imread("1rgb.png");
depthCur=imread("1depth.png");
depthCur = double(depthCur)/1000;

load('LineExtraction2.mat');
vpCells ={vp1, vp2, vp3, vp4, vp5};

allCircleNormalcell = cell(1, size(vpCells, 2));
for k = 1:size(vpCells,2) %1~6
    for i = 1:size(vpCells{k},(1))/2 %number of line in each vp
        
        ptEnd1_p_d = [vpCells{k}(2*i-1,1:2), 1].';
        ptEnd2_p_d = [vpCells{k}(2*i  ,1:2), 1].';
        ptEnd1_n_d = Kinv * ptEnd1_p_d;
        ptEnd2_n_d = Kinv * ptEnd2_p_d;
        ptEnd1_n_d = ptEnd1_n_d / norm(ptEnd1_n_d);
        ptEnd2_n_d = ptEnd2_n_d / norm(ptEnd2_n_d);
        %plot_great_circle(ptEnd1_n_d, ptEnd2_n_d, 4, 'g', 'greatcircle');

        % plot great circle normal vectors
        circleNormal = cross(ptEnd1_n_d.', ptEnd2_n_d.');
        circleNormal = circleNormal / norm(circleNormal);
        %plot3([0 circleNormal(1)],[0 circleNormal(2)],[0 circleNormal(3)], 'o', 'Color' ,colors(k),'LineWidth', 2);
        allCircleNormalcell{k}{i} = circleNormal;
   end
end

imshow(imageCur)
lines_2d = zeros(4,size(lines,1));
for k = 1:size(lines_2d,2)
    lines_2d(:,k) = lines(k,1:4); 
    line([lines_2d(1,k) lines_2d(3,k)], [lines_2d(2,k) lines_2d(4,k)], 'Color', ...
         'y', 'LineWidth',5)
        
end

VP1 = cross(allCircleNormalcell{1}{1},allCircleNormalcell{1}{2});
VP1 = VP1 / norm(VP1);
VP2 = cross(allCircleNormalcell{2}{1},allCircleNormalcell{2}{2});
VP2 = VP2 / norm(VP2);
VP3 = cross(VP1,VP2);
VP3 = VP3 / norm(VP3);
[VP1.' VP2.' VP3.']
