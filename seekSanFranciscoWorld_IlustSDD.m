function [R_final, R_SLP, pNV] = seekSanFranciscoWorld_IlustSDD(imageCurForLine, imageCur, depthCur,lines, cam, optsLPIC)
colors = {'r', 'g', 'b', 'c', 'm', 'y', [0, 0.4470, 0.7410], [0, 0.4470, 0.7410], [0.5, 0, 0.5], [0, 0.5, 0.5], [0.5, 0.5, 0], [1, 0.75, 0.8], [0.6, 0.4, 0.2], [0.75, 0.75, 0.75], [1, 1, 0.5], [0.5, 0.5, 1], [0.587, 0.766, 0.628], [0.838, 0.698, 0.875], [0.360, 0.022, 0.132], [0.463, 0.069, 0.436], [0.416, 0.989, 0.289], [0.950, 0.965, 0.931], [0.875, 0.731, 0.508], [0.563, 0.028, 0.279], [0.563, 0.787, 0.181], [0.959, 0.210, 0.841], [0.612, 0.568, 0.395], [0.028, 0.775, 0.751], [0.324, 0.581, 0.114], [0.777, 0.219, 0.308]};
isLShaped = optsLPIC.LShaped;
% assign current parameters
lineDetector = optsLPIC.lineDetector;
lineDescriptor = optsLPIC.lineDescriptor;
lineLength = optsLPIC.lineLength;
K = cam.K_pyramid(:,:,1);
Kinv = inv(K);
minNumSlpSample=2;
VDDIdx = 3;
%% initialize and seek dominant 1-plane

% plane and surface normal vector
[pNV, ~] = estimatePlaneNormalRANSAC(imageCur, depthCur, cam, optsLPIC);
[sNV, sPP] = estimateSurfaceNormalGradient(imageCur, depthCur, cam, optsLPIC);

surfaceNormalVector = sNV;
surfacePixelPoint = sPP;
plot_unit_sphere(1, 18, 0.8); hold on; grid on; axis equal;
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
f = FigureRotator(gca());
plot_plane_sphere(pNV, sNV, optsLPIC);


[pNV, isTracked] = trackSinglePlane(pNV, sNV, optsLPIC);
figure(1)
plot_plane_image(pNV, surfaceNormalVector, surfacePixelPoint, imageCur, optsLPIC)
planeNormalVector = pNV;
if (isTracked == 0)
    disp('lost tracking!');
    planeNormalVector = [];
    R_cM = [];
    vpInfo = [];
    return;
end

[R, clusteredLinesIdx,maxVoteSumIdx] = detectOrthogonalLineRANSAC_IlustSDD(planeNormalVector, lines, Kinv, cam, optsLPIC);
figure(2);
imshow(imageCurForLine)
for k = 1:size(clusteredLinesIdx,2)
    linesInVP = lines(clusteredLinesIdx{k},:);
    numLinesInVP = size(linesInVP,1);
    for j = 1:numLinesInVP
    lines_2d = linesInVP(j,1:4); 
    line([lines_2d(1,1) lines_2d(1,3)], [lines_2d(1,2) lines_2d(1,4)], 'Color', ...
         colors{k}, 'LineWidth',5)
    end
end
title('Line Clustering')
%---------------------------------------------------%
h1 = figure(9);
nexttile
plot_planes_image(R, surfaceNormalVector, surfacePixelPoint, imageCur, optsLPIC)
title('Initial Manhattan Frame Detection')

for k = 1:size(clusteredLinesIdx,2)
    linesInVP = lines(clusteredLinesIdx{k},:);
    numLinesInVP = size(linesInVP,1);
    for j = 1:numLinesInVP
    lines_2d = linesInVP(j,1:4); 
    line([lines_2d(1,1) lines_2d(1,3)], [lines_2d(1,2) lines_2d(1,4)], 'Color', ...
         colors{k}, 'LineWidth',5)
    end
end
title('Line Clustering')
nexttile
imshow(imageCurForLine)
lines_2d = zeros(4,size(lines,1));
for k = 1:size(lines_2d,2)
    lines_2d(:,k) = lines(k,1:4); 
    line([lines_2d(1,k) lines_2d(3,k)], [lines_2d(2,k) lines_2d(4,k)], 'Color', ...
         'y', 'LineWidth',5) 
end
title('Line Segment Detection (all)')

line([lines_2d(1,maxVoteSumIdx) lines_2d(3,maxVoteSumIdx)], [lines_2d(2,maxVoteSumIdx) lines_2d(4,maxVoteSumIdx)], 'Color', ...
         'm', 'LineWidth',5)


numLines = size(lines,1);
greatcircleNormal = zeros(numLines,3);
lineEndPixelPoints = zeros(numLines,4);
centerPixelPoint = zeros(numLines,2);
lineLength = zeros(numLines,1);
% generate line normals
for m = 1:3
    for k = 1:numLines

        % line pixel information
        linedata = lines(k,1:4);
        centerpt = (linedata(1:2) + linedata(3:4))/2;
        length = sqrt((linedata(1)-linedata(3))^2 + (linedata(2)-linedata(4))^2);
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

        greatcircleNormal(k,:) = circleNormal;
        lineEndPixelPoints(k,:) = linedata;
        centerPixelPoint(k,:) = centerpt;
        lineLength(k) = length;
        %greatcircleNormalSample = greatcircleNormal(k,:).';
    end
end
%% find out Sloping Dominan Direction using Maxstabbing
figure(6)
imshow(imageCurForLine)
title("chosen line");
linesInVP = lines(maxVoteSumIdx,:);
lines_2d = linesInVP; 
line([lines_2d(1,1) lines_2d(1,3)], [lines_2d(1,2) lines_2d(1,4)], 'Color', ...
       'm', 'LineWidth',7);
% guess initial sloping dominant plane
[nonAssociatedIdx] = slpPlaneRANSAC(greatcircleNormal,R,cam);


figure(9);
nexttile
imshow(imageCurForLine)
lines_2d = zeros(4,size(nonAssociatedIdx,2));
for k = 1:size(lines_2d,2)
    lines_2d(:,k) = lines(nonAssociatedIdx(1,k),1:4); 
    line([lines_2d(1,k) lines_2d(3,k)], [lines_2d(2,k) lines_2d(4,k)], 'Color', ...
         colors{k}, 'LineWidth',5)
end
title('Line Segment Detection (MH Frame Excluded)')


%%-------------------------------------plot unit sphere and normals---------------------------------------%%

numUnLines = size(nonAssociatedIdx,(2));
nonAssociatedNormals = zeros(numUnLines,3);
for k = 1:numUnLines
    nonAssociatedNormals(k,:) = greatcircleNormal(nonAssociatedIdx(k),:);
end

hold off;
h1 = figure(4);
plot_unit_sphere(1, 18, 0.8); hold on; grid on; axis equal;
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
f = FigureRotator(gca());
for k = 1:3
    plot3([0 R(1,k)],[0 R(2,k)],[0 R(3,k)], 'Color' ,colors{k},'LineWidth', 5);
    plot3([0 -R(1,k)],[0 -R(2,k)],[0 -R(3,k)], 'Color' ,colors{k},'LineWidth', 5);
end
for k = 1:numUnLines
    plot3([0 greatcircleNormal(nonAssociatedIdx(k),1)],[0 greatcircleNormal(nonAssociatedIdx(k),2)],[0 greatcircleNormal(nonAssociatedIdx(k),3)], 'o', ...
   'Color' ,colors{k},'LineWidth', 4); hold on;
end

PHD = 2; %L1 1 %R_Ncheck % SD3
PHD = 1; %L1 2 short L2 1156
%PHD = 3;


%--------------------------------------------MaxStabbing------------------------------------------------------------%


[~, ~, planeNormalVector ] = parametrizeVerticalDD(R(:,PHD));
[thetaIntervals,offset] = MaxStabbingIntervals(planeNormalVector, R(:,mod(PHD+4,3)+1), nonAssociatedNormals.');

% do max stabbing
sortedThetaIntervals = sortEndPts(thetaIntervals);  % [start, end, lineID]
candidateProbes = maxStabbing(sortedThetaIntervals);

% find optimal single probe (for MW only)
[maxNumber1,maxIndex] = max(candidateProbes(3,:));
optimalProbe = mean(candidateProbes(1:2,maxIndex));
if optimalProbe > deg2rad(45)
    VDDIdx = mod(PHD+4,3)+1;
    VDD = R(:,VDDIdx);
else 
    VDDIdx = mod(PHD+3,3)+1;
    VDD = R(:,VDDIdx);
end
figure(9);
nexttile
title('MaxStabbing Result')
plot_theta_interval(thetaIntervals,optimalProbe,colors); hold on;
%--------------------------isLShaped-----------------------------------%
if(isLShaped)
numItLines = size(thetaIntervals,1);
remainingIdx = [];
count = 1;
for k = 1:numItLines
    if (thetaIntervals(k, 2) < optimalProbe - deg2rad(2)) || (thetaIntervals(k, 1) > optimalProbe + deg2rad(2))
        remainingIdx(count) = thetaIntervals(k, 3);
        remainingNormals(count,:) = nonAssociatedNormals(remainingIdx(count),:);
        line([rad2deg(thetaIntervals(k, 1)), rad2deg(thetaIntervals(k, 2))], [thetaIntervals(k, 3), thetaIntervals(k, 3)],'Color','k','LineWidth',3.5); hold on;
        count = count + 1;
    end
end
%remainingIdx = 2;

if (~isempty(remainingIdx))
[remainingNormals_Rtd] = rodriguesRotation(VDD, remainingNormals.', 90);
[thetaIntervals_Rtd,offset] = MaxStabbingIntervals(planeNormalVector, R(:,mod(PHD+4,3)+1), remainingNormals_Rtd);
% replace remaining idx intervals with renewed intervals
for k = 1:size(remainingIdx,2)
thetaIntervals(remainingIdx(k), 1:2) = thetaIntervals_Rtd(k,1:2);
end

plot_theta_intervalRtd(thetaIntervals,remainingIdx);

% do max stabbing 
sortedThetaIntervals = sortEndPts(thetaIntervals);  % [start, end, lineID]
candidateProbes = maxStabbing(sortedThetaIntervals);

% find optimal single probe (for MW only)
[maxNumber2,maxIndex] = max(candidateProbes(3,:));
optimalProbe = mean(candidateProbes(1:2,maxIndex));

numIntervals = size(thetaIntervals,1);
line([rad2deg(optimalProbe), rad2deg(optimalProbe)], [0 numIntervals],'Color','m','LineWidth',2);

str = sprintf('The stabs increased from %d to %d after vertical rotation.',maxNumber1,maxNumber2); 
text(1,numIntervals+1,str,'FontSize',15);
optimalProbe = mean(candidateProbes(1:2,maxIndex));
end
%optimalProbe = deg2rad(31.5); %Lshort ,Rot
%optimalProbe = deg2rad(32.1); %Llong ,N_Rckeck
end
%-------------------------------------------------------------------------%

if( maxNumber1 < 0 )
    R_final = R;
else    
    %%%%if auxDirection is vertical, do like below and if not, do opposite
    SDD = computeHorizontalDDfromTheta(planeNormalVector, offset+optimalProbe);
    R_final = [R(:,PHD) R(:,VDDIdx) R(:,6-PHD-VDDIdx) SDD];
    if(isLShaped==1)
        % 벡터 a를 벡터 b에 투영합니다.
        projection = dot(R_final(:,4), R_final(:,2)) * R_final(:,2);
        
        % 벡터 a의 벡터 b에 대한 대칭인 벡터 c를 계산합니다.
        R_final(:,5) = R_final(:,4) - 2 * projection;
        R_final(:,5) = R_final(:,5)/norm(R_final(:,5));
        VP_SLP = R_final(:,4:5);
        R_final(:,4:7) = [VP_SLP rodriguesRotation(R_final(:,2), VP_SLP, 90)];
        [voteSumTotal, slpIdx] = computeOrthogonalDistance_SLP(R_final(:,4:7), lineEndPixelPoints, centerPixelPoint, lineLength, cam, optsLPIC);
    else
        SDD = computeHorizontalDDfromTheta(planeNormalVector, offset-optimalProbe);
        SDD2 = computeHorizontalDDfromTheta(planeNormalVector, offset+optimalProbe);
        SDD2 = [SDD SDD2];
        R_final(:,4:5) = SDD2;
        [voteSumTotal, slpIdx] = computeOrthogonalDistance_SLP(SDD2, lineEndPixelPoints, centerPixelPoint, lineLength, cam, optsLPIC);
    end
    
    R_SLP = R_final;
    R_final = R_final(:,1:3);
    
end
slp_leng = size(R_SLP,2);
%{
hold off;
h1 = figure(8);
plot_unit_sphere(1, 20, 0.5); hold on; grid on; axis equal;
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
f = FigureRotator(gca());
for k = 1:slp_leng
    plot3([0 R_SLP(1,k)],[0 R_SLP(2,k)],[0 R_SLP(3,k)], 'Color' ,colors{k},'LineWidth', 2);
    plot3([0 -R_SLP(1,k)],[0 -R_SLP(2,k)],[0 -R_SLP(3,k)], 'Color' ,colors{k},'LineWidth', 2);
    if (k>3)
    VP1 = R_SLP(:,k);
    [~, ~, VP1 ] = parametrizeVerticalDD(VP1);
    beta = asin(VP1(3));
    alpha = atan(VP1(2)/VP1(1));
    params = parametrizeHorizontalDD([cos(alpha), sin(alpha), cos(beta), sin(beta)]);
    A1=params(1);B1=params(2);A2=params(3);B2=params(4);A3=params(5);B3=params(6); 
    pt1 = [A1;A2;A3];
    pt1 = pt1/norm(pt1);
    %plot3([0 pt1(1,1)],[0 pt1(2,1)],[0 pt1(3,1)],'o', 'Color' ,colors{k},'LineWidth', 2);
    pt2 = cross(VP1,pt1);
    pt2 = pt2/norm(pt2);

    t = linspace(0, 2*pi);
    v = pt1*cos(t) + pt2*sin(t); % v traces great circle path, relative to center

    % draw great circle on the unit sphere
    plot3(v(1,:)+0, v(2,:)+0, v(3,:)+0, 'LineWidth', 2, 'Color', colors{k});
    end
end
for k = 1:numUnLines
    plot3([0 greatcircleNormal(nonAssociatedIdx(k),1)],[0 greatcircleNormal(nonAssociatedIdx(k),2)],[0 greatcircleNormal(nonAssociatedIdx(k),3)], 'o', ...
   'Color' ,colors{k},'LineWidth', 4); hold on;
end
%}
%{
for k = 1:numLines
    plot3([0 greatcircleNormal(k,1)],[0 greatcircleNormal(k,2)],[0 greatcircleNormal(k,3)], 'o', ...
   'Color' ,colors{k},'LineWidth', 4); hold on;
    linedata = lines(k,:);
    ptEnd1_p_d = [linedata(1:2), 1].';
    ptEnd2_p_d = [linedata(3:4), 1].';
    ptEnd1_n_d = Kinv * ptEnd1_p_d;
    ptEnd2_n_d = Kinv * ptEnd2_p_d;
    ptEnd1_n_d = ptEnd1_n_d / norm(ptEnd1_n_d);
    ptEnd2_n_d = ptEnd2_n_d / norm(ptEnd2_n_d);
    plot_great_circle(ptEnd1_n_d, ptEnd2_n_d, 1, colors{k}, 'greatcircle');
end
%}
%plot_plane_sphere(pNV, sNV, optsLPIC); hold on;
clusteredLinesIdx = [clusteredLinesIdx slpIdx];
draw_figure_for_paper_IlustSDD;

figure(2);
imshow(imageCurForLine)
for k = 1:size(clusteredLinesIdx,2)
    linesInVP = lines(clusteredLinesIdx{k},:);
    numLinesInVP = size(linesInVP,1);
    for j = 1:numLinesInVP
    lines_2d = linesInVP(j,1:4); 
    line([lines_2d(1,1) lines_2d(1,3)], [lines_2d(1,2) lines_2d(1,4)], 'Color', ...
         colors{k}, 'LineWidth',5)
    end
end


end

