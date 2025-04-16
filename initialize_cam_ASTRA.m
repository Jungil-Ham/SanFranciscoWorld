function [cam] = initialize_cam_ASTRA(maxPyramidLevel)
% camera calibration parameters from TUM RGBD dataset
fx = 462.025177*2;
fy = 462.025177*2;
cx = 323.529724*2;
cy = 187.010056*2;



intricsics = [fx,  0, cx; 0, fy, cy; 0,  0,  1];

% intrinsic camera calibration parameters
cam.K = intricsics;
cam.KD = intricsics/2;
cam.k1 = -0.029954;
cam.k2 = 0.059629;
cam.p1 = 0.000007;
cam.p2 = 0.000093;
cam.p3 = 0.0;


% intrinsic camera calibration K parameters for multi-level pyramid
K_pyramid = zeros(3,3,maxPyramidLevel);
K_pyramid(:,:,1) = cam.K;
KD_pyramid = zeros(3,3,maxPyramidLevel);
KD_pyramid(:,:,1) = cam.KD;

% perform pyramid reduction with average values
for k = 2:maxPyramidLevel
    K_pyramid(:,:,k) = downsampleKmatrix(K_pyramid(:,:,k-1));
end
cam.K_pyramid = K_pyramid;
for k = 2:maxPyramidLevel
    KD_pyramid(:,:,k) = downsampleKmatrix(KD_pyramid(:,:,k-1));
end
cam.KD_pyramid = KD_pyramid;


% image size parameters
cam.Rows = 720;
cam.Cols = 1280;
cam.dRows = 360;
cam.dCols = 640;


% scale factor to recover depth image
%cam.scaleFactor = TUMRGBDdataset.depth.scaleFactor;


end