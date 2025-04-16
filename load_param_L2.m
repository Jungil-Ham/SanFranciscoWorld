function [optsLPIC] = load_param_LPIC
% Project:   Line And Plane Odometry
% Function: load_param_LPIC
%
% Description:
%   get the initial parameters with respect to the algorithm
%
% Example:
%   OUTPUT:
%   optsLAPO: options for LAPO process like below
%
%   INPUT:
%
%
% NOTE:
%     The parameters below are initialized as the CVPR paper
%
% Author: Pyojin Kim
% Email: pjinkim1215@gmail.com
% Website:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% log:
% 2017-10-25: Complete
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%


% line detection and matching parameters
optsLPIC.lineDetector = 'lsd';     % 'gpa'
optsLPIC.lineDescriptor = 'lbd';
optsLPIC.lineLength = 300; 

optsLPIC.lineInlierThreshold =  10.0; %20.0; 8%LLong
optsLPIC.lineInlierThreshold_SLP = 5.0; %20.0;
optsLPIC.angleWeight = 0.7;
optsLPIC.lengthWeight = 0.3;
optsLPIC.minLineNum = 1;


% plane detection and tracking parameters
optsLPIC.imagePyramidLevel = 2;
optsLPIC.minimumDepth = 0.2;
optsLPIC.maximumDepth = 6;
optsLPIC.planeInlierThreshold = 0.005; %0.02
optsLPIC.cellsize = 1;
optsLPIC.minSampleRatio = 0.07;         %0.1

optsLPIC.numInitialization = 200;
optsLPIC.iterNum = 200;
optsLPIC.convergeAngle = deg2rad(0.001); %0.001
optsLPIC.halfApexAngle = deg2rad(4);
optsLPIC.c = 20;
optsLPIC.ratio = 0.1;


% translation RANSAC parameters
optsLPIC.translationInlierThreshold = 0.01;


% Kalman filter parameters
optsLPIC.initialVPAngleNoise = deg2rad(1);
optsLPIC.processNoise = deg2rad(0.2);
optsLPIC.measurementNoise = deg2rad(0.2);


optsLPIC.LShaped = 1;
optsLPIC.startIdx = 1216; 

end






