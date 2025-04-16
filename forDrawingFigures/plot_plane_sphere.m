function plot_plane_sphere(planeNormalVector, surfaceNormalVector, optsLPRVO)

% assign parameters
halfApexAngle = optsLPRVO.halfApexAngle;


%% project normal vectors to plane normal vector

numNormalVector = size(surfaceNormalVector, 2);
planeIndex = ones(1, numNormalVector) * -1000;


% projection on plane normal vector axis
R_cM = seekPlaneManhattanWorld(planeNormalVector);
R_Mc = R_cM.';
n_j = R_Mc * surfaceNormalVector;

% check within half apex angle
lambda = sqrt(n_j(1,:).*n_j(1,:) + n_j(2,:).*n_j(2,:));
index = find(lambda <= sin(halfApexAngle));
planeIndex(:, index) = 1;


%% plot sphere compass results

planeAxisIndex = (planeIndex == 1);
otherIndex = (planeIndex == -1000);

planeAxisNV = surfaceNormalVector(:,planeAxisIndex);
otherNV = surfaceNormalVector(:,otherIndex);


% plot sphere compass results with normal vector points
plot_unit_sphere(1, 18, 0.1); hold on; grid on; axis equal;
plot3(planeAxisNV(1,:), planeAxisNV(2,:), planeAxisNV(3,:), 'r.');
plot3(otherNV(1,:), otherNV(2,:), otherNV(3,:), 'k.');
%plot_body_frame(R_cM, '-', 3); hold off;


end