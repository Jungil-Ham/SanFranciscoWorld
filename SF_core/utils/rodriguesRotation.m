function [remainingNormals_Rtd] = rodriguesRotation(PHD, remainingNormals, angle)
%[~, ~, ManhattanDirection_Z] = parametrizeVerticalDD(-PHD);
theta = deg2rad(angle); % 회전할 각도 (예: 30도를 라디안으로 변환)
% 회전축 벡터 정규화
axis = PHD / norm(PHD);
remainingNormals_Rtd = [];
numV = size(remainingNormals,2);
for k =1:numV
K = [0, -axis(3), axis(2); axis(3), 0, -axis(1); -axis(2), axis(1), 0]; 
R = eye(3) + sin(theta)*K + (1-cos(theta))*(K^2); 
factor = R*remainingNormals(:,k);
factor = factor/norm(factor);
remainingNormals_Rtd = [remainingNormals_Rtd factor];
end

