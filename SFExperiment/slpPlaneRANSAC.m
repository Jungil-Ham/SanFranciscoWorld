function [nonAssociatedLines] = slpPlaneRANSAC(greatcircleNormal,R,cam)

proximityThreshold = deg2rad(3);
nonAssociatedLinesIdx = zeros(1,size(greatcircleNormal,1));
angle = deg2rad(2);

numLines = size(greatcircleNormal,1);
for m = 1:3
    for k = 1:numLines
        if (abs(acos(dot(R(:,m), greatcircleNormal(k,:))) - pi/2) < proximityThreshold)
            nonAssociatedLinesIdx(k)=NaN;
        end
    end
end


nonAssociatedLines = find(~isnan(nonAssociatedLinesIdx));
numLines = size(nonAssociatedLines,2);
nonAssociatedNormals = zeros(numLines,3);

for k = 1:numLines
nonAssociatedNormals(k,:) = greatcircleNormal(nonAssociatedLines(k),:);
end
%-------------------------------------------SlopingRansac-------------------------------------------------------------%
%[maxMatchingIdx, maxMatchingNum, maxPlaneModel] = slopingLineRANSAC(nonAssociatedNormals, angle);
%plot_circle_ransac(nonAssociatedNormals,maxMatchingIdx);
