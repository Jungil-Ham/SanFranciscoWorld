function [targetImage] = getImgInTAMUdataset(datasetPath, TUMRGBDdataset, cam, frameIdx, imgType)

% read rgb and depth images
imRgb = imread([ datasetPath '/' TUMRGBDdataset.rgb.imgName{frameIdx} ]);
imDepth = imread([ datasetPath '/' TUMRGBDdataset.depth.imgName{frameIdx} ]);
%imconfi = imread([ datasetPath '/' TUMRGBDdataset.confi.imgName{frameIdx} ]);
imRgbResized = imresize(imRgb, [size(imDepth)]);
imRgbResizedforLine = imresize(imRgb, 1/cam.Ratio);


% determine what imgType is ( 'gray' or 'depth' or 'rgb' )
if ( strcmp(imgType, 'gray') )
    
    % convert rgb to gray image
    targetImage = uint8(rgb2gray(imRgbResizedforLine));
    
    % show current situation
    fprintf('----''%s'' images are imported to workspace [%04d] ---- \n', imgType, frameIdx);
    
    
elseif ( strcmp(imgType, 'depth') )
    
    % convert raw depth image to depth image [m]
    targetImage = double( double(imDepth) / cam.scaleFactor );
    
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