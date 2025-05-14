function [corrIdx, proximytyAngle, find_Idx] = identyfyVP_large(R_cM_old, excIdx, checkVP)
proximytyAngle = deg2rad(8);
find_Idx = 0;
corrIdx = 0;
m = size(R_cM_old,2);
for k = 1:m
    if (k == excIdx)
        continue;
    end
    angle = abs(acos(dot(checkVP, R_cM_old(:,k))));
    if (angle < proximytyAngle || abs(angle -pi) < proximytyAngle)
        if (angle < proximytyAngle)
            proximytyAngle = angle; %for update
        else
            proximytyAngle = abs(angle -pi);
            %checkVP = checkVP;
        end
        corrIdx = k;
        find_Idx = 1;
    else
        continue;
    end
end