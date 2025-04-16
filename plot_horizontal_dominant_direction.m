function [h1, h2] = plot_horizontal_dominant_direction(horizontalDominantDirection, arrowColor, arrowStemWidth)

% original horizontal direction
h1 = mArrow3([0;0;0],horizontalDominantDirection,'color',arrowColor,'stemWidth',arrowStemWidth);

% inverse horizontal direction
h2 = mArrow3([0;0;0],-horizontalDominantDirection,'color',arrowColor,'stemWidth',arrowStemWidth);


end

