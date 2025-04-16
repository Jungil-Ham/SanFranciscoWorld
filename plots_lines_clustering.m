function plots_lines_clustering(R_cM, vpInfo, imageCurForLine, cam, optsLPIC)

% assign current parameters
L = optsLPIC.imagePyramidLevel;
imageHeight = size(imageCurForLine,1);
imageWidth = size(imageCurForLine,2);
ratio = cam.Cols/cam.dCols;
ratio = 1;
L = 1;
%% plot extended lines and VPs


% plot clustered lines
for k = 1:vpInfo(1).n
    linePixelPts = vpInfo(1).line(k).data;
    pt1_pixel = linePixelPts(1:2)/ratio;
    pt2_pixel = linePixelPts(3:4)/ratio;
    
    % re-arrange pixel point
    linePixelPts = [pt1_pixel pt2_pixel]/(2^(L-1));
    plot([linePixelPts(1),linePixelPts(3)],[linePixelPts(2),linePixelPts(4)],'r','LineWidth',8.0);
end
for k = 1:vpInfo(2).n
    linePixelPts = vpInfo(2).line(k).data;
    pt1_pixel = linePixelPts(1:2)/ratio;
    pt2_pixel = linePixelPts(3:4)/ratio;
    
    % re-arrange pixel point
    linePixelPts = [pt1_pixel pt2_pixel]/(2^(L-1));
    plot([linePixelPts(1),linePixelPts(3)],[linePixelPts(2),linePixelPts(4)],'g','LineWidth',8.0);
end
for k = 1:vpInfo(3).n
    linePixelPts = vpInfo(3).line(k).data;
    pt1_pixel = linePixelPts(1:2)/ratio;
    pt2_pixel = linePixelPts(3:4)/ratio;
    
    % re-arrange pixel point
    linePixelPts = [pt1_pixel pt2_pixel]/(2^(L-1));
    plot([linePixelPts(1),linePixelPts(3)],[linePixelPts(2),linePixelPts(4)],'b','LineWidth',8.0);
end
for k = 1:vpInfo(4).n
    linePixelPts = vpInfo(4).line(k).data;
    pt1_pixel = linePixelPts(1:2)/ratio;
    pt2_pixel = linePixelPts(3:4)/ratio;
    
    % re-arrange pixel point
    linePixelPts = [pt1_pixel pt2_pixel]/(2^(L-1));
    plot([linePixelPts(1),linePixelPts(3)],[linePixelPts(2),linePixelPts(4)],'c','LineWidth',8.0);
end
for k = 1:vpInfo(5).n
    linePixelPts = vpInfo(5).line(k).data;
    pt1_pixel = linePixelPts(1:2)/ratio;
    pt2_pixel = linePixelPts(3:4)/ratio;
    
    % re-arrange pixel point
    linePixelPts = [pt1_pixel pt2_pixel]/(2^(L-1));
    plot([linePixelPts(1),linePixelPts(3)],[linePixelPts(2),linePixelPts(4)],'c','LineWidth',8.0);
end

% plot all VPs
%{
for k = 1:4
    
    % initial VP point
    VP = R_cM(:,k);
    VP_n = VP ./ VP(3);
    VP_p = cam.K * VP_n;
    
    
    % plot VPs
    VP_p_plot = VP_p / (2^(L-1));
    scatter(VP_p_plot(1),VP_p_plot(2),150,[1 1 0],'o');
    scatter(VP_p_plot(1),VP_p_plot(2),50,[1 1 0],'o');
    scatter(VP_p_plot(1),VP_p_plot(2),10,[1 1 0],'o');
end
%}

end

