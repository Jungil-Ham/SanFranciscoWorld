function [R_update, isTracked] = trackPlane(planeNormalVector, surfaceNormalVector, optsLPIC)

% pre-defined variables
minSampleRatio = optsLPIC.minSampleRatio;
iterNum = optsLPIC.iterNum;
convergeAngle = optsLPIC.convergeAngle;
halfApexAngle = optsLPIC.halfApexAngle;
c = optsLPIC.c;

numFound = 0;
directionFound = [];
%% track single plane (Manhattan world frame)

% initial model parameters
pNV = planeNormalVector;
pNV_update = pNV;
numNormalVector = size(surfaceNormalVector, 2);
minSampleNum = round(numNormalVector * minSampleRatio);


% do mean shift iteration
for iterCount = 1:iterNum
        iter = 1;
        % for next iteration
        pNV = pNV_update;
        % project to plane normal vector (Manhattan frame axis)
        R_cM = seekPlaneManhattanWorld(pNV);
        R_Mc = R_cM.';
        R_update = eye(3);
  while acos((trace(R_Mc'*R_update) - 1)/2) > convergeAngle || iter == 1
    if iter ~= 1
            R_Mc = R_update;
    end
    for a = 1:3
        R_Mc = [R_Mc(:,mod(a+5,3)+1),R_Mc(:,mod(a+3,3)+1),R_Mc(:,mod(a+4,3)+1)]; %a=1 ->2,3,1 / a=2->3,2,1 / a=3->1,2,3
            
        n_j = R_Mc * surfaceNormalVector;
        
        lambda = sqrt(n_j(1,:).*n_j(1,:) + n_j(2,:).*n_j(2,:));
        conicIdx = find(lambda < sin(halfApexAngle));
        n_j_inlier = n_j(:,conicIdx);
        
        tan_alfa = lambda(conicIdx)./abs(n_j(3,conicIdx));
        alfa = asin(lambda(conicIdx));
        m_j = [alfa./tan_alfa.*n_j_inlier(1,:)./n_j_inlier(3,:);
            alfa./tan_alfa.*n_j_inlier(2,:)./n_j_inlier(3,:)];
        
        select = ~isnan(m_j);
        select2 = select(1,:).*select(2,:);
        select3 = find(select2 == 1);
        m_j = m_j(:,select3);
        
        
        % number of surface normal vector
        if (size(m_j, 2) >= minSampleNum)
            
            % perform mean shift
            [s_j, ~] = MeanShift(m_j, c);
            
            % new plane normal vector
            alfa = norm(s_j);
            ma_p = tan(alfa)/alfa * s_j;
            R_update(:,a) = R_Mc.' * [ma_p;1];
            R_update(:,a) = R_update(:,a) / norm(R_update(:,a));
            numFound = numFound + 1;
            directionFound = [directionFound a];
            if a == 2 && numFound == 0
                break;
            end
            continue;
        end
    end

    if numFound < 2
        numFound = 0;
        continue;
    end

    % if only find two dominant direction
    if numFound == 2
        v1 = R_update(:,directionFound(1));
        v2 = R_update(:,directionFound(2));
        v3 = cross(v1,v2);
        R_update(:,6-(directionFound(1)+directionFound(2))) = v3; 
    end

    directionFound = [];
    numFound = 0;
    iter = iter + 1;
    acos((trace(R_Mc'*R_update) - 1)/2)
  end
  
    % check convergence
end

isTracked = 1;


end


