x = -pi:pi/10:pi;
y = tan(sin(x)) - sin(tan(x));

figure
plot(x,y,'--gs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor',[0.5,0.5,0.5],...
    'MarkerFaceColor',[0.5,0.5,0.5])