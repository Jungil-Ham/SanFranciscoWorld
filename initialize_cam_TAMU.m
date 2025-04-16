function [cam] = initialize_cam_TAMU(TUMRGBDdataset, maxPyramidLevel)
% camera calibration parameters from TUM RGBD dataset


% intrinsic camera calibration parameters
cam.K = TUMRGBDdataset.rgb.K;
cam.KD = TUMRGBDdataset.rgb.KD;
cam.k1 = TUMRGBDdataset.rgb.distortion(1);
cam.k2 = TUMRGBDdataset.rgb.distortion(2);
cam.p1 = TUMRGBDdataset.rgb.distortion(3);
cam.p2 = TUMRGBDdataset.rgb.distortion(4);
cam.p3 = TUMRGBDdataset.rgb.distortion(5);
cam.Ratio = TUMRGBDdataset.rgb.Ratio;
cam.dRatio = TUMRGBDdataset.rgb.dRatio;


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
cam.Rows = 480/TUMRGBDdataset.rgb.Ratio;
cam.Cols = 640/TUMRGBDdataset.rgb.Ratio;
cam.dRows = 480;
cam.dCols = 640;


% scale factor to recover depth image
cam.scaleFactor = TUMRGBDdataset.depth.scaleFactor;


end