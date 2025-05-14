if (toVisualize)
    %% prerequisite to visualize
    
    stateEsti = zeros(3, imgIdx);
    for k = 1:imgIdx
        [yaw, pitch, roll] = dcm2angle(R_gc_LPIC(:,:,k));
        stateEsti(:,k) = [roll; pitch; yaw];
    end
    
    %% update lines & plane on RGB image


    axes(ha1); cla;
    plot_plane_image(pNV, sNV, sPP, imageCurForMW, optsLPIC); hold on;
    plots_extended_lines_tracking(R_cM, vpInfo, imageCurForLine, cam, optsLPIC);
    %plot_display_text_with_true_Ronly(R_cM, sNV, vpInfo, R_gc_LPIC, R_gc_true, imgIdx, optsLPIC); hold off;
    title('point, line, plane tracking image');
    
    %% update all lines on gray image
    
    %% deepLSD
    axes(ha2); cla;
    imshow(imageCurForLine)
    title("chosen line");
    linesInVP = lines(maxVoteSumIdx,:);
    lines_2d = linesInVP; 
    line([lines_2d(1,1) lines_2d(1,3)], [lines_2d(1,2) lines_2d(1,4)], 'Color', ...
       'm', 'LineWidth',5);
    lines_2d = zeros(4,size(lines,1));
    for k = 1:size(lines_2d,2)
        lines_2d(:,k) = lines(k,1:4); 
        line([lines_2d(1,k) lines_2d(3,k)], [lines_2d(2,k) lines_2d(4,k)], 'Color', ...
             'y', 'LineWidth',2) 
    end
    title('all detected lines in the image');
    
    %% update rotational motion of camera
    
    axes(ha3); cla;
    hold on; grid on; axis equal; view(130,30);
    plot_Manhattan_camera_frame(R_cM, R_gc_LPIC(:,:,imgIdx));
    plot_true_camera_frame(R_gc_true(:,:,imgIdx)); hold off;
    plot_RMD_text(R_gc_true,R_cM, R_gc_LPIC,imgIdx,optsLPIC);
    title('unit sphere in SO(3)');
    
    %% update 3D trajectory of camera
    
    axes(ha4); cla;
    plot_unit_sphere(1, 18, 0.8); hold on; grid on; axis equal;
    xlabel('X-axis');
    ylabel('Y-axis');
    zlabel('Z-axis');
    f = FigureRotator(gca());
    for k = 1:5
    plot3([0 R_SLP(1,k)],[0 R_SLP(2,k)],[0 R_SLP(3,k)], 'Color' ,colors{k},'LineWidth', 2);
    plot3([0 R_SLP_old(1,k)],[0 R_SLP_old(2,k)],[0 R_SLP_old(3,k)], 'Color' ,colors{k},'LineWidth', 5);
    %plot3([0 -R_SLP(1,k)],[0 -R_SLP(2,k)],[0 -R_SLP(3,k)], 'Color' ,colors{k},'LineWidth', 2);
    %plot3([0 -R_SLP_old(1,k)],[0 -R_SLP_old(2,k)],[0 -R_SLP_old(3,k)], 'Color' ,colors{k},'LineWidth', 5);
    end%; hold on;
    plot_plane_sphere(pNV, sNV, optsLPIC);
    %{ 
    if imgIdx == 106

        plot3([0 -0.9896],[0 0.1405],[0 -0.030524],'o' ,'Color' ,'b','LineWidth', 4);
        plot3([0 0.989611],[0 -0.130990],[0 0.05925],'o', 'Color' ,'b','LineWidth', 4);
        hold on;
        s
        for k = 3:5
        VP1 = R_SLP(:,k);
        beta = VP1(3);
        alpha = VP1(2)/VP1(1);
        params = parametrizeHorizontalDD([cos(alpha), sin(alpha), cos(beta), sin(beta)]);
        A1=params(1);B1=params(2);A2=params(3);B2=params(4);A3=params(5);B3=params(6); 
        pt1 = [A1;A2;A3];
        pt2 = [B1;B2;B3];
        plot_great_circle(pt1, pt2, 5, colors{k}, 'greatcircle');
        end
        fprintf('105');
    end
    %}
        title('R_cM update');



    %{
    plot(stateEsti(2,1:imgIdx), 'm', 'LineWidth', 2); hold on; grid on;
    plot(stateTrue(5,1:imgIdx), 'k', 'LineWidth', 2); hold off; ylabel('pitch (rad)');
    title('estimated & true pitch angle in rad');
    %}
    
    %% save current figure
    
    if (toSave)
        % save directory for MAT data
        SaveDir = [datasetPath '/CVPR2018'];
        if (~exist( SaveDir, 'dir' ))
            mkdir(SaveDir);
        end
        
        % save directory for images
        SaveImDir = [SaveDir '/LPIC'];
        if (~exist( SaveImDir, 'dir' ))
            mkdir(SaveImDir);
        end
        
        pause(0.01); refresh;
        saveImg = getframe(h);
        imwrite(saveImg.cdata , [SaveImDir sprintf('/%06d.png', imgIdx)]);
    end
end
