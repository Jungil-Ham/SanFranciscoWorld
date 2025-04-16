function [meanRMD, RMD] = calcRMD(R_gc_esti, R_gc_true)

M = size(R_gc_true, 3);
rotationMatrixDifference = zeros(1, M);

% rotation matrix difference
for k = 1:M
    RgcTrue = R_gc_true(:,:,k);
    RgcEsti = R_gc_esti(:,:,k);
    
    rotationMatrixDifference(k) = acos((trace(RgcTrue.' * RgcEsti)-1)/2) * (180/pi);
end

% return error metric
rotationMatrixDifference = real(rotationMatrixDifference);
meanRMD = mean(rotationMatrixDifference);
RMD = rotationMatrixDifference;

% rotationMatrixDifference 배열의 값 정렬
sortedRMD = sort(rotationMatrixDifference, 'descend');

% 상위 2% 인덱스 계산
top2PercentIndex = ceil(length(sortedRMD) * 0.02);

% 상위 2% 값을 제외한 나머지 값들의 평균 계산
%top2PercentValues = sortedRMD(1:top2PercentIndex); % 상위 2% 값
remainingValues = sortedRMD(top2PercentIndex+1:end); % 나머지 값

% 나머지 값들의 평균
meanRMD = mean(remainingValues);


end