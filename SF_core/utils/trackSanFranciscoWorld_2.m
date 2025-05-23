function [R_cM_final, R_SLP, vpInfo, planeNormalVector, surfaceNormalVector, surfacePixelPoint, clusteredLinesIdx, maxVoteSumIdx] = trackSanFranciscoWorld_2(R_cM_old, pNV_old,R_SLP_old, imageCurForLine, imageCur, depthCur,lines, cam, optsLPIC ,imgIdx)

colors = {'r', 'g', 'b', 'c', 'm', 'y'};
% assign current parameters
lineDetector = optsLPIC.lineDetector;
lineDescriptor = optsLPIC.lineDescriptor;
lineLength = optsLPIC.lineLength;
K = cam.K_pyramid(:,:,1);
Kinv = inv(K);
pNVIdx = 0;
alpha = deg2rad(31.5);
%% track (or reinitialize) dominant 1-plane

% track current plane
[sNV, sPP] = estimateSurfaceNormalGradient(imageCur, depthCur, cam, optsLPIC);
[pNV_new, isTracked] = trackSinglePlane(pNV_old, sNV, optsLPIC);
%if (isTracked == 0 || imgIdx == 1174 || imgIdx == 560 || imgIdx == 608) % me-stair
if (isTracked == 0 || imgIdx == 1127 || imgIdx == 1199 || imgIdx == 608) % me-stair
%if (isTracked == 0 || imgIdx == 270 || imgIdx == 631) % Rot1
    fprintf('Lost tracking! Re-intialize 1-plane normal vector. \n');
    [pNV_new, ~] = estimatePlaneNormalRANSAC(imageCur, depthCur, cam, optsLPIC);
    [pNV_new, isTracked] = trackSinglePlane(pNV_new, sNV, optsLPIC);
end
if (isTracked == 0)
error('TrackingError:NotTracked', 'Plane is not able to be tracked!!!');
end
[corrIdx, ~, find_Idx] = identyfyVP_large(R_cM_old, pNVIdx, pNV_new);
pNVIdx = corrIdx; 
planeNormalVector = pNV_new;
surfaceNormalVector = sNV;
surfacePixelPoint = sPP;


%% find Manhattan frame with 1-plane and 1-line
dimageCurForLine = double(imageCurForLine);

% do 1-line RANSAC
while (true)
    if (corrIdx == 0)
    figure(2);
    plot_plane_image(pNV_new, sNV, sPP, imageCur, optsLPIC)
    [R_cM_new, clusteredLinesIdx] = detectOrthogonalLineRANSAC_ODEP(planeNormalVector, lines, Kinv, cam, optsLPIC);
    [R_cM_new, R_SLP, pNV_old] = seekSanFranciscoWorld_RINT(imageCurForLine, imageCurForMW, depthCurForMW, lines, cam, optsLPIC);
    fprintf('MH Frame Reinitialized');
    end
    [R_cM_new, clusteredLinesIdx,R_SLP, maxVoteSumIdx, ransacIterCnt] = detectOrthogonalLine2RANSAC_ODEP(R_SLP_old, planeNormalVector, alpha, pNVIdx, lines, Kinv, cam, optsLPIC,imageCurForLine,imgIdx);
    if R_cM_new == zeros(3,3)
        R_cM_final = zeros(3,3);
        return;
    end
    fprintf('RANSAC 반복 횟수: %d\n', ransacIterCnt);
    %{
    imshow(imageCurForLine)
            title("Chosen Line");
            linesInVP = lines(sampleIdx,:);
                lines_2d = linesInVP; 
                line([lines_2d(1,1) lines_2d(1,3)], [lines_2d(1,2) lines_2d(1,4)], 'Color', ...
                    'm', 'LineWidth',7);
    
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
    figure(6)
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
    figure(6)
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
    hold on;
    %}

    
    linesVP = cell(1,5);
    for k = 1:5
        % current lines in VPs
        linesInVP = lines(clusteredLinesIdx{k},:);
        numLinesInVP = size(linesInVP,1);
        
        % line clustering for each VP
        line = struct('data',{},'length',{},'centerpt',{},'linenormal',{},'circlenormal',{});
        numLinesCnt = 0;
        for m = 1:numLinesInVP
            [linedata, centerpt, len, ~, linenormal, circlenormal] = roveFeatureGeneration(dimageCurForLine, linesInVP(m,1:4), Kinv, lineDescriptor);
            if (~isempty(linedata))
                numLinesCnt = numLinesCnt+1;
                line(numLinesCnt) = struct('data',linedata,'length',len,'centerpt',centerpt,'linenormal',linenormal,'circlenormal',circlenormal);
            end
        end
        
        % save line clustering results
        linesVP{k} = line;
    end
    
    
    %{
    % Manhattan frame matching
    oldMatchingList = zeros(3,1);
    for k = 1:4
        
        % old VP
        vp_old = R_cM_old(:,k);
        
        % new VP
        for m = 1:4
            if (abs(vp_old.' * R_cM_new(:,m)) > cos(deg2rad(5)))
                oldMatchingList(k) = m;
                break;
            end
        end
    end
    
    
    % stop condition
    if (sum(oldMatchingList == 0) == 0)
        break;
    else
        fprintf('Fail 1-line RANSAC. Try again. \n');
    end
    %}
    break;
end

%{
allNumbers = 1:size(lines,1);
AssociatedLinesIdx = [clusteredLinesIdx{1}', clusteredLinesIdx{2}', clusteredLinesIdx{3}'];
nonAssociatedLinesIdx = setdiff(allNumbers, AssociatedLinesIdx);

imshow(imageCurForLine,[]); hold on;
for k = 1:size(nonAssociatedLinesIdx,2)
    plot([lines(nonAssociatedLinesIdx(k),1),lines(nonAssociatedLinesIdx(k),3)],[lines(nonAssociatedLinesIdx(k),2),lines(nonAssociatedLinesIdx(k),4)],'LineWidth',2.5);
end
%}

% new Manhattan frame

R_cM_final = zeros(3,3);
R_cM_final = R_cM_new;

for k = 1:3
    %id = oldMatchingList(k);
    id = k;
    vp_c = R_cM_new(:,id);
    vp_c_old = R_cM_old(:,k);
    if (acos(vp_c.' * vp_c_old) < deg2rad(30))
        R_cM_final(:,k) = vp_c;
    else
        R_cM_final(:,k) = -vp_c;
    end
end

for k = 1:3
    %id = oldMatchingList(k);
    id = k;
    vp_c = R_SLP(:,id);
    vp_c_old = R_SLP_old(:,k);
    if (acos(vp_c.' * vp_c_old) < deg2rad(30))
        R_SLP(:,k) = vp_c;
    else
        R_SLP(:,k) = -vp_c;
    end
end


% initialize vpInfo
vpInfo = struct('n',{},'line',{},'index',{});
for k = 1:5
    %id = oldMatchingList(k);
    id = k;
    
    % current VP info
    lines = linesVP{id};
    numLine = size(lines,2);
    vpInfo(k) = struct('n',numLine,'line',lines,'index',k);
end


end