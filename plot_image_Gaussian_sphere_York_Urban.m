function plot_image_Gaussian_sphere_York_Urban(imageCurForRGB)

% load pre-saved image texture mapping matrix
load('textureMappingMatrix_York_Urban.mat');


% plot RGB image on the Gaussian unit sphere
warp(sphereX, sphereY, sphereZ, imageCurForRGB);


end


% % assign current parameters
% imageHeight = size(imageCurForRGB,1);
% imageWidth = size(imageCurForRGB,2);
% K = cam.K;
% Kinv = inv(K);
%
%
% % compute 3D position on the Gaussian sphere
% sphereX = zeros(imageHeight,imageWidth);
% sphereY = zeros(imageHeight,imageWidth);
% sphereZ = zeros(imageHeight,imageWidth);
% for v = 1:imageHeight
%     for u = 1:imageWidth
%
%         % current pixel position
%         pt_p_d = [u; v; 1];
%         pt_n_d = Kinv * pt_p_d;
%         pt_n_u = [undistortPts_normal(pt_n_d(1:2), cam); 1];
%         pt_n_u_norm = pt_n_u / norm(pt_n_u);
%
%         % save 3D position on the Gaussian sphere
%         sphereX(v,u) = pt_n_u_norm(1);
%         sphereY(v,u) = pt_n_u_norm(2);
%         sphereZ(v,u) = pt_n_u_norm(3);
%     end
% end
% save('textureMappingMatrix_York_Urban.mat','sphereX','sphereY','sphereZ');

