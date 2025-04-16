function [numInliersTotal, clusteredLineIdx, commonZeroIndices] = computeOrthogonalDistance_normalRANSAC(R_cM, lineEndPixelPoints, centerPixelPoint, lineLength, cam, optsLAPO)

% parameters for orthogonal distance with end points
lineInlierThreshold = optsLAPO.lineInlierThreshold;
minLineNum = 1;
K = cam.K_pyramid(:,:,1);


% pre-defined variables
numLines = size(lineEndPixelPoints,1);
numInliersTotal = zeros(1,3);
clusteredLineIdx = cell(1,3);
r = zeros(1,3);

% orthogonal distance with end points
for k = 1:3
    
    % skip VP from plane normal vector
    if (k == 1)
        continue;
    end
    
    
    % initial parameters
    VP = R_cM(:,k);
    VP_n = VP ./ VP(3);
    VP_p = K * VP_n;
    lineIdx = zeros(numLines,1);
    
    
    % find line inlier
    for m = 1:numLines
        
        % general line equation
        centerpt = centerPixelPoint(m,:);
        lineModel = estimateLineModel(VP_p(1:2), centerpt);
        A = lineModel(1);
        B = lineModel(2);
        C = lineModel(3);
        
        
        % orthogonal distance
        linedata = lineEndPixelPoints(m,:);
        denominator = sqrt(A^2 + B^2);
        d_pt1 = (abs(A*linedata(1) + B*linedata(2) + C) / denominator);
        d_pt2 = (abs(A*linedata(3) + B*linedata(4) + C) / denominator);
        d_error = (d_pt1 + d_pt2) / 2;
        if (d_error <= lineInlierThreshold)
            lineIdx(m) = 1;
        end
        r(k) = find(any(~lineIdx,2));
    end
    
    commonZeroIndices = intersect(intersect(r(1), r(2)), r(3));
    
    % save the results
    if (sum(lineIdx) >= minLineNum)
        numInliersTotal(k) = sum(lineIdx);
        clusteredLineIdx{k} = find(lineIdx == 1);
        lineEndPixelPoints(clusteredLineIdx{k},:) = NaN;
    else
        numInliersTotal(k) = 0;
        clusteredLineIdx{k} = [];
    end
end


end





