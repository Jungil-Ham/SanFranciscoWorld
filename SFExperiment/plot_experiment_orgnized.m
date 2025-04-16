
function [] = plot_experiment_orgnized(R_cM_final, lines, imageCurForLine, cam)

%%---------------------------Configuration------------------------------------%%
proximityThreshold = deg2rad(3);
K = cam.K_pyramid(:,:,1);
Kinv = inv(K);
nonAssociatedLinesIdx = zeros(1,size(lines,1));
colors = {'r', 'g', 'b', 'c', 'm', 'y', 'k', [0, 0.4470, 0.7410], ... 
    [0.5, 0, 0.5], ... 
    [0, 0.5, 0.5], ... 
    [0.5, 0.5, 0], ... 
    [1, 0.75, 0.8], ... 
    [0.6, 0.4, 0.2], ... 
    [0.75, 0.75, 0.75], ... 
    [1, 1, 0.5], ... 
    [0.5, 0.5, 1]};
angle = deg2rad(5);

%%------------------------------GaussianSphere----------------------------------%%
figure(1);
plot_unit_sphere(1, 18, 0.8); hold on; grid on; axis equal;
%{
str = {'":" : Line Normal of Unassociated Lines','"o" : The Center of Theta Interval'};
text(0.9,0.9,0.9,str,'FontSize',14)
text(0.9,0.8,0.9,'"-" : U vector','Color','magenta','FontSize',14)
%}
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
f = FigureRotator(gca());
numLines = size(lines,1);
for m = 1:3
    for k = 1:numLines

        % line pixel information
        linedata = lines(k,1:4);

        % normalized image plane
        ptEnd1_p_d = [linedata(1:2), 1].';
        ptEnd2_p_d = [linedata(3:4), 1].';
        ptEnd1_n_d = Kinv * ptEnd1_p_d;
        ptEnd2_n_d = Kinv * ptEnd2_p_d;
        ptEnd1_n_u = [undistortPts_normal(ptEnd1_n_d(1:2), cam); 1];
        ptEnd2_n_u = [undistortPts_normal(ptEnd2_n_d(1:2), cam); 1];

        % normal vector of great circle
        circleNormal = cross(ptEnd1_n_u.', ptEnd2_n_u.');
        circleNormal = circleNormal / norm(circleNormal);

        greatcircleNormal(k,:) = circleNormal;
        greatcircleNormalSample = greatcircleNormal(k,:).';
        if (abs(acos(dot(R_cM_final(:,m), greatcircleNormalSample)) - pi/2) < proximityThreshold)
            nonAssociatedLinesIdx(k)=NaN;
        end
    end
end

nonAssociatedLines = find(~isnan(nonAssociatedLinesIdx));
numLines = size(nonAssociatedLines,2);
nonAssociatedNormals = zeros(numLines,3);
%----------------plot sloping normals-------------------%

for k = 1:numLines
%plot3([0 greatcircleNormal(nonAssociatedLines(k),1)],[0 greatcircleNormal(nonAssociatedLines(k),2)],[0 greatcircleNormal(nonAssociatedLines(k),3)], ':', ...
%   'Color' ,colors{k},'LineWidth', 4);
nonAssociatedNormals(k,:) = greatcircleNormal(nonAssociatedLines(k),:);
end

% Create a legend for these lines

%-------------------------------------------SlopingRansac-------------------------------------------------------------%
[maxMatchingIdx, maxMatchingNum, maxPlaneModel] = slopingLineRANSAC(nonAssociatedNormals, angle);
plot_circle_ransac(nonAssociatedNormals,maxMatchingIdx,R_cM_final);
%-------------------------------------------VPsXLineNormals-------------------------------------------------------------%
plot_interval_center(R_cM_final,greatcircleNormal,nonAssociatedLines,colors);
%---------------------------------Prove the tracking theorem-----------%

%--------------------------------------------MaxStabbing------------------------------------------------------------%

[~, ~, planeNormalVector] = parametrizeVerticalDD(R_cM_final(:,2));
%[~, ~, planeNormalVector] = parametrizeVerticalDD(RR);
thetaIntervals = MaxStabbingIntervals_exp(planeNormalVector,R_cM_final(:,1), nonAssociatedNormals.');

% do max stabbing
sortedThetaIntervals = sortEndPts(thetaIntervals);  % [start, end, lineID]
candidateProbes = maxStabbing(sortedThetaIntervals);


% find optimal single probe (for MW only)
[~,maxIndex] = max(candidateProbes(3,:));
optimalProbe = mean(candidateProbes(1:2,maxIndex));
figure(5)
plot_theta_interval(thetaIntervals,optimalProbe,colors);

%--------------------------------------------image-------------------------------------------------------------------------%
figure(3);
plot_image_show(lines,nonAssociatedLines,imageCurForLine,colors);
