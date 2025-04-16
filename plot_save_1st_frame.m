% save directory for MAT data
SaveDir = [datasetPath '/CVPR2018'];
if (~exist( SaveDir, 'dir' ))
    mkdir(SaveDir);
end

% save directory for images
SaveImDir = [SaveDir '/LPIC'];
if (~exist( SaveImDir, 'dir' ))
    mkdir(SaveImDir);
end

pause(0.01); refresh;
saveImg = getframe(figure(9));
%saveImg = getframe(figure(4));
imwrite(saveImg.cdata , [SaveImDir sprintf('/%06d.png', imgIdx)]);
%imwrite(saveImg.cdata , [SaveImDir sprintf('/us%06d.png', imgIdx)]);