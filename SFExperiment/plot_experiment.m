
function [] = plot_experiment(R_cM_final, lines, imageCurForLine, cam)
proximityThreshold = deg2rad(3);
K = cam.K_pyramid(:,:,1);
Kinv = inv(K);
nonAssociatedLinesIdx = zeros(1,size(lines,1));
colors = {'r', 'g', 'b', 'c', 'm', 'y', 'k', [0, 0.4470, 0.7410], ... 
    [0.5, 0, 0.5], ... 
    [0, 0.5, 0.5], ... 
    [0.5, 0.5, 0], ... 
    [1, 0.75, 0.8], ... 
    [0.6, 0.4, 0.2], ... 
    [0.75, 0.75, 0.75], ... 
    [1, 1, 0.5], ... 
    [0.5, 0.5, 1]};
angle = deg2rad(5);

figure(1);
plot_unit_sphere(1, 18, 0.8); hold on; grid on; axis equal;
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
f = FigureRotator(gca());
numLines = size(lines,1);
for m = 1:3
    for k = 1:numLines

        % line pixel information
        linedata = lines(k,1:4);

        % normalized image plane
        ptEnd1_p_d = [linedata(1:2), 1].';
        ptEnd2_p_d = [linedata(3:4), 1].';
        ptEnd1_n_d = Kinv * ptEnd1_p_d;
        ptEnd2_n_d = Kinv * ptEnd2_p_d;
        ptEnd1_n_u = [undistortPts_normal(ptEnd1_n_d(1:2), cam); 1];
        ptEnd2_n_u = [undistortPts_normal(ptEnd2_n_d(1:2), cam); 1];

        % normal vector of great circle
        circleNormal = cross(ptEnd1_n_u.', ptEnd2_n_u.');
        circleNormal = circleNormal / norm(circleNormal);

        % LINE NORMALS
        %plot3([0 circleNormal(1)],[0 circleNormal(2)],[0 circleNormal(3)], 'o', 'Color' ,colors{k},'LineWidth', 2);
        % save the result
        greatcircleNormal(k,:) = circleNormal;
        greatcircleNormalSample = greatcircleNormal(k,:).';
        if (abs(acos(dot(R_cM_final(:,m), greatcircleNormalSample)) - pi/2) < proximityThreshold)
            nonAssociatedLinesIdx(k)=NaN;
        end
    end
end
%fileID = fopen('ManhattanVPs.txt','w');
%for m=1:3
%fprintf(fileID, ' VP%d %f %f %f\n', m, R_cM_final(1,m) ,R_cM_final(2,m), R_cM_final(3,m));
%end
nonAssociatedLines = find(~isnan(nonAssociatedLinesIdx));
numLines = size(nonAssociatedLines,2);
nonAssociatedNormals = zeros(numLines,3);
%fileID = fopen('./lines.txt','w');
for k = 1:numLines
%fprintf(fileID, '%f %f %f %f\n', lines(nonAssociatedLines(k),1) ,lines(nonAssociatedLines(k),2), lines(nonAssociatedLines(k),3), lines(nonAssociatedLines(k),4));
plot3([0 greatcircleNormal(nonAssociatedLines(k),1)],[0 greatcircleNormal(nonAssociatedLines(k),2)],[0 greatcircleNormal(nonAssociatedLines(k),3)], ':', 'Color' ,colors{k},'LineWidth', 4);
nonAssociatedNormals(k,:) = greatcircleNormal(nonAssociatedLines(k),:);
end
%-------------------------------------------SlopingRansac-------------------------------------------------------------%
[maxMatchingIdx, maxMatchingNum, maxPlaneModel] = slopingLineRANSAC(nonAssociatedNormals, angle)

x0 = 0;
y0 = 0;
z0 = 0;
pt1 = greatcircleNormal(maxMatchingIdx(1),:);
pt2 = greatcircleNormal(maxMatchingIdx(2),:);
x1 = pt1(1);
y1 = pt1(2);
z1 = pt1(3);

x2 = pt2(1);
y2 = pt2(2);
z2 = pt2(3);

% compute vectors
v1 = [x1-x0; y1-y0; z1-z0];       % Vector from center to 1st point
r = norm(v1);                          % The radius
v2 = [x2-x0;y2-y0;z2-z0];        % Vector from center to 2nd point
v3 = cross(cross(v1,v2),v1);     % v3 lies in plane of v1 & v2 and is orthog. to v1
v3 = r*v3/norm(v3);                % Make v3 of length r

t = linspace(0, 2*pi);
v = v1*cos(t) + v3*sin(t);
plot3(v(1,:)+x0, v(2,:)+y0, v(3,:)+z0, 'LineWidth', 2, 'Color', 'k');
plot3([0 0.207409534804215],[0 0.978254202583510],[0 0], 'Color' ,'m','LineWidth', 2);
%-------------------------------------------VPsXLineNormals-------------------------------------------------------------%
vpsXextraLineNormals = [];
for m = 1:3
    % VPS (In gist_union, 2 is the main horizontal direction)
    plot3([0 R_cM_final(1,m)],[0 R_cM_final(2,m)],[0 R_cM_final(3,m)],colors{m}, 'LineWidth', 5);
    plot3([0 -R_cM_final(1,m)],[0 -R_cM_final(2,m)],[0 -R_cM_final(3,m)],colors{m}, 'LineWidth', 5);
    for k = 1:numLines
    vpsXextraLineNormal = cross( greatcircleNormal(nonAssociatedLines(k),:) , R_cM_final(:,m) );
    vpsXextraLineNormal = vpsXextraLineNormal/norm(vpsXextraLineNormal);
        if m == 2
    %    vpsXextraLineNormals = [vpsXextraLineNormals vpsXextraLineNormal.'];
    %end
        % vpsXextraLineNormal
        %if( vpsXextraLineNormal(3) >= 0)
        plot3([0 vpsXextraLineNormal(1)],[0 vpsXextraLineNormal(2)],[0 vpsXextraLineNormal(3)], 'o', 'Color' ,colors{k},'LineWidth', 2);
        %else
        %    plot3([0 -vpsXextraLineNormal(1)],[0 -vpsXextraLineNormal(2)],[0 -vpsXextraLineNormal(3)], 'o', 'Color' ,colors(m),'LineWidth', 2);
        %end
        end
    end
end

%--------------------------------------------MaxStabbing------------------------------------------------------------%
figure(4)
[~, ~, planeNormalVector] = parametrizeVerticalDD(R_cM_final(:,2));
thetaIntervals = MaxStabbingIntervals(R_cM_final(:,2), nonAssociatedNormals.');
numIntervals = size(thetaIntervals,1);
% plot each MW theta interval
for k = 1:numIntervals
    
    % Manhattan world theta interval
    startPoint = thetaIntervals(k,1);
    endPoint = thetaIntervals(k,2);
    lineIndex = thetaIntervals(k,3);
    
    % plot each theta interval
    line([rad2deg(startPoint), rad2deg(endPoint)], [lineIndex, lineIndex],'Color',colors{lineIndex},'LineWidth',3.5);

end

%--------------------------------------------image-------------------------------------------------------------------------%
figure(3);
plot_image_show;