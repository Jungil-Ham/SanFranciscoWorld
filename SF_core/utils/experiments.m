clc;
close all;
clear all;
addpath('SFExperiment');
addpath('Interval_Stabbing')
addpath('forDrawingFigures')
load('plot_VPsxExtraLines');
plot_experiment_orgnized(R_cM_final, lines, imageCurForLine, cam);
