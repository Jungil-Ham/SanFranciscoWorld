function [] = plot_image_show(lines,nonAssociatedLines,imageCurForLine, colors)

imshow(imageCurForLine,[]); hold on;
for k = 1:size(nonAssociatedLines,2)
    plot([lines(nonAssociatedLines(k),1),lines(nonAssociatedLines(k),3)],[lines(nonAssociatedLines(k),2),lines(nonAssociatedLines(k),4)], 'Color', colors{k}, 'LineWidth',2.5);
end

end