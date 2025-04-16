function [R_final, R_SLP, pNV] = seekSanFranciscoWorld_RINT(imageCurForLine, imageCur, depthCur,lines, cam, optsLPIC)
colors = {'r', 'g', 'b', 'c', 'm', 'y', 'k', [0, 0.4470, 0.7410], [0.5, 0, 0.5], [0, 0.5, 0.5], [0.5, 0.5, 0], [1, 0.75, 0.8], [0.6, 0.4, 0.2], [0.75, 0.75, 0.75], [1, 1, 0.5], [0.5, 0.5, 1], [0.587, 0.766, 0.628], [0.838, 0.698, 0.875], [0.360, 0.022, 0.132], [0.463, 0.069, 0.436], [0.416, 0.989, 0.289], [0.950, 0.965, 0.931], [0.875, 0.731, 0.508], [0.563, 0.028, 0.279], [0.563, 0.787, 0.181], [0.959, 0.210, 0.841], [0.612, 0.568, 0.395], [0.028, 0.775, 0.751], [0.324, 0.581, 0.114], [0.777, 0.219, 0.308]};
isLShaped = 0;
% assign current parameters
lineDetector = optsLPIC.lineDetector;
lineDescriptor = optsLPIC.lineDescriptor;
lineLength = optsLPIC.lineLength;
K = cam.K_pyramid(:,:,1);
Kinv = inv(K);
minNumSlpSample=3;
VDDIdx = 3;
%% initialize and seek dominant 1-plane

% plane and surface normal vector
[pNV, ~] = estimatePlaneNormalRANSAC(imageCur, depthCur, cam, optsLPIC);
[sNV, sPP] = estimateSurfaceNormalGradient(imageCur, depthCur, cam, optsLPIC);
surfaceNormalVector = sNV;
surfacePixelPoint = sPP;

%plot_plane_image(pNV, sNV, sPP, imageCur, optsLPIC);
% refine plane normal vector
%[pNV, isTracked] = trackPlane(pNV, sNV, optsLPIC);
%{
numTrial = 100;
ConvergeAngle = 2/180*pi;
ConeAngle = 30/180*pi;
c = 20;
minNumSample = 400;% optimal;
[MF_can, MF, FindMF] = SeekMMF(sNV,numTrial,ConvergeAngle,ConeAngle,c,minNumSample);
ratio = 0.1;
R = ClusterMMF(MF_can,ratio);
R = R{1};
%[MF_can, MF, FindMF] = SeekMMF(normVectors,numTrial,ConvergeAngle,ConeAngle,c,minNumSample)
figure(10);
nexttile
plot_planes_image(R, surfaceNormalVector, surfacePixelPoint, imageCur, optsLPIC)
title('Initial Manhattan Frame Detection')
%}
[pNV, isTracked] = trackSinglePlane(pNV, sNV, optsLPIC);
plot_plane_image(pNV, surfaceNormalVector, surfacePixelPoint, imageCur, optsLPIC)
planeNormalVector = pNV;
if (isTracked == 0)
    disp('lost tracking!');
    planeNormalVector = [];
    R_cM = [];
    vpInfo = [];
    return;
end
%{
% line detection
dimageCurForLine = double(imageCurForLine);
if (strcmp(lineDetector,'lsd'))
    [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
elseif (strcmp(lineDetector,'gpa'))
    [lines, ~] = gpa(imageCurForLine, lineLength);
end
%}
%lines = readmatrix('ASTRA/color1_line.csv');
%lines = extractUniqueLines(lines, cam);

[R, clusteredLinesIdx,maxVoteSumIdx] = detectOrthogonalLineRANSAC_ODEP(planeNormalVector, lines, Kinv, cam, optsLPIC);

%---------------------------------------------------%
h1 = figure(9);
nexttile
plot_planes_image(R, surfaceNormalVector, surfacePixelPoint, imageCur, optsLPIC)
title('Initial Manhattan Frame Detection')


%Line Segment Detection (all) magenta : RANSAC sampleIdx
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
h1 = figure(4);
plot_unit_sphere(1, 18, 0.8); hold on; grid on; axis equal;
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
f = FigureRotator(gca());
for k = 1:3
    plot3([0 R(1,k)],[0 R(2,k)],[0 R(3,k)], 'Color' ,colors{k},'LineWidth', 5);
end

numUnLines = size(nonAssociatedIdx,(2));
nonAssociatedNormals = zeros(numUnLines,3);


for k = 1:numUnLines
plot3([0 greatcircleNormal(nonAssociatedIdx(k),1)],[0 greatcircleNormal(nonAssociatedIdx(k),2)],[0 greatcircleNormal(nonAssociatedIdx(k),3)], ':', ...
   'Color' ,colors{k},'LineWidth', 4); hold on;
    nonAssociatedNormals(k,:) = greatcircleNormal(nonAssociatedIdx(k),:);
end
%plot_circle_ransac(nonAssociatedNormals,maxMatchingIdx); hold on;

% guess the primary horizontal direction
%{
for k=1:3
    if (abs(abs(acos(dot(R(:,k),maxPlaneModel)/norm(R(:,k))/norm(maxPlaneModel)))-pi/2) < deg2rad(10))
        PHD = k;
    end
end
%}
PHD = 1;


%--------------------------------------------MaxStabbing------------------------------------------------------------%


[~, ~, planeNormalVector ] = parametrizeVerticalDD(R(:,PHD));
[thetaIntervals,offset] = MaxStabbingIntervals(planeNormalVector, R(:,mod(PHD+3,3)+1), nonAssociatedNormals.');

% do max stabbing
sortedThetaIntervals = sortEndPts(thetaIntervals);  % [start, end, lineID]
candidateProbes = maxStabbing(sortedThetaIntervals);

% find optimal single probe (for MW only)
[maxNumber1,maxIndex] = max(candidateProbes(3,:));
optimalProbe = mean(candidateProbes(1:2,maxIndex));
if optimalProbe > deg2rad(45)
    VDDIdx = mod(PHD+3,3)+1;
    VDD = R(:,VDDIdx);
else 
    VDDIdx = mod(PHD+4,3)+1
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



[remainingNormals_Rtd] = rodriguesRotation(VDD, remainingNormals.', 90);
[thetaIntervals_Rtd,offset] = MaxStabbingIntervals(planeNormalVector, R(:,mod(PHD+3,3)+1), remainingNormals_Rtd);
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
%-------------------------------------------------------------------------%
hold off;

if( maxNumber1 < minNumSlpSample )
    R_final = R;
else    
    %%%%if auxDirection is vertical, do like below and if not, do opposite
    SDD = computeHorizontalDDfromTheta(planeNormalVector, offset-optimalProbe);
    SDD2 = computeHorizontalDDfromTheta(planeNormalVector, offset+optimalProbe);
    if(isLShaped==1)
    SDD = rodriguesRotation_unit(VDD, SDD, 90);
    end
    SDD2 = [SDD SDD2];
    [voteSumTotal, slpIdx] = computeOrthogonalDistance_SLP(SDD2, lineEndPixelPoints, centerPixelPoint, lineLength, cam, optsLPIC);
    figure(h1); 
    hold on;
    plot3([0 SDD(1)],[0 SDD(2)],[0 SDD(3)],'Color','c' ,'LineWidth', 6);
    %plot3([0 SDD2(1)],[0 SDD2(2)],[0 SDD2(3)],'Color','m' ,'LineWidth', 6);
    R_final = [R(:,PHD) R(:,VDDIdx) R(:,6-PHD-VDDIdx) SDD];
    R_SLP = [R(:,PHD) R(:,VDDIdx) R(:,6-PHD-VDDIdx) SDD2];
end
clusteredLinesIdx = [clusteredLinesIdx slpIdx];

figure(8);
imshow(imageCurForLine)
for k = 1:5
    linesInVP = lines(clusteredLinesIdx{k},:);
    numLinesInVP = size(linesInVP,1);
    for j = 1:numLinesInVP
    lines_2d = linesInVP(j,1:4); 
    line([lines_2d(1,1) lines_2d(1,3)], [lines_2d(1,2) lines_2d(1,4)], 'Color', ...
         colors{k}, 'LineWidth',5)
    end
end
title('Line Clustering')

%{
% do 1-line RANSAC
[R_final, clusteredLinesIdx] = detectOrthogonalLineRANSAC_ODEP(planeNormalVector, lines, Kinv, cam, optsLPIC);
clusteredLinesIdx = [clusteredLinesIdx 
linesVP = cell(1,3);
for k = 1:3
    
    % current lines in VPs
    linesInVP = lines(clusteredLinesIdx{k},:);
    numLinesInVP = size(linesInVP,1);
    
    % line clustering for each VP
    lines = struct('data',{},'length',{},'centerpt',{},'linenormal',{},'circlenormal',{});
    numLinesCnt = 0;
    for m = 1:numLinesInVP
        [linedata, centerpt, len, ~, linenormal, circlenormal] = roveFeatureGeneration(dimageCurForLine, linesInVP(m,1:4), Kinv, lineDescriptor);
        if (~isempty(linedata))
            numLinesCnt = numLinesCnt+1;
            lines(numLinesCnt) = struct('data',linedata,'length',len,'centerpt',centerpt,'linenormal',linenormal,'circlenormal',circlenormal);
        end
    end
    
    % save line clustering results
    linesVP{k} = lines;
end


% initialize vpInfo
vpInfo = struct('n',{},'lines',{},'index',{});
for k = 1:3
    % current VP info
    lines = linesVP{k};
    numLine = size(lines,2);
    vpInfo(k) = struct('n',numLine,'lines',lines,'index',k);
end

%}
end

