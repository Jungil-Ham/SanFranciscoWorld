clc;
close all;
clear all;
alpha = 60;
VerticalDirection=[-0.606082054805567;0.128501566063729;0.784953431970222];
timeti = 0:pi/500:2*pi;
normal = [0.417631438409904;-0.902506382968602;-0.105196056735054];
SDD = computeHorizontalDDfromTheta(normal, timeti);
thetath = [];
for k = 1:size(timeti,2)
factor = abs(acos(dot(VerticalDirection, SDD(:,k))/norm(VerticalDirection)/norm(SDD(:,k))));
factor = rad2deg(factor);
thetath = [thetath factor];
end

plot(timeti,thetath)
set(gca,'XTick',0:pi/2:2*pi)
set(gca,'XTickLabel',{'0','π/2','π','3π/2','2π'})