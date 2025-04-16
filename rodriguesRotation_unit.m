function [vector_Rtd] = rodriguesRotation_unit(axis, vector, angle)
%[~, ~, ManhattanDirection_Z] = parametrizeVerticalDD(-PHD);
theta = deg2rad(angle); 
% 회전축 벡터 정규화
axis = axis/norm(axis);
vector_Rtd = zeros(3,1);
numV = size(vector,2);
K = [0, -axis(3), axis(2); axis(3), 0, -axis(1); -axis(2), axis(1), 0]; 
R = eye(3) + sin(theta)*K + (1-cos(theta))*(K^2); 
factor = R*vector;
factor = factor/norm(factor);
vector_Rtd = factor;
end
