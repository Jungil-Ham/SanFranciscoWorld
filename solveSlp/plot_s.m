function plot_s(alpha, VerticalDirection, normal)

%VerticalDirection=[-0.606082054805567;0.128501566063729;0.784953431970222];

timeti = 0:pi/500:2*pi;
%normal = [0.417631438409904;-0.902506382968602;-0.105196056735054];

SDD = computeHorizontalDDfromTheta(VerticalDirection, timeti);
thetath = [];
for k = 1:size(timeti,2)
crossResult = cross(normal,SDD(:,k));
factor = abs(acos(dot(VerticalDirection, crossResult)/norm(VerticalDirection)/norm(crossResult)));
factor = rad2deg(factor);
thetath = [thetath factor];
end

plot(timeti,thetath)
set(gca,'XTick',0:pi/2:2*pi)
set(gca,'XTickLabel',{'0','π/2','π','3π/2','2π'})

end