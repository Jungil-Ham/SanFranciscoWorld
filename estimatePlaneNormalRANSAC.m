function [planeNormalVector, planePixelPoint] = estimatePlaneNormalRANSAC(imageCur, depthCur, cam, optsLAPO)

% assign current image pyramid
L = optsLAPO.imagePyramidLevel;
K = cam.KD_pyramid(:,:,L);
Kinv = inv(K);


%% plane normal vector with RANSAC

% assign current camera parameters
imageHeight = size(imageCur, 1);
imageWidth = size(imageCur, 2);


% pixel and depth value
pixelPtsRef = zeros(3, imageHeight*imageWidth);
depthPtsRef = zeros(3, imageHeight*imageWidth);
pixelCnt = 0;
for v = 1:imageHeight
    for u = 1:imageWidth
        if ( (depthCur(v,u) >= optsLAPO.minimumDepth) && (depthCur(v,u) <= optsLAPO.maximumDepth) )
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
[planeIdx, ~, planeModel] = detectPlaneRANSAC(pointCloudRef, optsLAPO.planeInlierThreshold);
planePixelPoint = pixelPtsRef(:,planeIdx);
planeNormalVector = planeModel(1:3) / norm(planeModel(1:3));
planeNormalVector = planeNormalVector.';


end

