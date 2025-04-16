function [] = plot_theta_interval(thetaIntervals,optimalProbe,colors)
numIntervals = size(thetaIntervals,1);
for k = 1:numIntervals
    
    % Manhattan world theta interval
    startPoint = thetaIntervals(k,1);
    endPoint = thetaIntervals(k,2);
    lineIndex = thetaIntervals(k,3);
    
    % plot each theta interval
    
    line([rad2deg(startPoint), rad2deg(endPoint)], [lineIndex, lineIndex],'Color',colors{lineIndex},'LineWidth',3.5);

end
line([rad2deg(optimalProbe), rad2deg(optimalProbe)], [0, numIntervals],'Color','k','LineWidth',2);
end