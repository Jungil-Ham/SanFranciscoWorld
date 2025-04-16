function [] = plot_theta_intervalRtd(thetaIntervals,remainingIdx)

numIntervals = size(remainingIdx,2);
for k = 1:numIntervals

    % Manhattan world theta interval
    startPoint = thetaIntervals(remainingIdx(k),1);
    endPoint = thetaIntervals(remainingIdx(k),2);
    lineIndex = thetaIntervals(k,3);
    
    % plot each theta interval
    %line([rad2deg(endPoint) rad2deg(startPoint_prev)], [remainingIdx(k), remainingIdx(k)],'LineStyle',"--",'Color','m','LineWidth',1.5);
    line([rad2deg(startPoint), rad2deg(endPoint)], [remainingIdx(k), remainingIdx(k)],'Color','m','LineWidth',3.5);

end
end