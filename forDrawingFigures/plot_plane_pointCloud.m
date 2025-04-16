function plot_plane_pointCloud(planeNormalVector, surfaceNormalVector, surfacePixelPoint, imageCur, depthCur, cam, optsLPRVO)

% assign parameters
imageHeight = size(imageCur, 1);
imageWidth = size(imageCur, 2);
halfApexAngle = optsLPRVO.halfApexAngle;


%% project normal vectors to plane normal vector

numNormalVector = size(surfaceNormalVector, 2);
planeIndex = ones(1, numNormalVector) * -1000;


% projection on plane normal vector axis
R_cM = seekPlaneManhattanWorld(planeNormalVector);
R_Mc = R_cM.';
n_j = R_Mc * surfaceNormalVector;

% check within half apex angle
lambda = sqrt(n_j(1,:).*n_j(1,:) + n_j(2,:).*n_j(2,:));
index = find(lambda <= sin(halfApexAngle));
planeIndex(:, index) = 1;


%% plot 3D point cloud

% 3D points and colors
pcPoints = zeros(3,numNormalVector);
pcColors = zeros(3,numNormalVector);
ptCount = 0;
for k = 1:numNormalVector
    
    u = surfacePixelPoint(1,k);
    v = surfacePixelPoint(2,k);
    a = planeIndex(k);
    
    if (depthCur(v,u) >= 0.3 && depthCur(v,u) <= 10)
        ptCount = ptCount + 1;
        
        depth = depthCur(v,u);
        pcPoints(1,ptCount) = ((u - cam.K(1,3)) / cam.K(1,1)) * depth;
        pcPoints(2,ptCount) = ((v - cam.K(2,3)) / cam.K(2,2)) * depth;
        pcPoints(3,ptCount) = depth;
        
        if (a == 1)
            pcColors(1,ptCount) = 255;
            pcColors(2,ptCount) = 0;
            pcColors(3,ptCount) = 0;
        else
            pcColors(1,ptCount) = 100;
            pcColors(2,ptCount) = 100;
            pcColors(3,ptCount) = 100;
        end
    end
end
pcPoints(:,(ptCount+1):end) = [];
pcColors(:,(ptCount+1):end) = [];
pcSparsePoints = pcPoints(:,1:2:end);
pcSparseColors = pcColors(:,1:2:end) / 255;


% plot 3D point cloud results
scatter3(pcSparsePoints(1,:), pcSparsePoints(2,:), pcSparsePoints(3,:),...
    0.5*ones(1, size(pcSparseColors,2)), pcSparseColors.'); grid on; axis equal; axis off;


end