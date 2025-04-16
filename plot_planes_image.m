function plot_planes_image(R, surfaceNormalVector, surfacePixelPoint, imageShow, optsLPIC)

% assign parameters
imageHeight = size(imageShow, 1);
imageWidth = size(imageShow, 2);
halfApexAngle = optsLPIC.halfApexAngle;



%% project normal vectors to plane normal vector

numNormalVector = size(surfaceNormalVector, 2);
planeIndex = ones(1, numNormalVector) * -1000;

for m = 1:3
% projection on plane normal vector axis
planeNormalVector = R(:,m);
R_cM = seekPlaneManhattanWorld(planeNormalVector);
R_Mc = R_cM.';
n_j = R_Mc * surfaceNormalVector;

% check within half apex angle
lambda = sqrt(n_j(1,:).*n_j(1,:) + n_j(2,:).*n_j(2,:));
index = find(lambda <= sin(halfApexAngle));
planeIndex(:, index) = m;
idxSize(m) = size(index,2);
end

%% plot plane segmentation results

% plane RGB mask
planeRGBMask = uint8(zeros(imageHeight, imageWidth, 3));
for k = 1:numNormalVector
    
    tempPixel = surfacePixelPoint(:,k);
    a = planeIndex(k);
    
    if (a == 1)
        % red
        for m = 1:size(tempPixel, 2)
            u = tempPixel(1,m);
            v = tempPixel(2,m);
            planeRGBMask(v,u,1) = 255;
            planeRGBMask(v,u,2) = 0;
            planeRGBMask(v,u,3) = 255;
        end
    elseif (a == 2)
        % 
        for m = 1:size(tempPixel, 2)
            u = tempPixel(1, m);
            v = tempPixel(2, m);
            planeRGBMask(v,u,1) = 255;
            planeRGBMask(v,u,2) = 255;
            planeRGBMask(v,u,3) = 0;
        end
    elseif (a == 3)
        % 
        for m = 1:size(tempPixel, 2)
            u = tempPixel(1, m);
            v = tempPixel(2, m);
            planeRGBMask(v,u,1) = 0;
            planeRGBMask(v,u,2) = 255;
            planeRGBMask(v,u,3) = 255;
        end
    else 
        for m = 1:size(tempPixel, 2)
            u = tempPixel(1, m);
            v = tempPixel(2, m);
            planeRGBMask(v,u,1) = 150;
            planeRGBMask(v,u,2) = 150;
            planeRGBMask(v,u,3) = 150;
        end
    end
end


% plot plane segmentation results
t = tiledlayout(2,2);
nexttile
imshow(imageShow, []); hold on;
h_planeRGBMask = imshow(planeRGBMask, []);
set(h_planeRGBMask, 'AlphaData', 0.5);


end