clc;
close all;
clear all;

syms theta;

alpha_found = deg2rad(2);
%VerticalDirection=[-0.606;0.128;0.7849];
VerticalDirection=[-0.22248;-0.92235;-0.3158528];
VerticalDirection =  VerticalDirection/norm(VerticalDirection);

%normal = [0.417;-0.902;-0.105];
normal = [0.755381892417669;0.305246802094997;0.579847037086747];
normal = normal/norm(normal);
beta = asin(normal(3));
alpha = atan(normal(2)/normal(1));
params = parametrizeHorizontalDD([cos(alpha), sin(alpha), cos(beta), sin(beta)]);
A1=params(1);B1=params(2);A2=params(3);B2=params(4);A3=params(5);B3=params(6); 

u_normal = [A1;A2;A3];
rotationMatrix = [cos(theta) + normal(1)^2 * (1 - cos(theta)), normal(1) * normal(2) * (1 - cos(theta)) - normal(3) * sin(theta), normal(1) * normal(3) * (1 - cos(theta)) + normal(2) * sin(theta);
                  normal(1) * normal(2) * (1 - cos(theta)) + normal(3) * sin(theta), cos(theta) + normal(2)^2 * (1 - cos(theta)), normal(2) * normal(3) * (1 - cos(theta)) - normal(1) * sin(theta);
                  normal(1) * normal(3) * (1 - cos(theta)) - normal(2) * sin(theta), normal(2) * normal(3) * (1 - cos(theta)) + normal(1) * sin(theta), cos(theta) + normal(3)^2 * (1 - cos(theta))];

vector1 = rotationMatrix*u_normal;


eqn = dot(VerticalDirection,vector1) == cos(alpha_found);
theta_sol = vpasolve(eqn, theta, 2.3)
%S = solve(eqn,theta,'Real',true)
