function [targetImage] = getImgInASTRAdataset(datasetPath, TUMRGBDdataset, cam, frameIdx, imgType)

% read rgb and depth images
%imRgb = imread([datasetPath '/color1.jpg']);
%imRgb = imread([datasetPath '/color' num2str(frameIdx) '.jpg']);
imRgb = imread([datasetPath '/color_new/' sprintf('%06d', frameIdx) '.jpg']);
row=480;  col=640;
%fin=fopen([datasetPath '/depth1.raw'],'r');
%fin=fopen([datasetPath '/depth' num2str(frameIdx) '.raw'],'r');
fin=fopen([datasetPath '/depth_new/' sprintf('%06d', frameIdx) '.raw'],'r');
I=fread(fin, [col row],'uint16=>uint16'); 
imDepth=I';
%imDepth = imread([ datasetPath '/depth1.png']);
%imconfi = imread([ datasetPath '/' TUMRGBDdataset.confi.imgName{frameIdx} ]);
imRgbResized = imresize(imRgb, [size(imDepth)]);
imRgbResizedforLine = imRgb;


% determine what imgType is ( 'gray' or 'depth' or 'rgb' )
if ( strcmp(imgType, 'gray') )
    
    % convert rgb to gray image
    targetImage = uint8(rgb2gray(imRgbResizedforLine));
    
    % show current situation
    fprintf('----''%s'' images are imported to workspace [%04d] ---- \n', imgType, frameIdx);
    
    
elseif ( strcmp(imgType, 'depth') )
    
    % convert raw depth image to depth image [m]
    targetImage = double( double(imDepth) / 1000 );
    
    % show current situation
    fprintf('----''%s'' images are imported to workspace [%04d] ---- \n', imgType, frameIdx);
    
    
elseif ( strcmp(imgType, 'rgb') )
    
    % raw rgb image
    targetImage = imRgbResized;
    
    % show current situation
    fprintf('----''%s'' images are imported to workspace [%04d] ---- \n', imgType, frameIdx);
    %{
elseif ( strcmp(imgType, 'conf') )
    
    % raw rgb image
    targetImage = imconfi;
    
    % show current situation
    fprintf('----''%s'' images are imported to workspace [%04d] ---- \n', imgType, frameIdx);
    %}
else
    
    fprintf('\nWrong input(imgType) parameter!!! \n');
    fprintf('What is the ''%s'' ??\n',imgType);
    error('Wrong input(imgType) parameter!!!')
    
end

end