function [R_cM_optimal] = computeOptimalMF_SLP(R_cM_initial, planeNormalVector, angle)

% pre-defined variables
axisAngle = [planeNormalVector; angle];
R_axisAngle = vrrotvec2mat(axisAngle);


% initial R_cM
VP_x = R_cM_initial(:,1);
VP_y = R_cM_initial(:,2);
VP_z = R_cM_initial(:,3);
VP_s = R_cM_initial(:,4);
VP_s2 = R_cM_initial(:,5);
VP_s3 = R_cM_initial(:,6);
VP_s4 = R_cM_initial(:,7);



% rotate R_cM with axis-angle
VP_x = VP_x;
VP_y_rotated = R_axisAngle * VP_y;
VP_z_rotated = R_axisAngle * VP_z;
VP_s_rotated = R_axisAngle * VP_s;
VP_s2_rotated = R_axisAngle * VP_s2;
VP_s3_rotated = R_axisAngle * VP_s3;
VP_s4_rotated = R_axisAngle * VP_s4;
% optimal R_cM
R_cM_optimal = [VP_x, VP_y_rotated, VP_z_rotated, VP_s_rotated, VP_s2_rotated, VP_s3_rotated, VP_s4_rotated];


end

