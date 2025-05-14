function [h_line, h_plane] = plot_horizontal_dominant_plane(horizontalDominantDirection, greatcircleWidth, greatcircleColor)

% generate the plane basis vectors from surface normal
tempVector = rand(3,1);
tempVector = tempVector / norm(tempVector);

pt1_basis = cross(horizontalDominantDirection,tempVector);
pt1_basis = pt1_basis / norm(pt1_basis);

pt2_basis = cross(horizontalDominantDirection,pt1_basis);
pt2_basis = pt2_basis / norm(pt2_basis);


% assgin 3D points
x0 = 0;
y0 = 0;
z0 = 0;

x1 = pt1_basis(1);
y1 = pt1_basis(2);
z1 = pt1_basis(3);

x2 = pt2_basis(1);
y2 = pt2_basis(2);
z2 = pt2_basis(3);


% compute vectors
v1 = [x1-x0; y1-y0; z1-z0];       % Vector from center to 1st point
r = norm(v1);                          % The radius
v2 = [x2-x0;y2-y0;z2-z0];        % Vector from center to 2nd point
v3 = cross(cross(v1,v2),v1);     % v3 lies in plane of v1 & v2 and is orthog. to v1
v3 = r*v3/norm(v3);                % Make v3 of length r


% Let t range through the inner angle between v1 and v2
t = linspace(0, 2*pi);
v = v1*cos(t) + v3*sin(t); % v traces great circle path, relative to center


% draw great circle on the unit sphere
h_line = plot3(v(1,:)+x0, v(2,:)+y0, v(3,:)+z0, 'LineWidth', greatcircleWidth, 'Color', greatcircleColor);
%h_plane = patch(v(1,:)+x0, v(2,:)+y0, v(3,:)+z0, 'm');
%h_plane.FaceColor = greatcircleColor;
h_plane.FaceAlpha = 0.0;


end