function plot_RMD_text(R_gc_true,R_cM, R_gc,imgIdx,optsLPIC)
startAt =  optsLPIC.startIdx;
% convert new global frame only for good view
R_gnew_g = [0 0 -1; 1 0 0; 0 -1 0];
i = 1;
if( imgIdx ==468) 
    fprintf('stop')
end
% camera orientation
for k = startAt+1:imgIdx
if(~(R_gc(:,:,k)==zeros(3,3)))
camDir_estimated(:,:,i) = R_gnew_g * R_gc(:,:,k);
% camera orientation
camDir_true(:,:,i) = R_gnew_g * R_gc_true(:,:,k);
i=i+1;
end
end
[meanRMD, RMD] = calcRMD(camDir_estimated, camDir_true);

% Plotting the meanRMD and RMD values as text on the current figure
% Choose appropriate x, y, z for text placement
% Setting text position to top of the graph
% Getting current axis limits
ax = axis; % ax = [xmin xmax ymin ymax zmin zmax]
x = (ax(1) + ax(2)) / 2; % Middle of the x-axis
y = ax(4) * 0.85; % Slightly below the top of the y-axis
z = 0; % Example z-coordinate for text placement, if using 3D plot
% Formatting text for display
meanRMDText = sprintf('Mean RMD: %.3f degrees', meanRMD);
RMDText = sprintf('RMD: [%s]', sprintf('%.5f ', RMD(end))) ;
% Displaying text on plot
text(x, y, z, meanRMDText, 'FontSize', 12, 'VerticalAlignment', 'bottom');
text(x, y, z, RMDText, 'FontSize', 12, 'VerticalAlignment', 'top');

end