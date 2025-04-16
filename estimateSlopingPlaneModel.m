function [normPlaneModel] = estimateSlopingPlaneModel(N1, N2)

normalVector = cross(N1, N2)';


% calculate the model parameters of the plane eqn
normPlaneModel = normalVector ./ norm(normalVector); 
end
