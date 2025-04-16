function [maxMatchingIdx, maxMatchingNum, maxPlaneModel] = slopingLineRANSAC(greatcircleNormalRef, angle)

% initialize RANSAC model parameters
totalPointNum = size(greatcircleNormalRef, 1);
samplePointNum = 2;
ransacMaxIterNum = 1000;
ransacIterNum = 50;
ransacIterCnt = 0;

maxMatchingNum = 0;
maxMatchingIdx = [];

% do RANSAC with plane model
while (true)
    
    % sample 3 feature points
    [sampleIdx] = randsample(totalPointNum, samplePointNum);
    lineNormal = greatcircleNormalRef(sampleIdx,:);
    N1 = lineNormal(1,:).';
    N2 = lineNormal(2,:).';
    
    
    % estimate plane model parameters with 3 feature points
    normPlaneModel = estimateSlopingPlaneModel(N1,N2);
    
    % check number of inliers
    [matchingNum, goodMatchingIdx] = inThresforPlane_SLP(greatcircleNormalRef, normPlaneModel, angle);
    
    
    % save the large consensus set
    if (matchingNum > maxMatchingNum)
        maxMatchingNum = matchingNum;
        %maxMatchingIdx = goodMatchingIdx;
        maxPlaneModel = normPlaneModel;
        
        % calculate the number of iterations (http://en.wikipedia.org/wiki/RANSAC)
        matchingRatio = matchingNum / totalPointNum;
        ransacIterNum = ceil(log(0.01)/log(1-(matchingRatio)^samplePointNum));
    end
    
    ransacIterCnt = ransacIterCnt + 1;
    if (ransacIterCnt >= ransacIterNum || ransacIterCnt >= ransacMaxIterNum)        
        maxMatchingIdx = [sampleIdx',goodMatchingIdx];
        break;
    end
end


end






