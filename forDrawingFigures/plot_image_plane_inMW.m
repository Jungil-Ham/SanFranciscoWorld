function plot_image_plane_inMW(planeNormalVector, planeIndex, surfaceNormalVector, surfacePixelPoint, imageShow, optsLPRVO)

% assign parameters
imageHeight = size(imageShow,1);
imageWidth = size(imageShow,2);
halfApexAngle = optsLPRVO.halfApexAngle;


%% project normal vectors to plane normal vector

numNormalVector = size(surfaceNormalVector, 2);
surfaceAxisIndex = ones(1, numNormalVector) * -1000;


% projection on plane normal vector axis
R_cM = seekPlaneManhattanWorld(planeNormalVector);
R_Mc = R_cM.';
n_j = R_Mc * surfaceNormalVector;

% check within half apex angle
lambda = sqrt(n_j(1,:).*n_j(1,:) + n_j(2,:).*n_j(2,:));
index = find(lambda <= sin(halfApexAngle));
surfaceAxisIndex(:, index) = 1;


%% plot plane segmentation results

% plane RGB mask
planeRGBMask = uint8(zeros(imageHeight, imageWidth, 3));
for k = 1:numNormalVector
    
    % axis and u,v coordinates
    a = surfaceAxisIndex(k);
    u = surfacePixelPoint(1,k);
    v = surfacePixelPoint(2,k);
    
    if (a == 1)
        % red, green, blue
        if (planeIndex == 1)
            planeRGBMask(v,u,1) = 255;
            planeRGBMask(v,u,2) = 0;
            planeRGBMask(v,u,3) = 0;
        elseif (planeIndex == 2)
            planeRGBMask(v,u,1) = 0;
            planeRGBMask(v,u,2) = 255;
            planeRGBMask(v,u,3) = 0;
        elseif (planeIndex == 3)
            planeRGBMask(v,u,1) = 0;
            planeRGBMask(v,u,2) = 0;
            planeRGBMask(v,u,3) = 255;
        end
    else
        % white
        planeRGBMask(v,u,1) = 200;
        planeRGBMask(v,u,2) = 200;
        planeRGBMask(v,u,3) = 200;
    end
end


% plot plane segmentation results
imshow(imageShow, []); hold on;
h_planeRGBMask = imshow(planeRGBMask, []);
set(h_planeRGBMask, 'AlphaData', 0.50);


end