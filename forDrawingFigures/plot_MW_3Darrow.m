function plot_MW_3Darrow(R_gb, stemRatio)

% convert new global frame only for good view
R_gnew_g = [0 0 -1; 1 0 0; 0 -1 0];
R_gb = R_gnew_g * R_gb;


% x-,y-,z- axis of body frame ([x-|y-|z-| and (-) x-|y-|z-]) in body frame
xyzAxis_b = [eye(3), -eye(3)];


% x-,y-,z- axis of body frame ([x-|y-|z-| and (-) x-|y-|z-]) in global frame
xyzAxis_g  = R_gb * xyzAxis_b;


% draw 3D arrow in global frame
arrow3D([0,0,0],[xyzAxis_g(:,1)],'r',stemRatio);
arrow3D([0,0,0],[xyzAxis_g(:,4)],'r',stemRatio);

arrow3D([0,0,0],[xyzAxis_g(:,2)],'g',stemRatio);
arrow3D([0,0,0],[xyzAxis_g(:,5)],'g',stemRatio);

arrow3D([0,0,0],[xyzAxis_g(:,3)],'b',stemRatio);
arrow3D([0,0,0],[xyzAxis_g(:,6)],'b',stemRatio);


% mArrow3([0 0 0],[xyzAxis_g(:,1)],'color','red','stemWidth',stemWidth,'tipWidth',tipWidth);
% mArrow3([0 0 0],[xyzAxis_g(:,4)],'color','red','stemWidth',stemWidth,'tipWidth',tipWidth);
%
% mArrow3([0 0 0],[xyzAxis_g(:,2)],'color','green','stemWidth',stemWidth,'tipWidth',tipWidth);
% mArrow3([0 0 0],[xyzAxis_g(:,5)],'color','green','stemWidth',stemWidth,'tipWidth',tipWidth);
%
% mArrow3([0 0 0],[xyzAxis_g(:,3)],'color','blue','stemWidth',stemWidth,'tipWidth',tipWidth);
% mArrow3([0 0 0],[xyzAxis_g(:,6)],'color','blue','stemWidth',stemWidth,'tipWidth',tipWidth);


end