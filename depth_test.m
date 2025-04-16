datasetPath = './astra_stair';
row=480;  col=640;
for frameIdx = 0:100
%fin=fopen([datasetPath '/depth1.raw'],'r');
%fin=fopen([datasetPath '/depth' num2str(frameIdx) '.raw'],'r');
fin=fopen([datasetPath '/depth_new/' sprintf('%d', frameIdx) '.raw'],'r');
I=fread(fin, [col row],'uint16=>uint16'); 
imDepth=I';
h = figure(1);
imshow(imDepth);

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
saveImg = getframe(h);
imwrite(saveImg.cdata , [SaveImDir sprintf('/%06d.png', frameIdx)]);
end