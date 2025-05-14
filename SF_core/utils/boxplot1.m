clc;
clear all;
close all;

load("LPIC_.mat","R_gc_LPIC","R_gc_true");

startAt = 2406;
% convert new global frame only for good view
R_gnew_g = [0 0 -1; 1 0 0; 0 -1 0];
i = 1;
% camera orientation
for k = startAt+1:2982
if(~(R_gc_LPIC(:,:,k)==zeros(3,3)))
camDir_estimated(:,:,i) = R_gnew_g * R_gc_LPIC(:,:,k);
% camera orientation
camDir_true(:,:,i) = R_gnew_g * R_gc_true(:,:,k);
i=i+1;
end
end

[meanRMD, RMD, rotationMatrixDifference] = calcRMD_orin(camDir_estimated, camDir_true);