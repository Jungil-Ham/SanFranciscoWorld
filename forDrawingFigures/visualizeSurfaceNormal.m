function [normalImage] = visualizeSurfaceNormal(depthCur, surfaceNormalVector, surfacePixelPoint)


% re-map the scale from [-1,1] to [0,255]
surfaceNormalVector_remap = (255/2) * double(surfaceNormalVector) + (255/2);


% assign surface normals to normal image
imageHeight = size(depthCur,1);
imageWidth = size(depthCur,2);
normalImage = NaN(imageHeight,imageWidth);
for k = 1:size(surfacePixelPoint,2)
    
    % pixel position
    u = surfacePixelPoint(1,k);
    v = surfacePixelPoint(2,k);
    
    % surface normal
    normalImage(v,u,1) = surfaceNormalVector_remap(1,k);
    normalImage(v,u,2) = surfaceNormalVector_remap(2,k);
    normalImage(v,u,3) = surfaceNormalVector_remap(3,k);
end
normalImage = uint8(normalImage);


end

