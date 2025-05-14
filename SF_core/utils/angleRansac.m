
angle = [];
for k = 1:size(allCircleNormalcell,2) %1~6
    for i = 1:size(allCircleNormalcell{k},(1))
        while (1){
        [sampleIdx] = randsample(size(allCircleNormalcell{k}), 2);
        samplenormal = allCircleNormalcell{k}(:,sampleIdx);
        N1 = samplenormal(:,1).';
        N2 = samplenormal(:,2).';
   
        normalvector = cross(N1,N2);
    
        angle(k) = angle(k) + acos( dot(allCircleNormalcell{k}{i},normalvector)/ norm(allCircleNormalcell{k}{i})*norm(normalvector));
        } 
        end
        if k = min(angle) %index of minimum angle
            optimalnormal = normalvector
    end
end
        