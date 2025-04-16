function [meanRMM, sumRMM] = calcRMM(R_gc)

M = size(R_gc,3);
rotationMatrixMovement = zeros(1,M);

% rotation matrix movement (RMM)
for k = 2:M
    Rgc_previous = R_gc(:,:,k-1);
    Rgc_current = R_gc(:,:,k);
    
    rotationMatrixMovement(k) = acos((trace(Rgc_previous.' * Rgc_current)-1)/2) * (180/pi);
end
rotationMatrixMovement(1) = [];


% return rotation matrix movement
rotationMatrixMovement = real(rotationMatrixMovement);
meanRMM = mean(rotationMatrixMovement);
sumRMM = sum(rotationMatrixMovement);


end