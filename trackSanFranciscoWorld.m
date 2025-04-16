function [R_cM_final, R] = trackSanFranciscoWorld(R_cM_old, R_old, imageCurForLine, imageCur, depthCur, cam, optsLPIC)
colors = {'r', 'g', 'b', 'c', 'm', 'y', 'k', [0, 0.4470, 0.7410], [0.5, 0, 0.5], [0, 0.5, 0.5], [0.5, 0.5, 0], [1, 0.75, 0.8], [0.6, 0.4, 0.2], [0.75, 0.75, 0.75], [1, 1, 0.5], [0.5, 0.5, 1], [0.587, 0.766, 0.628], [0.838, 0.698, 0.875], [0.360, 0.022, 0.132], [0.463, 0.069, 0.436], [0.416, 0.989, 0.289], [0.950, 0.965, 0.931], [0.875, 0.731, 0.508], [0.563, 0.028, 0.279], [0.563, 0.787, 0.181], [0.959, 0.210, 0.841], [0.612, 0.568, 0.395], [0.028, 0.775, 0.751], [0.324, 0.581, 0.114], [0.777, 0.219, 0.308]};

% assign current parameters
lineDetector = optsLPIC.lineDetector;
lineLength = optsLPIC.lineLength;
K = cam.K_pyramid(:,:,1);
Kinv = inv(K);


%% track (or reinitialize) dominant 1-plane
% track current plane
[sNV, sPP] = estimateSurfaceNormalGradient(imageCur, depthCur, cam, optsLPIC);

ConvergeAngleforTracking = 0.01/180*pi;
ConeAngle_tracking = 10/180*pi;
c = 20;
minNumSample = 100;% optimal;
[R_new,IsTracked,~,numF] = TrackingMF(R_old,sNV,ConvergeAngleforTracking,ConeAngle_tracking,c,minNumSample);
numF


if (IsTracked == 0)
    fprintf('Lost tracking! Re-intialize 1-plane normal vector. \n');
    [pNV_new, ~] = estimatePlaneNormalRANSAC(imageCur, depthCur, cam, optsLPIC);
    %optsLPIC.minSampleRatio = 0.05;
    [pNV_new, ~] = trackSinglePlane(pNV_new, sNV, optsLPIC);
end


% line detection
dimageCurForLine = double(imageCurForLine);
if (strcmp(lineDetector,'lsd'))
    [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
elseif (strcmp(lineDetector,'gpa'))
    [lines, ~] = gpa(imageCurForLine, lineLength);
end
lines = extractUniqueLines(lines, cam);

nexttile
imshow(imageCurForLine)
lines_2d = zeros(4,size(lines,1));
for k = 1:size(lines_2d,2)
    lines_2d(:,k) = lines(k,1:4); 
    line([lines_2d(1,k) lines_2d(3,k)], [lines_2d(2,k) lines_2d(4,k)], 'Color', ...
         'y', 'LineWidth',5)
        
end
numLines = size(lines,1);
% generate line normals
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

        greatcircleNormal(k,:) = circleNormal;
        %greatcircleNormalSample = greatcircleNormal(k,:).';
    end
end
%% find out Sloping Dominan Direction using Maxstabbing

% guess initial sloping dominant plane
[nonAssociatedIdx,maxMatchingIdx,maxPlaneModel] = slpPlaneRANSAC(greatcircleNormal,R_old,cam);

nexttile
imshow(imageCurForLine)
lines_2d = zeros(4,size(nonAssociatedIdx,2));
for k = 1:size(lines_2d,2)
    lines_2d(:,k) = lines(nonAssociatedIdx(1,k),1:4); 
    line([lines_2d(1,k) lines_2d(3,k)], [lines_2d(2,k) lines_2d(4,k)], 'Color', ...
         colors{k}, 'LineWidth',5)
        
end


%%-------------------------------------plot unit sphere and normals---------------------------------------%%
h1 = figure(4);
plot_unit_sphere(1, 18, 0.8); hold on; grid on; axis equal;
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
f = FigureRotator(gca());
for k = 1:3
    plot3([0 R_old(1,k)],[0 R_old(2,k)],[0 R_old(3,k)], 'Color' ,colors{k},'LineWidth', 5);
end

numUnLines = size(nonAssociatedIdx,(2));
nonAssociatedNormals = zeros(numUnLines,3);

for k = 1:numUnLines
plot3([0 greatcircleNormal(nonAssociatedIdx(k),1)],[0 greatcircleNormal(nonAssociatedIdx(k),2)],[0 greatcircleNormal(nonAssociatedIdx(k),3)], ':', ...
   'Color' ,colors{k},'LineWidth', 4); hold on;
    nonAssociatedNormals(k,:) = greatcircleNormal(nonAssociatedIdx(k),:);
end
plot_circle_ransac(nonAssociatedNormals,maxMatchingIdx); hold on;

% guess the primary horizontal direction
for k=1:3
    if (abs(abs(acos(dot(R_old(:,k),maxPlaneModel)/norm(R_old(:,k))/norm(maxPlaneModel)))-pi/2) < deg2rad(10))
        PHD = k;
    end
end



%--------------------------------------------MaxStabbing------------------------------------------------------------%


[~, ~, planeNormalVector] = parametrizeVerticalDD(R(:,PHD));
[thetaIntervals,offset] = MaxStabbingIntervals(planeNormalVector, R(:,2), nonAssociatedNormals.');

% do max stabbing
sortedThetaIntervals = sortEndPts(thetaIntervals);  % [start, end, lineID]
candidateProbes = maxStabbing(sortedThetaIntervals);

% find optimal single probe (for MW only)
[~,maxIndex] = max(candidateProbes(3,:));
optimalProbe = mean(candidateProbes(1:2,maxIndex));

figure(10);
nexttile
plot_theta_interval(thetaIntervals,optimalProbe,colors); hold on;

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



if optimalProbe > deg2rad(45)
    VDD = R(:,2);
else 
    VDD = R(:,3);
end

[remainingNormals_Rtd] = rodriguesRotation(VDD, remainingNormals.', -90);
[thetaIntervals,offset] = MaxStabbingIntervals(planeNormalVector, R(:,2), remainingNormals_Rtd);

% do max stabbing
sortedThetaIntervals = sortEndPts(thetaIntervals);  % [start, end, lineID]
candidateProbes = maxStabbing(sortedThetaIntervals);
plot_theta_intervalRtd(thetaIntervals,remainingIdx); 
hold off;
% find optimal single probe (for MW only)
[maxNumber,maxIndex] = max(candidateProbes(3,:));

%nonAssociatedNormals = [nonAssociatedNormals remainingNormals_Rtd];
%}
if( maxNumber < minNumSlpSample )
    R_final = R;
else    
    optimalProbe = mean(candidateProbes(1:2,maxIndex));
    SDD = computeHorizontalDDfromTheta(R(:,PHD), optimalProbe+offset);
    figure(h1); 
    hold on;
    plot3([0 SDD(1)],[0 SDD(2)],[0 SDD(3)],'Color','c' ,'LineWidth', 4);
    R_final = [R SDD];
end

end