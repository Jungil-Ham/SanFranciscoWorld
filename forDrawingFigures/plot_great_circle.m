function [h] = plot_great_circle(pt1, pt2, greatcircleWidth, greatcircleColor, method)


% assgin 3D points
x0 = 0;
y0 = 0;
z0 = 0;

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


% Let t range through the inner angle between v1 and v2
if (strcmp(method, 'arc'))
    t = linspace(0, atan2(norm(cross(v1,v2)),dot(v1,v2)));
elseif (strcmp(method, 'greatcircle'))
    t = linspace(0, 2*pi);
end
v = v1*cos(t) + v3*sin(t); % v traces great circle path, relative to center


% draw great circle on the unit sphere
h = plot3(v(1,:)+x0, v(2,:)+y0, v(3,:)+z0, 'LineWidth', greatcircleWidth, 'Color', greatcircleColor);


end