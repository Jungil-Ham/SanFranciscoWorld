clc 
clear

datasetPath = './rgbd_dataset_gist_corridor';
textData_groundtruth = readmatrix([datasetPath '/odometry.csv'],'Range','B:I');