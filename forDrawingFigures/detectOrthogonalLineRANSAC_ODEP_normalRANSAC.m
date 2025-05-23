function [R_cM_final, clusteredLineIdx_final] = detectOrthogonalLineRANSAC_ODEP_normalRANSAC(planeNormalVector, lines, Kinv, cam, optsLAPO)

% line information for 1-line RANSAC
numLines = size(lines,1);
greatcircleNormal = zeros(numLines,3);
lineEndPixelPoints = zeros(numLines,4);
centerPixelPoint = zeros(numLines,2);
lineLength = zeros(numLines,1);
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
    
    % save the result
    greatcircleNormal(k,:) = circleNormal;
    lineEndPixelPoints(k,:) = linedata;
    centerPixelPoint(k,:) = centerpt;
    lineLength(k) = length;
end


%% 1-line RANSAC

% initialize RANSAC model parameters
totalLineNum = size(lines,1);
sampleLineNum = 1;
ransacMaxIterNum = 1000;
ransacIterNum = 50;
ransacIterCnt = 0;
proximityThreshold = deg2rad(3);

maxNumInliersTotal = 0;
isSolutionFound = 0;


% VP1 from plane normal vector
VP1 = planeNormalVector;


% do 1-line RANSAC
while (true)
    
    % sample 1 line feature
    [sampleIdx] = randsample(totalLineNum, sampleLineNum);
    greatcircleNormalSample = greatcircleNormal(sampleIdx,:).';
    
    
    % estimate VP2
    if (abs(acos(dot(VP1, greatcircleNormalSample)) - pi/2) < proximityThreshold)
        continue;
    end
    VP2 = cross(VP1, greatcircleNormalSample);
    VP2 = VP2 / norm(VP2);
    
    
    % estimate VP3
    VP3 = cross(VP1, VP2);
    VP3 = VP3 / norm(VP3);
    
    
    % estimate rotation model parameters
    R_cM_temporary = [VP1, VP2, VP3];
    
    
    % check number of inliers
    [numInliersTotal, clusteredLineIdx] = computeOrthogonalDistance_normalRANSAC(R_cM_temporary, lineEndPixelPoints, centerPixelPoint, lineLength, cam, optsLAPO);
    
    
    % save the large consensus set
    if (sum(numInliersTotal) >= maxNumInliersTotal)
        maxNumInliersTotal = sum(numInliersTotal);
        maxVoteSumIdx = sampleIdx;
        max_R_cM = R_cM_temporary;
        maxClusteringNum = (size(clusteredLineIdx{1},1) + size(clusteredLineIdx{2},1) + size(clusteredLineIdx{3},1));
        isSolutionFound = 1;
        
        
        % calculate the number of iterations (http://en.wikipedia.org/wiki/RANSAC)
        clusteringRatio = maxClusteringNum / totalLineNum;
        ransacIterNum = ceil(log(0.01)/log(1-(clusteringRatio)^sampleLineNum));
    end
    
    ransacIterCnt = ransacIterCnt + 1;
    if (ransacIterCnt >= ransacIterNum || ransacIterCnt >= ransacMaxIterNum)
        break;
    end
end


% re-formulate 1-line RANSAC result
if (isSolutionFound == 1)
    
    % get clustered lines
    [~, clusteredLineIdx] = computeOrthogonalDistance_normalRANSAC(max_R_cM, lineEndPixelPoints, centerPixelPoint, lineLength, cam, optsLAPO);
    R_cM_final = max_R_cM;
    clusteredLineIdx_final = clusteredLineIdx;
else
    R_cM_final = zeros(3);
    clusteredLineIdx_final = cell(1,3);
end


end

