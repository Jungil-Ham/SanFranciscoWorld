function plot_ellipse_edge(planeNormal, d, lineWidth, lineColor)

% project ellipse on the unit sphere
[ellip] = general_determineEllipse(planeNormal, d);


% sample a set of 2D points
[xCoord, yCoord] = sampleEllipse(ellip); % in line 28 of sampleEllipse, adjust the sampling resolution.


% compute its z for (x,y)
a = planeNormal(1);
b = planeNormal(2);
c = planeNormal(3);
zCoord = (-a*xCoord - b*yCoord - d)/c;


% x/y/zCoord stores x/y/z-coordinates of a set of points on edge of spherical cap.
plot3(xCoord, yCoord, zCoord, lineColor, 'LineWidth', lineWidth);


% fill out ellipse with transparent gray color
h_fill = fill3(xCoord, yCoord, zCoord, [0.5 0.5 0.5]);
h_fill.FaceAlpha = 0.5;


end