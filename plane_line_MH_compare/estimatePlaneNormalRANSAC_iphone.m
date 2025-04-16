function [planeNormalVector, planePixelPoint] = estimatePlaneNormalRANSAC_iphone(imageCur, depthCur, cam)

% assign current image pyramid

K = cam;
Kinv = inv(K);
minDepth = 0.01;
maxDepth = 1.5;
planeInlierThreshold = 0.02;
%% plane normal vector with RANSAC

% assign current camera parameters
imageHeight = size(depthCur, 1);
imageWidth = size(depthCur, 2);


% pixel and depth value
pixelPtsRef = zeros(3, imageHeight*imageWidth);
depthPtsRef = zeros(3, imageHeight*imageWidth);
pixelCnt = 0;
for v = 1:imageHeight
    for u = 1:imageWidth
        if ( (depthCur(v,u) >= minDepth) && (depthCur(v,u) <= maxDepth) )
            pixelCnt = pixelCnt + 1;
            
            pixelPtsRef(:,pixelCnt) = [u; v; 1]; %3d point가 normalized 평면에서 표현된 픽셀 넘버
            depthPtsRef(:,pixelCnt) = depthCur(v,u) * ones(3,1); %그 픽셀에 해당하는 깊이 값
        end
    end
end
pixelPtsRef(:,(pixelCnt+1):end) = [];
depthPtsRef(:,(pixelCnt+1):end) = [];


% 3D point cloud
normPtsRef = Kinv * pixelPtsRef;
pointCloudRef = normPtsRef .* depthPtsRef;


% do plane RANSAC
[planeIdx, ~, planeModel] = detectPlaneRANSAC(pointCloudRef, planeInlierThreshold);
planePixelPoint = pixelPtsRef(:,planeIdx);
planeNormalVector = planeModel(1:3) / norm(planeModel(1:3));
planeNormalVector = planeNormalVector.';


end

