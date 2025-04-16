function [thetaIntervals,offset_unit] = MaxStabbingIntervals(PrimHorDirection, auxDirection, LineNormals)
 
% parametrize 1-D theta angle with vertical dominant direction
beta = asin(PrimHorDirection(3));
alpha = atan(PrimHorDirection(2)/PrimHorDirection(1));
vDDParams = parametrizeHorizontalDD([cos(alpha), sin(alpha), cos(beta), sin(beta)]);

% For switching the start point of scanning
u = [vDDParams(1);vDDParams(3);vDDParams(5)];
u2 = [vDDParams(2);vDDParams(4);vDDParams(6)];
%plot3([0 u(1)],[0 u(2)],[0 u(3)],'Color','m','LineWidth', 4); hold on;
%plot3([0 u2(1)],[0 u2(2)],[0 u2(3)],'Color','c','LineWidth', 4); hold off;
offset = [acos(u.'*auxDirection) acos(u.'*auxDirection)];
% 벡터 B와 C의 차이 벡터
diff = auxDirection -u;

% 벡터 B에서 C로 가는 방향의 벡터 계산
direction_vector = cross(PrimHorDirection, diff);

% 내적을 사용하여 회전 방향 결정
rotation_direction = dot(u, direction_vector);

% 결과 출력
if rotation_direction > 0
    offset = -offset;
end
offset_unit = offset(1);
PI_ = pi*ones(1,2);
% compute theta intervals from each line normal
thetaIntervals = [];
for k = 1:size(LineNormals,2)
    
    % find each theta interval for line[0.7391 -0.2736 0.6154]
    [singleInterval, ~] = computeThetaInterval(vDDParams(1), vDDParams(2), vDDParams(3), vDDParams(4), vDDParams(5), vDDParams(6), LineNormals(:,k));
    singleInterval = singleInterval - offset;
    

%%-------------------Symmetric Transfer------------------------%%
    
    % Using the Antipodal Property
    if singleInterval > pi/2
        singleInterval = singleInterval -PI_;
    elseif singleInterval < -pi/2
        singleInterval = singleInterval +PI_;
    end

    % Using the Symmetric Property
    if singleInterval < 0
        singleInterval = -[singleInterval(2) singleInterval(1)];
    end

%%------------------------------------------------------------%%
 
    % post-process single theta interval
    %if (size(singleInterval,1) == 1)             % [a,b] in [-pi/2,pi/2]
    singleInterval = [singleInterval, k];
    %elseif (size(singleInterval,1) == 2)        % [-pi/2,a] & [b,pi/2]
    %    singleInterval = [singleInterval, k*ones(2,1)];
    %end
    
    
    % save the theta interval results
    thetaIntervals = [thetaIntervals; singleInterval];
end

end