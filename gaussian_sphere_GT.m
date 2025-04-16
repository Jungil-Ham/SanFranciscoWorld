clc;
clear all;
close all;

addpath('./forDrawingFigures');
load('LineExtraction.mat')
imRgb = imread('./1.png');

% plot normals of lines
K = [1504.503 0 951.19305;0 1504.503 729.82385;0 0 1];
Kinv = inv(K);

figure;
plot_unit_sphere(1, 18, 0.8); hold on; grid on; axis equal;

vpCells ={vp1, vp2, vp3, vp4, vp5};
size(vpCells,2)
size(vpCells{1}(1,:))
colors = ['r', 'g', 'b', 'c', 'm', 'y', 'k'];

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
        plot3([0 circleNormal(1)],[0 circleNormal(2)],[0 circleNormal(3)], 'o', 'Color' ,colors(k),'LineWidth', 2);
        allCircleNormalcell{k}{i} = circleNormal;
        if k == 5
        remainingNormals(:,i) = circleNormal;
        end
    end
    
end


optimalnormal = [];
minAngle = inf; % 무한대로 초기화
optimalIndex = 0;


for k = 1:size(allCircleNormalcell, 2)
    currentMinAngle = inf; % 현재 최소 각도
    for j = 1:20 % 예를 들어 100번의 반복으로 제한
        sampleIdx = randsample(size(allCircleNormalcell{k}, 2), 2);
        samplenormal = allCircleNormalcell{k}(:, sampleIdx);
        N1 = cell2mat(samplenormal(:, 1).');
        N2 = cell2mat(samplenormal(:, 2).');

        normalvector = cross(N1, N2);
        normalvector = normalvector/norm(normalvector);
        totalAngle = 0;
            for i = 1:size(allCircleNormalcell{k}, 2)
            totalAngle = totalAngle + abs(acos(dot(cell2mat(allCircleNormalcell{k}(:, i)), normalvector) ...
                / (norm(cell2mat(allCircleNormalcell{k}(:, i))) * norm(normalvector)))-1.5708);
            end
        if totalAngle < currentMinAngle
        currentMinAngle = totalAngle;
        optimalnormal{k} = normalvector; % 현재 최적의 normalvector 저장
        optimalcirclenormal{k} = {N1,N2};  %현재 최적의 circle normal sample 저장
        end
    end
    angle(k) = currentMinAngle;
end
%{
angle = acos(dot(optimalnormal{1},optimalnormal{5})/(norm(optimalnormal{1})*norm(optimalnormal{5})));
angleDeg = rad2deg(angle);
midPoint = (optimalnormal{1} + optimalnormal{5})/2;
text(midPoint(1), midPoint(2), midPoint(2), ['Angle: ' num2str(angleDeg) '°']);
%}
for k = 1:5
plot3([0 optimalnormal{k}(1)],[0 optimalnormal{k}(2)],[0 optimalnormal{k}(3)],colors(k), 'LineWidth', 5);
plot3([0 -optimalnormal{k}(1)],[0 -optimalnormal{k}(2)],[0 -optimalnormal{k}(3)],colors(k), 'LineWidth', 5);

x0 = 0;
y0 = 0;
z0 = 0;
pt1 = optimalcirclenormal{k}(1)
pt2 = optimalcirclenormal{k}(2)
x1 = pt1{1}(1);
y1 = pt1{1}(2);
z1 = pt1{1}(3);

x2 = pt2{1}(1);
y2 = pt2{1}(2);
z2 = pt2{1}(3);

% compute vectors
v1 = [x1-x0; y1-y0; z1-z0];       % Vector from center to 1st point
r = norm(v1);                          % The radius
v2 = [x2-x0;y2-y0;z2-z0];        % Vector from center to 2nd point
v3 = cross(cross(v1,v2),v1);     % v3 lies in plane of v1 & v2 and is orthog. to v1
v3 = r*v3/norm(v3);                % Make v3 of length r

t = linspace(0, 2*pi);
v = v1*cos(t) + v3*sin(t);
plot3(v(1,:)+x0, v(2,:)+y0, v(3,:)+z0, 'LineWidth', 2, 'Color', colors(k));

%{
if(k>=4)
    vpxLineNormal = co
    plot3(v(1,:)+x0, v(2,:)+y0, v(3,:)+z0, 'LineWidth', 2, 'Color', colors(k));
%}
end
%------------------------Rodrigues Rotation------------------------%
[remainingNormals_Rtd] = rodriguesRotation(optimalnormal{2}, remainingNormals, -90);
for i = 1:6
plot3([0 remainingNormals_Rtd(1,i)],[0 remainingNormals_Rtd(2,i)],[0 remainingNormals_Rtd(3,i)], 'o', 'Color' ,'k','LineWidth', 3);
end
%------------------------------------------------------------------%

pt1 = optimalnormal{4};
pt2 = optimalnormal{5};
crosSlpoe = cross(pt1,pt2);
crosSlpoe = crosSlpoe/norm(crosSlpoe);
plot3([0 crosSlpoe(1)],[0 crosSlpoe(2)],[0 crosSlpoe(3)],':','Color','k', 'LineWidth', 5);
f = FigureRotator(gca());

% plot lines in frame
figure
imshow(imRgb)
for k = 1:size(vpCells,2) %1~6
    for i = 1:size(vpCells{k},(1))/2 %number of line in each vp
        
        ptEnd1 = [vpCells{k}(2*i-1,1:2)];
        ptEnd2 = [vpCells{k}(2*i  ,1:2)];
        line([ptEnd1(1) ptEnd2(1)], [ptEnd1(2) ptEnd2(2)], 'Color', ...
            colors(k), 'LineWidth',5)
        
    end
end


