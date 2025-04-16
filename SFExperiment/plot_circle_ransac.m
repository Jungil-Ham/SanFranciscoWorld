function [] = plot_circle_ransac(greatcircleNormal,maxMatchingIdx,R_cM_final)

x0 = 0;
y0 = 0;
z0 = 0;
pt1 = cross(greatcircleNormal(maxMatchingIdx(1),:),R_cM_final(:,2));
pt2 = cross(greatcircleNormal(maxMatchingIdx(1),:),R_cM_final(:,3));
pt1 =pt1/norm(pt1);
pt2 =pt2/norm(pt2);
x1 = pt1(1);
y1 = pt1(2);
z1 = pt1(3);

x2 = pt2(1);
y2 = pt2(2);
z2 = pt2(3);

% compute vectors
v1 = [x1-x0; y1-y0; z1-z0];       % Vector from center to 1st point
r = norm(v1);                          % The radius
v2 = [x2-x0;y2-y0;z2-z0];        % Vector from center to 2nd point
v3 = cross(cross(v1,v2),v1);     % v3 lies in plane of v1 & v2 and is orthog. to v1
v3 = r*v3/norm(v3);                % Make v3 of length r

t = linspace(0, 2*pi);
v = v1*cos(t) + v3*sin(t);
plot3([0 greatcircleNormal(maxMatchingIdx(1),1)],[0 greatcircleNormal(maxMatchingIdx(1),2)],[0 greatcircleNormal(maxMatchingIdx(1),3)], ...
     'Color','k','LineWidth', 2);
best_circle = plot3(v(1,:)+x0, v(2,:)+y0, v(3,:)+z0,'LineWidth', 2, 'Color', 'k'); hold on;

beta = asin(greatcircleNormal(maxMatchingIdx(1),3));
alpha = atan(greatcircleNormal(maxMatchingIdx(1),(2))/greatcircleNormal(maxMatchingIdx(1,(1) ) ) );
vDDParams = parametrizeHorizontalDD([cos(alpha), sin(alpha), cos(beta), sin(beta)]);

% For switching the start point of scanning
u = [vDDParams(1);vDDParams(3);vDDParams(5)];
plot3([0 u(1)],[0 u(2)],[0 u(3)],'Color','m','LineWidth', 4); hold on;
%u_vector = plot3([0 0.207409534804215],[0 0.978254202583510],[0 0], 'Color' ,'m','LineWidth', 2);
