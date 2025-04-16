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
expCase = 11; % stairScene
colors = {'r', 'g', 'b', 'c', 'm', 'y'};
% are figures drawn?
% 1 : yes, draw figures to see current status
% 0 : no, just run LPIC
toVisualize = 1;

% are data results saved?
% 1 : yes, save the variables and results
% 0 : no, just run LPIC
toSave = 1;


setupParams_STSC;


% load ICL NUIM dataset data
rawICLNUIMdataset = rawSTSCdataset_load(datasetPath,M);
process_data(datasetPath);

% camera calibration parameters
[ICLNUIMdataset] = getSyncTUMRGBDdataset(rawICLNUIMdataset, imInit, M);
optsLPIC = load_param_LPIC;
cam = initialize_cam_STSC(ICLNUIMdataset, optsLPIC.imagePyramidLevel);

%% load ground truth data


% ground truth trajectory in ICL NUIM dataset
R_gc_true = zeros(3,3,M);
p_gc_true = zeros(3,M);
T_gc_true = cell(1,M);
for k = 1:M
    % camera body frame
    R_gc_true(:,:,k) = q2r(ICLNUIMdataset.vicon.q_gc_Sync(:,k));
    p_gc_true(:,k) = ICLNUIMdataset.vicon.p_gc_Sync(:,k);
    T_gc_true{k} = [ R_gc_true(:,:,k), p_gc_true(:,k);
        zeros(1,3),           1; ];
end
%{
% if (toVisualize)
    figure; hold on; axis equal;
    L = 0.1; % coordinate axis length
    A = [0 0 0 1; L 0 0 1; 0 0 0 1; 0 L 0 1; 0 0 0 1; 0 0 L 1]';
    
    for k = 1:10:M
        T = T_gc_true{k};
        B = T * A;
        plot3(B(1,1:2),B(2,1:2),B(3,1:2),'-r','LineWidth',1); % x: red
        plot3(B(1,3:4),B(2,3:4),B(3,3:4),'-g','LineWidth',1); % y: green
        plot3(B(1,5:6),B(2,5:6),B(3,5:6),'-b','LineWidth',1); % z: blue
    end
    plot3(p_gc_true(1,:),p_gc_true(2,:),p_gc_true(3,:),'k','LineWidth',2);
    
    title('ground truth trajectory of cam0 frame')
    xlabel('x'); ylabel('y'); zlabel('z');
end
%}

% generate ground truth trajectory in vector form
stateTrue = zeros(6,M);
stateTrue(1:3,:) = p_gc_true;
for k = 1:size(p_gc_true,2)
    [yaw, pitch, roll] = dcm2angle(R_gc_true(:,:,k));
    stateTrue(4:6,k) = [roll; pitch; yaw];
end


%% main LPIC part

startAt = optsLPIC.startIdx;
% 1. Manhattan frame tracking for LPIC
systemInited_LPIC = false;

R_gc1 = R_gc_true(:,:,startAt);
R_gc_LPIC = zeros(3,3,M);
R_gc_LPIC(:,:,1) = R_gc1;


% 2. make figures to visualize current status
if (toVisualize)
    % create figure
    h = figure(10);
    set(h,'Color',[1 1 1]);
    set(h,'Units','pixels','Position',[300 20 1300 900]);
    ha1 = axes('Position',[0.05,0.55 , 0.4,0.4]);
    axis off;
    ha2 = axes('Position',[0.55,0.55 , 0.4,0.4]);
    axis off;
    ha3 = axes('Position',[0.05,0.05 , 0.4,0.4]);
    axis off;
    ha4 = axes('Position',[0.55,0.05 , 0.4,0.4]);
    grid on; hold on;
end


% 3. record vpInfo variables
vpInfo_LPIC = cell(1,M);
pNV_LPIC = cell(1,M);


% do LPIC
for imgIdx = startAt:M
    %% 1. Manhattan frame tracking
    if imgIdx == 641
        fprintf("stop at 57");
    end
    % image
    imageCurForLine = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
    imageCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    depthCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
    confiCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'confi');
    depthCurForMW(confiCurForMW == 0 ) = 0;
    depthCurForMW(confiCurForMW == 1 ) = 0;
    %lines = readmatrix([datasetPath '/csv/' sprintf('%d', imgIdx) '_line.csv']);
    %lines = extractUniqueLines(lines, cam);
    lineLength = optsLPIC.lineLength;
    dimageCurForLine = double(imageCurForLine);
    
    [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
    %}
    %lines = readmatrix('ASTRA/color1_line.csv');
    if(isempty(lines))
        continue;
    end   
    lines = extractUniqueLines(lines, cam);
    
    
    %{ 
    % me_stair
    if(imgIdx == 122)
    newRow = [1831.20478413069 1168.59393232205 627.804550758460 29.9049008168026 0 0 0];
    lines(end+1, :) = newRow;
    end

    elseif(imgIdx == 138)
    newRow = [1839.6639439906 1351.98249708285 894.009918319719 96.5175029171528 0 0 0];
    lines(end+1, :) = newRow;
    elseif(imgIdx == 139)
    newRow = [1760.31330221704 1241.38681446908 916.81271878646 58.4696616102683 0 0 0];
    lines(end+1, :) = newRow;
    end
    
    if(imgIdx == 133 || imgIdx == 137 || imgIdx == 150 || imgIdx == 153 || imgIdx == 155 || imgIdx == 158)
        continue;
    end
    %}
    if(imgIdx == 1126 ||imgIdx == 1571 || imgIdx == 1570 || imgIdx == 1626 || imgIdx == 1628 || imgIdx == 508 || imgIdx == 505 || imgIdx == 483 || imgIdx == 477 || imgIdx == 475 || imgIdx == 472 || imgIdx == 467 || imgIdx == 510 || imgIdx == 508 || imgIdx == 505 || imgIdx == 433 || imgIdx == 572 || imgIdx == 558 || imgIdx == 528 || imgIdx == 510 || imgIdx == 575 || imgIdx == 577 || imgIdx == 483 || imgIdx == 477 || imgIdx == 474 || imgIdx == 472 || imgIdx == 467 || imgIdx == 245 || imgIdx == 274 || imgIdx == 297 || imgIdx == 340 || imgIdx == 373)
        continue;
    end
    %}
    %confiCurForMW = getImgInSTSCdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'conf');
    [imageCurForMW, depthCurForMW] = getImgPyramid(imageCurForMW, depthCurForMW, optsLPIC.imagePyramidLevel);
    
    
    % for the first time in this loop
    if (~systemInited_LPIC)
        % initialize and seek the dominant MF
        %[R_cM, vpInfo, pNV, sNV, sPP] = seekSanfranciscoWorld(imageCurForLine, imageCurForMW, depthCurForMW, cam, optsLPIC);
        [R_cM, R_SLP, pNV] = seekSanFranciscoWorld_MNPL(imageCurForLine, imageCurForMW, depthCurForMW, lines, cam, optsLPIC);
        
        R_c1M = R_cM(:,1:3);
        R_gM = R_gc1 * R_c1M;
        systemInited_LPIC = true;
        
        % initialize Kalman filter
        %[state] = initializeVPs(R_c1M, optsLPIC);
        
    elseif (systemInited_LPIC)
        
        % propagation step in KF
        %[state] = predictVPs(state, optsLPIC);
        R_SLP_old = R_SLP;
        % track Manhattan frame
        if(optsLPIC.LShaped == 0)
        [R_cM, R_SLP, vpInfo, pNV, sNV, sPP, clusteredLinesIdx, maxVoteSumIdx] = trackSanFranciscoWorld_2(R_cM, pNV,R_SLP, imageCurForLine, imageCurForMW, depthCurForMW,lines, cam, optsLPIC, imgIdx);
        else
        [R_cM, R_SLP, vpInfo, pNV, sNV, sPP, clusteredLinesIdx, maxVoteSumIdx] = trackSanFranciscoWorld_LShaped(R_cM, pNV,R_SLP, imageCurForLine, imageCurForMW, depthCurForMW,lines, cam, optsLPIC, imgIdx);
        end
        vpInfo_LPIC{imgIdx} = vpInfo;
        pNV_LPIC{imgIdx} = pNV;
        
        
    
        % correction step in KF
        %[state] = updateVPs(state, R_cM, optsLPIC);
        %[state, R_cM] = extractVPs(state);
        
        
        % update current camera pose
        [U,~,V] = svd([R_cM(:,1), R_cM(:,2), R_cM(:,3)]);
        R_cM = U * V';
        R_gc_current = R_gM * inv(R_cM);
        R_gc_LPIC(:,:,imgIdx) = R_gc_current;
    end
    
    
    %% 2. update 6 DoF camera pose and visualization
    fprintf('imgIdx: %d  \n', imgIdx);
    if (imgIdx >= startAt+1)
        % visualize current status
        plots_status_tracking;
    else
       plot_save_1st_frame;
    end
    
end

% convert camera pose representation
stateEsti_LPIC = zeros(3,M);
for k = 1:M
    [yaw, pitch, roll] = dcm2angle(R_gc_LPIC(:,:,k));
    stateEsti_LPIC(:,k) = [roll; pitch; yaw];
end


%% plot error metric value (RPE, ATE)


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

