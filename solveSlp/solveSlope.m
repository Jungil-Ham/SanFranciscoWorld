
function [theta_sol,u_normal, hor_AF] = solveSlope(R_cM_initial, planeNormalVector, pNVIdx, greatcircleNormal, alpha)

syms theta;
colors = {'r', 'g', 'b', 'c', 'm', 'y'};
theta_sol = [];
if(pNVIdx == 3)
alpha_found = alpha;
elseif (pNVIdx ==2)
alpha_found = pi/2 - alpha;
end
VD=planeNormalVector;
normal = greatcircleNormal;
normal = normal/norm(normal);
beta = asin(normal(3));
alpha = atan(normal(2)/normal(1));
params = parametrizeHorizontalDD([cos(alpha), sin(alpha), cos(beta), sin(beta)]);
A1=params(1);B1=params(2);A2=params(3);B2=params(4);A3=params(5);B3=params(6); 

u_normal = [A1;A2;A3];
v_normal = cross(u_normal,normal);
theta_pre = 0.01;
%theta_pre = abs(acos(dot(u_normal,R_cM_initial(:,4))));
rotationMatrix = [cos(theta) + normal(1)^2 * (1 - cos(theta)), normal(1) * normal(2) * (1 - cos(theta)) - normal(3) * sin(theta), normal(1) * normal(3) * (1 - cos(theta)) + normal(2) * sin(theta);
                  normal(1) * normal(2) * (1 - cos(theta)) + normal(3) * sin(theta), cos(theta) + normal(2)^2 * (1 - cos(theta)), normal(2) * normal(3) * (1 - cos(theta)) - normal(1) * sin(theta);
                  normal(1) * normal(3) * (1 - cos(theta)) - normal(2) * sin(theta), normal(2) * normal(3) * (1 - cos(theta)) + normal(1) * sin(theta), cos(theta) + normal(3)^2 * (1 - cos(theta))];

vector1 = rotationMatrix*u_normal;
vector2 = rotationMatrix*-u_normal;

eqn = dot(VD,vector1) == cos(alpha_found);
eqn2 = dot(VD,vector2) == cos(alpha_found);
theta_sol = vpasolve(eqn, theta, theta_pre);
theta_sol2 = vpasolve(eqn2, theta, theta_pre);
%theta_sol = [theta_sol theta_sol2]
theta_sol = double(theta_sol);
theta_sol2 = double(theta_sol2);
theta_sol_total = [theta_sol theta_sol2];
rotationMatrix1 = [cos(theta_sol) + normal(1)^2 * (1 - cos(theta_sol)), normal(1) * normal(2) * (1 - cos(theta_sol)) - normal(3) * sin(theta_sol), normal(1) * normal(3) * (1 - cos(theta_sol)) + normal(2) * sin(theta_sol);
                  normal(1) * normal(2) * (1 - cos(theta_sol)) + normal(3) * sin(theta_sol), cos(theta_sol) + normal(2)^2 * (1 - cos(theta_sol)), normal(2) * normal(3) * (1 - cos(theta_sol)) - normal(1) * sin(theta_sol);
                  normal(1) * normal(3) * (1 - cos(theta_sol)) - normal(2) * sin(theta_sol), normal(2) * normal(3) * (1 - cos(theta_sol)) + normal(1) * sin(theta_sol), cos(theta_sol) + normal(3)^2 * (1 - cos(theta_sol))];
rotationMatrix2 = [cos(theta_sol2) + normal(1)^2 * (1 - cos(theta_sol2)), normal(1) * normal(2) * (1 - cos(theta_sol2)) - normal(3) * sin(theta_sol2), normal(1) * normal(3) * (1 - cos(theta_sol2)) + normal(2) * sin(theta_sol2);
                  normal(1) * normal(2) * (1 - cos(theta_sol2)) + normal(3) * sin(theta_sol2), cos(theta_sol2) + normal(2)^2 * (1 - cos(theta_sol2)), normal(2) * normal(3) * (1 - cos(theta_sol2)) - normal(1) * sin(theta_sol2);
                  normal(1) * normal(3) * (1 - cos(theta_sol2)) - normal(2) * sin(theta_sol2), normal(2) * normal(3) * (1 - cos(theta_sol2)) + normal(1) * sin(theta_sol2), cos(theta_sol2) + normal(3)^2 * (1 - cos(theta_sol2))];

excIdx = [1 2 3];


figure(20); cla;
plot_unit_sphere(1, 18, 0.8); hold on; grid on; axis equal;
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
f = FigureRotator(gca());
for k = 1:3
    plot3([0 R_cM_initial(1,k)],[0 R_cM_initial(2,k)],[0 R_cM_initial(3,k)], 'Color' ,colors{k},'LineWidth', 5);
    plot3([0 -R_cM_initial(1,k)],[0 -R_cM_initial(2,k)],[0 -R_cM_initial(3,k)], 'Color' ,colors{k},'LineWidth', 5);
end

plot3([0 planeNormalVector(1)],[0 planeNormalVector(2)],[0 planeNormalVector(3)],'o', 'Color' ,'k','LineWidth', 3);
plot3([0 greatcircleNormal(1)],[0 greatcircleNormal(2)],[0 greatcircleNormal(3)],'o', 'Color' ,'m','LineWidth', 3);
plot_great_circle(u_normal, v_normal, 3, 'k', 'greatcircle');

figure(21); cla;
plot_s(alpha_found, planeNormalVector, greatcircleNormal);


if ~isempty(theta_sol_total)
    vector1 = rotationMatrix1*u_normal;
    [corrIdx, ~, find_Idx] = identyfyVP_large(R_cM_initial, excIdx, vector1);
    if(find_Idx ==0)
        vector1 =[];
    end
    vector2 = rotationMatrix2*-u_normal;
    [corrIdx, ~, find_Idx] = identyfyVP_large(R_cM_initial, excIdx, vector2);
    if(find_Idx ==0)
        vector2 = [];
    end
    hor_AF = [vector1 vector2];
else
    hor_AF = [];
end




%S = solve(eqn,theta,'Real',true)
