function [matchingNum, goodMatchingIdx] = inThresforPlane_SLP(greatcircleNormalRef, normPlaneModel, angle)

% set parameters
numPoint = size(greatcircleNormalRef, 1);
angleEachVector = zeros(1, numPoint);


% assign plane model parameters
a = normPlaneModel(1);
b = normPlaneModel(2);
c = normPlaneModel(3);
%d = normPlaneModel(4);

N=[a;b;c];
% distance between each point and plane
for k = 1:numPoint
    angleEachVector(k) = abs(abs(acos(dot(N,greatcircleNormalRef(k,:))/norm(N)/norm(greatcircleNormalRef(k,:))))-pi/2);
end


% determine inlier or not
matchingNum = sum(angleEachVector <= angle);
goodMatchingIdx = find(angleEachVector <= angle);


end
