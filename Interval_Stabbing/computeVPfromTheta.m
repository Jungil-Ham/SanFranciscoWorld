function hor_AF = computeVPfromTheta(axis, thetas, auxDirection)

% % A * cos + B * sin + C  
% %  blue_after    red_after                               
% %   A1 B1 C1     A4 B4 C4     
% %  [A2 B2 C2],  [A5 B5 C5]
% %   A3 B3 C3     A6 B6 C6
% 
% 
beta = asin(axis(3));
alpha = atan(axis(2)/axis(1));
params = parametrizeHorizontalDD([cos(alpha), sin(alpha), cos(beta), sin(beta)]);
A1=params(1);B1=params(2);A2=params(3);B2=params(4);A3=params(5);B3=params(6); 
u = [A1;A2;A3];
offset = [acos(u.'*auxDirection) acos(u.'*auxDirection)];
diff = auxDirection - u;
direction_vector = cross(axis, diff);
rotation_direction = dot(u, direction_vector);
if rotation_direction > 0
    offset = -offset;
end
offset_unit = offset(1);

hor_AF = [];
    % R w.r.t. one paramter
    for i = 1:size(thetas,2)
        col_x = A1*cos(thetas(i)+offset_unit)+B1*sin(thetas(i)+offset_unit); % third col -- d1 unit vector
        col_y = A2*cos(thetas(i)+offset_unit)+B2*sin(thetas(i)+offset_unit); 
        col_z = A3*cos(thetas(i)+offset_unit)+B3*sin(thetas(i)+offset_unit);

        hor_AF = [hor_AF,[col_x; col_y; col_z]];
    end
    
end