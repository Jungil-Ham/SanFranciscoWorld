function [R_cM, vpInfo, planeNormalVector, surfaceNormalVector, surfacePixelPoint] = seekManhattanWorld(imageCurForLine, imageCur, depthCur, cam, optsLPIC,lines)

% assign current parameters
lineDetector = optsLPIC.lineDetector;
lineDescriptor = optsLPIC.lineDescriptor;
lineLength = optsLPIC.lineLength;
K = cam.K_pyramid(:,:,1);
Kinv = inv(K);
colors = {'r', 'g', 'b', 'c', 'm', 'y'};

%% initialize and seek dominant 1-plane

% plane and surface normal vector
[pNV, ~] = estimatePlaneNormalRANSAC(imageCur, depthCur, cam, optsLPIC);
[sNV, sPP] = estimateSurfaceNormalGradient(imageCur, depthCur, cam, optsLPIC);
surfaceNormalVector = sNV;
surfacePixelPoint = sPP;

%plot_plane_image(pNV, sNV, sPP, imageCur, optsLPIC);
% refine plane normal vector
[pNV, isTracked] = trackSinglePlane(pNV, sNV, optsLPIC);
planeNormalVector = pNV;
if (isTracked == 0)
    disp('lost tracking!');
    planeNormalVector = [];
    R_cM = [];
    vpInfo = [];
    return;
end


%% find Manhattan frame with 1-plane and 1-line

% line detection
dimageCurForLine = double(imageCurForLine);
%{
if (strcmp(lineDetector,'lsd'))
    [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
elseif (strcmp(lineDetector,'gpa'))
    [lines, ~] = gpa(imageCurForLine, lineLength);
end
lines = extractUniqueLines(lines, cam);
%}
load('Lines_U_1.mat',"vp1","vp2","vp3","vp4","vp5","vp6");
vpCells ={vp1, vp2, vp3, vp4, vp5};
aa = 1;
allCircleNormalcell = cell(1, size(vpCells, 2));
figure(3);
imshow(imageCurForLine)
for k = 1:size(vpCells,2) %1~6
    for i = 1:size(vpCells{k},(1))/2 %number of line in each vp  
    ptEnd1 = [vpCells{k}(2*i-1,1:2)];
    ptEnd2 = [vpCells{k}(2*i  ,1:2)];
    line([ptEnd1(1) ptEnd2(1)], [ptEnd1(2) ptEnd2(2)], 'Color', ...
        colors{k}, 'LineWidth',5)
    lines(aa,:) = [ptEnd1 ptEnd2];
    aa = aa+1;
    end
end
% do 1-line RANSAC
[R_cM, clusteredLinesIdx] = detectOrthogonalLineRANSAC_ODEP(planeNormalVector, lines, Kinv, cam, optsLPIC);
linesVP = cell(1,3);
for k = 1:3
    
    % current lines in VPs
    linesInVP = lines(clusteredLinesIdx{k},:);
    numLinesInVP = size(linesInVP,1);
    
    % line clustering for each VP
    lineS = struct('data',{},'length',{},'centerpt',{},'linenormal',{},'circlenormal',{});
    numLinesCnt = 0;
    for m = 1:numLinesInVP
        [linedata, centerpt, len, ~, linenormal, circlenormal] = roveFeatureGeneration(dimageCurForLine, linesInVP(m,1:4), Kinv, lineDescriptor);
        if (~isempty(linedata))
            numLinesCnt = numLinesCnt+1;
            lineS(numLinesCnt) = struct('data',linedata,'length',len,'centerpt',centerpt,'linenormal',linenormal,'circlenormal',circlenormal);
        end
    end
    
    % save line clustering results
    linesVP{k} = lineS;
end


% initialize vpInfo
vpInfo = struct('n',{},'line',{},'index',{});
for k = 1:3
    % current VP info
    lineS = linesVP{k};
    numLine = size(lineS,2);
    vpInfo(k) = struct('n',numLine,'line',lines,'index',k);
end
colors = {'r', 'g', 'b', 'c', 'm', 'y'};
figure(8);
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

end

