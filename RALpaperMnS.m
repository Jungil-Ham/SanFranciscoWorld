figure; % 새로운 그림 창 생성
plot(0,0); % 임시 데이터 포인트 (보이지 않음)
%title('Candidate Interval Angle theta vs. Image Line Index'); % 그래프 제목
%xlabel('Candidate Interval Angle theta [deg]'); % x축 레이블
%ylabel('Image Line Index'); % y축 레이블
xlim([-38, 38]); % x축 범위 설정
ylim([0, 9]); % y축 범위 설정
grid on; % 그리드 활성화

xticks(-60:10:60); % x축 눈금을 -60도에서 60도까지 10도 간격으로 설정

% y축 눈금을 1에서 15까지 설정 (이미 ylim으로 설정되어 있음)
% y축 눈금 레이블 설정이 필요한 경우, 아래와 같이 추가할 수 있습니다.
yticks(1:1:15); % y축 눈금을 1에서 15까지 1단위 간격으로 설정
% 축 눈금 레이블의 글꼴 크기 조정
ax = gca; % 현재 축 가져오기
ax.FontSize = 25; % 글꼴 크기를 14로 설정