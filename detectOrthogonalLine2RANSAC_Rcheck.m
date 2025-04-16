function [R_cM_final, clusteredLineIdx_final ,R_SLP, maxVoteSumIdx,ransacIterCnt] = detectOrthogonalLine2RANSAC_ODEP(R_cM_old, planeNormalVector, alpha, pNVIdx, lines, Kinv, cam, optsLAPO, imageCurForLine)

colors = {'r', 'g', 'b', 'c', 'm', 'y', 'k', [0, 0.4470, 0.7410], [0.5, 0, 0.5], [0, 0.5, 0.5], [0.5, 0.5, 0], [1, 0.75, 0.8], [0.6, 0.4, 0.2], [0.75, 0.75, 0.75], [1, 1, 0.5], [0.5, 0.5, 1], [0.587, 0.766, 0.628], [0.838, 0.698, 0.875], [0.360, 0.022, 0.132], [0.463, 0.069, 0.436], [0.416, 0.989, 0.289], [0.950, 0.965, 0.931], [0.875, 0.731, 0.508], [0.563, 0.028, 0.279], [0.563, 0.787, 0.181], [0.959, 0.210, 0.841], [0.612, 0.568, 0.395], [0.028, 0.775, 0.751], [0.324, 0.581, 0.114], [0.777, 0.219, 0.308]};
isLShaped = 0;
% line information for 1-line RANSAC
numLines = size(lines,1);
greatcircleNormal = zeros(numLines,3);
lineEndPixelPoints = zeros(numLines,4);
centerPixelPoint = zeros(numLines,2);
lineLength = zeros(numLines,1);
for k = 1:numLines
    
    % line pixel information
    linedata = lines(k,1:4);
    centerpt = (linedata(1:2) + linedata(3:4))/2;
    length = sqrt((linedata(1)-linedata(3))^2 + (linedata(2)-linedata(4))^2);
    
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
    
    % save the result
    greatcircleNormal(k,:) = circleNormal;
    lineEndPixelPoints(k,:) = linedata;
    centerPixelPoint(k,:) = centerpt;
    lineLength(k) = length;
end


%% 2-line RANSAC

% initialize RANSAC model parameters
totalLineNum = size(lines,1);
sampleLineNum = 1;
ransacMaxIterNum = 1000;
ransacIterNum = 50;
ransacIterCnt = 0;
proximityThreshold = deg2rad(4.5);
maxVoteSumTotal = 0; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maxVoteSumIdx = [];
isSolutionFound = 0;
trial =0;
% VP1 from plane normal vector
VP1 = planeNormalVector;


% do 2-line RANSAC
while (true)
    
    trial = trial + 1;
    [sampleIdx] = randsample(totalLineNum, sampleLineNum);
    greatcircleNormalSample = greatcircleNormal(sampleIdx,:).';
    figure(6)
    imshow(imageCurForLine)
    title("chosen line");
    linesInVP = lines(sampleIdx,:);
    lines_2d = linesInVP; 
    line([lines_2d(1,1) lines_2d(1,3)], [lines_2d(1,2) lines_2d(1,4)], 'Color', ...
        'm', 'LineWidth',7);
    %-----------------estimate R with PHD-------------------------%
    if( pNVIdx == 1 )
        [~, ~, VP1 ] = parametrizeVerticalDD(VP1);
        % estimate VP2 with PHD
        if (abs(acos(dot(VP1, greatcircleNormalSample)) - pi/2) < proximityThreshold)
            continue;
        end
        VP2 = cross(VP1, greatcircleNormalSample);
        VP2 = VP2 / norm(VP2);
        [corrIdx, ~, find_Idx] = identyfyVP(R_cM_old, pNVIdx, VP2);

        
        if(find_Idx)
            % estimate VP3
            if (corrIdx == 2 || corrIdx == 3)
                VP3 = cross(VP1, VP2);
                VP3 = VP3 / norm(VP3);
                if(corrIdx == 2)         % PHD = VP1, VD =  VP2, V1 = VP3, SLP = VP4  
                    VP4 = computeVPfromTheta(VP1, pi/2- alpha,VP2);   % need revision
                    R_cM_temporary = [VP1, VP2, VP3, VP4];
                else                     % PHD = VP1, VD =  VP3, V1 = VP2, SLP = VP4 
                    VP4 = computeVPfromTheta(VP1, -alpha,VP2);
                    R_cM_temporary = [VP1, VP3, VP2, VP4];
                end
            elseif (corrIdx == 4)        % PHD = VP1, VD =  VP3, V1 = VP4, SLP = VP2 , SLP direction sampled as VP2
                VP4 = computeVPfromTheta(VP1, -alpha,VP2);
                [corrIdx, ~, find_Idx] = identyfyVP_large(R_cM_old, [1,2,4,5], VP4);
                if(find_Idx == 0 || corrIdx ~= 3 )
                    VP4 = computeVPfromTheta(VP1, alpha,VP2);
                end
                VP3 = cross(VP1, VP4);
                VP3 = VP3 / norm(VP3);
                R_cM_temporary = [VP1, VP3, VP4, VP2];
            elseif (corrIdx == 5)        % PHD = VP1, VD =  VP3, V1 = VP4, SLP = VP2 , SLP direction sampled as VP2
                VP4 = computeVPfromTheta(VP1, alpha,VP2);
                [corrIdx, ~, find_Idx] = identyfyVP_large(R_cM_old, [1,2,4,5], VP4);
                if(find_Idx == 0 || corrIdx ~= 3 )
                    VP4 = computeVPfromTheta(VP1, -alpha,VP2);
                end
                VP3 = cross(VP1, VP4);
                VP3 = VP3 / norm(VP3);
                R_cM_temporary = [VP1, VP3, VP4, VP2];
            end
            

            
        else
            continue
        end
    else
        %-----------------estimate R with non-PHD-------------------------%    
        %[sampleIdx] = randsample(totalLineNum, sampleLineNum);
        greatcircleNormalSample = greatcircleNormal(sampleIdx,:).';
        % estimate VP2 with VD or V1
        if (abs(acos(dot(VP1, greatcircleNormalSample)) - pi/2) < proximityThreshold)
            continue;
        end
        VP2 = cross(VP1, greatcircleNormalSample);
        VP2 = VP2 / norm(VP2);
        R_cM_old_MH = R_cM_old(:,1:3);
        [corrIdx2, ~, find_Idx] = identyfyVP(R_cM_old_MH, pNVIdx, VP2);

        if(find_Idx)
            if (pNVIdx == 2)         % MH direction sampled as VP2
                VP3 = cross(VP1, VP2);
                VP3 = VP3 / norm(VP3);
                if(corrIdx2 == 3)       % PHD = VP3, VD =  VP1, V1 = VP2, SLP = VP4  
                    [~, ~, VP3 ] = parametrizeVerticalDD(VP3);
                    VP4 = computeVPfromTheta(VP3, -alpha, VP2);
                    R_cM_temporary = [VP3, VP1, VP2, VP4];
                elseif(corrIdx2 == 1)   % PHD = VP2, VD =  VP1, V1 = VP3, SLP = VP4 
                    [~, ~, VP2 ] = parametrizeVerticalDD(VP2);
                    VP4 = computeVPfromTheta(VP2, -alpha, VP3);
                    R_cM_temporary = [VP2, VP1, VP3, VP4];
                end
            elseif(pNVIdx == 3)         
                VP3 = cross(VP1, VP2);
                VP3 = VP3 / norm(VP3);
                if(corrIdx2 == 2)       % PHD = VP3, VD =  VP2, V1 = VP1, SLP = VP4 
                    [~, ~, VP3 ] = parametrizeVerticalDD(VP3);
                    VP4 = computeVPfromTheta(VP3, -alpha, VP1);
                    R_cM_temporary = [VP3, VP2, VP1, VP4];
                elseif(corrIdx2 == 1)    % PHD = VP2, VD =  VP3, V1 = VP1, SLP = VP4
                    [~, ~, VP2 ] = parametrizeVerticalDD(VP2);
                    VP4 = computeVPfromTheta(VP2, -alpha, VP1);
                    R_cM_temporary = [VP2, VP3, VP1, VP4];
                end
                %{
                figure(6)
                imshow(imageCurForLine)
                title("Clustered sloping lines using previous frame");
                linesInVP = lines(sampleIdx,:);
                lines_2d = linesInVP; 
                line([lines_2d(1,1) lines_2d(1,3)], [lines_2d(1,2) lines_2d(1,4)], 'Color', ...
                    'm', 'LineWidth',7);
                %}
            end
            
        else       % MH direction not found -> Try 2 line RANSAC for leverageing SLP direction
             %{
            SDD = R_cM_old(:,4);
            [~, ~, R_cM_old(:,1) ] = parametrizeVerticalDD(R_cM_old(:,1));
            SDD2 = computeVPfromTheta(R_cM_old(:,1), -alpha, R_cM_old(:,3));
            if(isLShaped==1)
               SDD = rodriguesRotation_unit(VDD, SDD, 90);
            end
            SDD2 = [SDD SDD2];
             %}
          

            [theta_sol,u_normal,hor_AF] = solveSlope(R_cM_old, planeNormalVector,pNVIdx, greatcircleNormalSample, alpha);

            figure(6); cla;
            imshow(imageCurForLine)
            title("Chosen Line");
            linesInVP = lines(sampleIdx,:);
            lines_2d = linesInVP; 
            line([lines_2d(1,1) lines_2d(1,3)], [lines_2d(1,2) lines_2d(1,4)], 'Color', ...
            'm', 'LineWidth',7);
            hold on;
            if isempty(theta_sol)
                continue; % theta_sol이 비어 있다면 현재 반복을 건너뛰고 다음 반복으로 넘어감
            end
                
            %thetas = [double(theta_sol(1)) double(theta_sol(2))];
            %[~, ~, greatcircleNormalSample ] = parametrizeVerticalDD(greatcircleNormalSample); 
            %hor_AF = computeHorizontalDDfromTheta(greatcircleNormalSample,thetas);

            %planeNormalVector  greatcircleNormalSample 
           
            if isempty(hor_AF)
            continue;
            else
            [voteSumTotal, slpIdx] = computeOrthogonalDistance_SLP(hor_AF, lineEndPixelPoints, centerPixelPoint, lineLength, cam, optsLAPO);
            cellSizes = cellfun(@numel, slpIdx); % 각 cell의 요소 개수 계산
            [~, maxLineIdx] = max(cellSizes); % 가장 큰 size를 가진 cell의 index
            end
            %{
            for k = 1:2
                linesInVP = lines(slpIdx{k},:);
                numLinesInVP = size(linesInVP,1);
                for j = 1:numLinesInVP
                lines_2d = linesInVP(j,1:4); 
                line([lines_2d(1,1) lines_2d(1,3)], [lines_2d(1,2) lines_2d(1,4)], 'Color', ...
                    colors{k}, 'LineWidth',5); hold on;
                end
            end

            %}
            
            VP2 = hor_AF(:,maxLineIdx);
            
            % plot pNV, u_normal,  theta_sol
            %{
            h1 = figure(4); cla;
            plot_unit_sphere(1, 18, 0.8); hold on; grid on; axis equal;
            xlabel('X-axis');
            ylabel('Y-axis');
            zlabel('Z-axis');
            f = FigureRotator(gca());
            
            for k = 1:4
            plot3([0 R_cM_old(1,k)],[0 R_cM_old(2,k)],[0 R_cM_old(3,k)], 'Color' ,colors{k},'LineWidth', 5);
            plot3([0 -R_cM_old(1,k)],[0 -R_cM_old(2,k)],[0 -R_cM_old(3,k)], 'Color' ,colors{k},'LineWidth', 5);
            end
            plot3([0 greatcircleNormalSample(1,1)],[0 greatcircleNormalSample(2,1)],[0 greatcircleNormalSample(3,1)], 'Color' ,'m','LineWidth', 3);
            plot3([0 0.214267664408572],[0 0.763295213851522],[0 -0.609483211007698], 'Color' ,'c','LineWidth', 3);
            plot3([0 VP2(1,1)],[0 VP2(2,1)],[0 VP2(3,1)], 'Color' ,'y','LineWidth', 5);
            for k = 1:2
            plot3([0 hor_AF(1,k)],[0 hor_AF(2,k)],[0 hor_AF(3,k)], 'Color' ,'k','LineWidth', 3);
            plot3([0 -hor_AF(1,k)],[0 -hor_AF(2,k)],[0 -hor_AF(3,k)], 'Color' ,'k','LineWidth', 3);
            end
            close all;
            %}
            %{
            figure(6)
            slpLineNum = size(slpIdx{1},1);
            [sample2ndIdx] = randsample(slpLineNum, sampleLineNum);
            greatcircleNormalSample = [greatcircleNormalSample greatcircleNormal(slpIdx{1}(sample2ndIdx),:).'];
            greatcircleNormalSample = [greatcircleNormal(9,:).' greatcircleNormal(19,:).'];
           
            sample2ndIdx = [sampleIdx slpIdx{1}(sample2ndIdx)];
            sample2ndIdx = [9 19];
            linesInVP = lines(sample2ndIdx.',:);
            numLinesInVP = size(linesInVP,1);
            for j = 1:numLinesInVP
                lines_2d = linesInVP(j,1:4); 
                line([lines_2d(1,1) lines_2d(1,3)], [lines_2d(1,2) lines_2d(1,4)], 'Color', ...
                    colors{j+3}, 'LineWidth',7); 
            end
            hold off;
            
            VP2 = cross(greatcircleNormalSample(:,1),greatcircleNormalSample(:,2));
            VP2 = VP2/norm(VP2);
            %}
            %VP2 = R_cM_old(:,4);
            
            if (pNVIdx == 2)          % PHD = VP3, VD =  VP2, V1 = VP4, SLP = VP2
                VP3 = cross(VP1,VP2);  
                VP3 = VP3/norm(VP3);
                VP4 = cross(VP3,VP1);
                VP4 = VP4/norm(VP4);      
                R_cM_temporary = [VP3, VP1, VP4, VP2];
            else (pNVIdx == 3)        % PHD = VP3, VD =  VP4, V1 = VP1, SLP = VP2
                VP3 = cross(VP1,VP2); 
                VP3 = VP3/norm(VP3);
                VP4 = cross(VP3,VP1);  
                VP4 = VP4/norm(VP4);
                R_cM_temporary = [VP3, VP4, VP1, VP2];
            end
            %{
             if(abs(acos(dot(VP2, R_cM_old(:,4)))) > rad2deg(10))
                [~, ~, VP3 ] = parametrizeVerticalDD(VP3);
                VP2 = computeVPfromTheta(VP3, -2*alpha, R_cM_temporary(:,4) );
                R_cM_temporary(:,4) = VP2;
            end
            %}
        end
    end
    
    figure(3); cla;
    plot_unit_sphere(1, 18, 0.8); hold on; grid on; axis equal;
    xlabel('X-axis');
    ylabel('Y-axis');
    zlabel('Z-axis');
    f = FigureRotator(gca());
    for k = 1:4
    plot3([0 R_cM_temporary(1,k)],[0 R_cM_temporary(2,k)],[0 R_cM_temporary(3,k)], 'Color' ,colors{k},'LineWidth', 2);
    plot3([0 R_cM_old(1,k)],[0 R_cM_old(2,k)],[0 R_cM_old(3,k)], 'Color' ,colors{k},'LineWidth', 5);
    plot3([0 -R_cM_temporary(1,k)],[0 -R_cM_temporary(2,k)],[0 -R_cM_temporary(3,k)], 'Color' ,colors{k},'LineWidth', 2);
    plot3([0 -R_cM_old(1,k)],[0 -R_cM_old(2,k)],[0 -R_cM_old(3,k)], 'Color' ,colors{k},'LineWidth', 5);
    end
    %plot3([0 u_normal(1,1)],[0 u_normal(2,1)],[0 u_normal(3,1)], 'Color' ,'m','LineWidth', 2);
    %plot3([0 greatcircleNormalSample(1,1)],[0 greatcircleNormalSample(2,1)],[0 greatcircleNormalSample(3,1)], 'Color' ,'k','LineWidth', 2);
     
%---------consider symmetric property-----------------%
    excIdx = [1 2 3];
    [corrIdx, ~, find_Idx] = identyfyVP_large(R_cM_old, excIdx, R_cM_temporary(:,4));
    if(find_Idx==1)
        % 벡터 a를 벡터 b에 투영합니다.
        projection = dot(R_cM_temporary(:,4), R_cM_temporary(:,3)) * R_cM_temporary(:,3);
        
        % 벡터 a의 벡터 b에 대한 대칭인 벡터 c를 계산합니다.
        R_cM_temporary(:,5) = R_cM_temporary(:,4) - 2 * projection;
        R_cM_temporary(:,5) = R_cM_temporary(:,5)/norm(R_cM_temporary(:,5));
        %{
        if(corrIdx == 4 )
        [~, ~, VP_axis ] = parametrizeVerticalDD(R_cM_old(:,1));
        R_cM_temporary(:,5) = computeVPfromTheta(VP_axis, alpha, R_cM_temporary(:,3) );
        elseif(corrIdx == 5)
        [~, ~, VP_axis ] = parametrizeVerticalDD(R_cM_old(:,1));
        R_cM_temporary(:,5) = R_cM_temporary(:,4);
        R_cM_temporary(:,4) = computeVPfromTheta(VP_axis, -alpha, R_cM_temporary(:,3) );
        %}
    else
        continue;
    end
    

    
    
    %}
        
    % check number of inliers
    %[~, ~, VP_SLP_AUX ] = parametrizeVerticalDD(R_cM_temporary(:,1));
    %(abs(acos(dot(VP1, greatcircleNormalSample)) - pi/2) < proximityThreshold)
    %VP5 = computeVPfromTheta(VP_SLP_AUX, alpha, R_cM_temporary(:,3));
    R_SLP = R_cM_temporary; 
    [voteSumTotal, clusteredLineIdx] = computeOrthogonalDistanceSLP(R_SLP, lineEndPixelPoints, centerPixelPoint, lineLength, cam, optsLAPO);
    
    %{
    linesInVP = lines(clusteredLineIdx{4},:);
    numLinesInVP = size(linesInVP,1);
    figure(7)
    imshow(imageCurForLine)
    for j = 1:numLinesInVP
        lines_2d = linesInVP(j,1:4); 
        line([lines_2d(1,1) lines_2d(1,3)], [lines_2d(1,2) lines_2d(1,4)], 'Color', ...
            colors{j+3}, 'LineWidth',7); 
    end
    %}
    %close all;

    
    % save the large consensus set
    if (sum(voteSumTotal) >= maxVoteSumTotal)
        maxVoteSumTotal = sum(voteSumTotal);
        maxVoteSumIdx = sampleIdx;
        max_R_cM = R_cM_temporary;
        max_R_SLP = R_SLP;
        maxClusteringNum = (size(clusteredLineIdx{1},1) + size(clusteredLineIdx{2},1) + size(clusteredLineIdx{3},1) + size(clusteredLineIdx{4},1)+ size(clusteredLineIdx{5},1));
        isSolutionFound = 1;
        
        
        % calculate the number of iterations (http://en.wikipedia.org/wiki/RANSAC)
        clusteringRatio = maxClusteringNum / totalLineNum;
        ransacIterNum = ceil(log(0.01)/log(1-(clusteringRatio)^sampleLineNum));
    end
    
    ransacIterCnt = ransacIterCnt + 1;
    if (ransacIterCnt >= ransacIterNum || ransacIterCnt >= ransacMaxIterNum)
        break;
    end
end




% re-formulate 1-line RANSAC result
if (isSolutionFound == 1)
    % get clustered lines
    [~, clusteredLineIdx] = computeOrthogonalDistanceSLP(max_R_SLP, lineEndPixelPoints, centerPixelPoint, lineLength, cam, optsLAPO);
    R_cM_initial = max_R_cM;
    
    
    % refine RANSAC results
    if (isempty(clusteredLineIdx{1}) && isempty(clusteredLineIdx{2}) && isempty(clusteredLineIdx{3}) && isempty(clusteredLineIdx{4}) && isempty(clusteredLineIdx{5}))
        R_cM_final = zeros(3,3);
        R_SLP = zeros(3,5);
        clusteredLineIdx_final = cell(1,5);
    else
        % re-arrange line information for nonlinear optimization
        lineEndPixelPoints_inMF = [];
        centerPixelPoint_inMF = [];
        lineMFLabel_inMF = [];
        for k = 2:3
            
            % current lines in VPs
            linesInVP = lines(clusteredLineIdx{k},:);
            numLinesInVP = size(linesInVP,1);
            
            % line pixel point information
            lineEndPixelPoints_inMF = [lineEndPixelPoints_inMF; lineEndPixelPoints(clusteredLineIdx{k},:)];
            centerPixelPoint_inMF = [centerPixelPoint_inMF; centerPixelPoint(clusteredLineIdx{k},:)];
            lineMFLabel_inMF = [lineMFLabel_inMF; ones(numLinesInVP,1) * k];
        end
        
        
        % run nonlinear optimization using lsqnonlin in Matlab (Levenberg-Marquardt)
        %options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','iter-detailed');
        %[vec,resnorm,residuals,exitflag] = lsqnonlin(@(x) orthogonalDistanceResidual(lineEndPixelPoints_inMF,centerPixelPoint_inMF,lineMFLabel_inMF,cam.K,R_cM_initial,planeNormalVector,x),0,[],[],options);
        
        
        % optimal R_cM
        %R_SLP = computeOptimalMF_SLP(max_R_SLP, planeNormalVector, vec);
        R_SLP = max_R_SLP;
        R_cM_final = R_SLP(:,1:3);
        clusteredLineIdx_final = clusteredLineIdx;
    end
else
    R_cM_final = zeros(3,3);
    R_SLP = zeros(3,5);
    clusteredLineIdx_final = cell(1,5);
end


end

