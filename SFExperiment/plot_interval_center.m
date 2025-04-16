function [] = plot_interval_center(R_cM_final,greatcircleNormal,nonAssociatedLines,colors)
numLines = size(nonAssociatedLines,2);
vpsXextraLineNormals = [];
for m = 1:3
    % VPS (In gist_union, 2 is the main horizontal direction)
    plot3([0 R_cM_final(1,m)],[0 R_cM_final(2,m)],[0 R_cM_final(3,m)],colors{m}, 'LineWidth', 5);
    plot3([0 -R_cM_final(1,m)],[0 -R_cM_final(2,m)],[0 -R_cM_final(3,m)],colors{m}, 'LineWidth', 5);
    for k = 1:numLines
    vpsXextraLineNormal = cross( greatcircleNormal(nonAssociatedLines(k),:) , R_cM_final(:,m) );
    vpsXextraLineNormal = vpsXextraLineNormal/norm(vpsXextraLineNormal);
        if m == 2
        plot3([0 vpsXextraLineNormal(1)],[0 vpsXextraLineNormal(2)],[0 vpsXextraLineNormal(3)], ...
                'MarkerSize', 20, 'Color' ,'c','LineWidth', 1);
        end
    end
end
