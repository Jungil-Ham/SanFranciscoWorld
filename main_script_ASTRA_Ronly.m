clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;
addpath(genpath(pwd))
addpath('addon/lsd_1.6');
addpath('addon/lsd_1.6/Matlab');
addpath('MatlabProgressBar');
addpath('forDrawingFigures');

%% basic setup for LPIC

% choose the experiment case
% ICL NUIM dataset (1~8)
expCase = 4;

% are figures drawn?
% 1 : yes, draw figures to see current status
% 0 : no, just run LPIC
toVisualize = 1;

% are data results saved?
% 1 : yes, save the variables and results
% 0 : no, just run LPIC
toSave = 1;


setupParams_ASTRA;


% load ICL NUIM dataset data
%rawICLNUIMdataset = rawSTSCdataset_load_for_astra(datasetPath);
%process_data(datasetPath);

% camera calibration parameters
%[ICLNUIMdataset] = getSyncTUMRGBDdataset(rawICLNUIMdataset, imInit, M);
optsLPIC = load_param_LPIC_ASTRA;
cam = initialize_cam_ASTRA(optsLPIC.imagePyramidLevel);

%% main LPIC part


% 1. Manhattan frame tracking for LPIC
systemInited_LPIC = false;

R_gc1 = [1 0 0;0 1 0;0 0 1];
R_gc_LPIC = zeros(3,3,M);
R_gc_LPIC(:,:,1) = R_gc1;


    %{ 
%2. make figures to visualize current status
if (toVisualize)
    % create figure
    h = figure(10);
    set(h,'Color',[1 1 1]);
    set(h,'Units','pixels','Position',[300 50 1400 1050]);
    ha1 = axes('Position',[0.05,0.55 , 0.4,0.4]);
    axis off;
    ha2 = axes('Position',[0.55,0.55 , 0.4,0.4]);
    axis off;
    ha3 = axes('Position',[0.05,0.05 , 0.4,0.4]);
    axis off;
    ha4 = axes('Position',[0.55,0.05 , 0.4,0.4]);
    grid on; hold on;
end
%}

% 3. record vpInfo variables
vpInfo_LPIC = cell(1,M);
pNV_LPIC = cell(1,M);


% do LPIC
for imgIdx = 1:M
    %% 1. Manhattan frame tracking
    close all;
    % image
    imageCurForLine = getImgInASTRAdataset(datasetPath, cam, imgIdx, 'gray');
    imageCurForMW = getImgInASTRAdataset(datasetPath, cam, imgIdx, 'rgb');
    depthCurForMW = getImgInASTRAdataset(datasetPath, cam, imgIdx, 'depth');
   % confiCurForMW = getImgInASTRAdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'conf');
    lines = readmatrix([datasetPath '/csv/color' sprintf('%d', imgIdx) '_line.csv']);
    [imageCurForMW, depthCurForMW] = getImgPyramid(imageCurForMW, depthCurForMW, optsLPIC.imagePyramidLevel);
    
    
    % for the first time in this loop
    if (~systemInited_LPIC)
        
        % initialize and seek the dominant MF
        %[R_cM, vpInfo, pNV, sNV, sPP] = seekSanfranciscoWorld(imageCurForLine, imageCurForMW, depthCurForMW, cam, optsLPIC);
        [R_cM, R_SLP, pNV_old] = seekSanFranciscoWorld(imageCurForLine, imageCurForMW, depthCurForMW,lines, cam, optsLPIC);
        R_c1M = R_cM;
        R_gM = R_gc1 * R_c1M;
        systemInited_LPIC = true;
        
        % initialize Kalman filter
        [state] = initializeVPs(R_c1M, optsLPIC);
        
    elseif (systemInited_LPIC)
        
        % propagation step in KF
        [state] = predictVPs(state, optsLPIC);
        
        % track Manhattan frame
        [R_cM, R_SLP,pNV_old] = trackSanFranciscoWorld_2(R_cM, pNV_old,R_SLP, imageCurForLine, imageCurForMW, depthCurForMW,lines, cam, optsLPIC);
        %{
        vpInfo_LPIC{imgIdx} = vpInfo;
        pNV_LPIC{imgIdx} = pNV;
        
        % correction step in KF
        [state] = updateVPs(state, R_cM, optsLPIC);
        [state, R_cM] = extractVPs(state);
        
        
        % update current camera pose
        R_gc_current = R_gM * inv(R_cM);
        R_gc_LPIC(:,:,imgIdx) = R_gc_current;
        %}
    end
    
    
    %% 2. update 6 DoF camera pose and visualization
    %{
    if (imgIdx >= 2)
        % visualize current status
        plots_status_with_true_Ronly;
    end
    
    
end

% convert camera pose representation
stateEsti_LPIC = zeros(3,M);
for k = 1:M
    [yaw, pitch, roll] = dcm2angle(R_gc_LPIC(:,:,k));
    stateEsti_LPIC(:,k) = [roll; pitch; yaw];
end
    %}

%% plot error metric value (RPE, ATE)

%{
% 1) LPIC rotation estimation trajectory
figure;
subplot(3,1,1);
plot(stateTrue(4,:),'k','LineWidth',2); hold on; grid on;
plot(stateEsti_LPIC(1,:),'r','LineWidth',2); hold off; axis tight; ylabel('roll (rad)');
legend('True','LPIC Matlab');
subplot(3,1,2);
plot(stateTrue(5,:),'k','LineWidth',2); hold on; grid on;
plot(stateEsti_LPIC(2,:),'r','LineWidth',2); hold off; axis tight; ylabel('pitch (rad)');
subplot(3,1,3);
plot(stateTrue(6,:),'k','LineWidth',2); hold on; grid on;
plot(stateEsti_LPIC(3,:),'r','LineWidth',2); hold off; axis tight; ylabel('yaw (rad)');


% 2) calculate rotation matrix difference
[RMD_MEAN_LPIC, RMD_LPIC] = calcRMD(R_gc_LPIC, R_gc_true);
fprintf('MEAN of RMD [deg] : %f \n' , RMD_MEAN_LPIC);
fprintf('std. of RMD [deg] : %f \n' , std(RMD_LPIC));


% 3) draw figures for rotation matrix difference
figure;
plot(RMD_LPIC, 'r*'); hold on; grid on;
curve_x = 1:M;
p = polyfit(curve_x, RMD_LPIC, 3);
curve_y = polyval(p, curve_x); curve_y(curve_y < 0) = 0;
plot(curve_x, curve_y, 'g-', 'LineWidth',5); hold off; axis tight; ylabel('RMD (deg)');
legend('RMD', 'Fitting Curve','Location','northwest');

figure;
ploterrhist(RMD_LPIC, 'bins', 25);


%% save the experiment data for CVPR 2018

if (toSave)
    save([SaveDir '/LPIC.mat']);
end
%}

end
