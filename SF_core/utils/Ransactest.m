clc;
clear all;
load('gaussian_sphere_GT','allCircleNormalcell');

optimalnormal = [];
minAngle = inf; % 무한대로 초기화
optimalIndex = 0;


for k = 1:size(allCircleNormalcell, 2)
    currentMinAngle = inf; % 현재 최소 각도
    for j = 1:10 % 예를 들어 100번의 반복으로 제한
        sampleIdx = randsample(size(allCircleNormalcell{k}, 2), 2);
        samplenormal = allCircleNormalcell{k}(:, sampleIdx);
        N1 = cell2mat(samplenormal(:, 1).');
        N2 = cell2mat(samplenormal(:, 2).');

        normalvector = cross(N1, N2);
        totalAngle = 0;
            for i = 1:size(allCircleNormalcell{k}, 1)
            totalAngle = totalAngle + acos(dot(cell2mat(allCircleNormalcell{k}(:, i)), normalvector) / (norm(cell2mat(allCircleNormalcell{k}(:, i))) * norm(normalvector)));
            end
        if totalAngle < currentMinAngle
        currentMinAngle = totalAngle;
        optimalnormal{k} = normalvector; % 현재 최적의 normalvector 저장
        end
    end
    angle(k) = currentMinAngle;
end

for i = 1:5
plot3([0 optimalnormal{i}(1)],[0 optimalnormal{i}(2)],[0 optimalnormal{i}(3)], 'LineWidth', 2);
end