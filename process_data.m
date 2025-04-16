function process_data(data_path)

% extract color image files
disp('Extract color images from video...');
video_path = [data_path '/rgb_new.mp4'];
image_path = [data_path '/rgb_new'];
if (~exist(video_path, 'file'))
    disp('cant find mp4')
    !ffmpeg -i [data_path '/rgb.mp4'] -c:v h264 video_path
    %!ffmpeg -i './gist_union/rgb.mp4' -c:v h264 './gist_union/rgb_new.mp4'
end
if (~exist(image_path, 'dir'))
    mkdir(image_path);
    extract_color_frames(video_path, image_path);
end

% rename depth image files
depth_old_path = [data_path '/depth'];
depth_new_path = [data_path '/depth_new'];
if (~exist(depth_new_path, 'dir'))
    mkdir(depth_new_path);
    rename_depth_frames(depth_old_path, depth_new_path);
end

% rename depth image files
confidence_old_path = [data_path '/confidence'];
confidence_new_path = [data_path '/confidence_new'];
if (~exist(confidence_new_path, 'dir'))
    mkdir(confidence_new_path);
    rename_confidence_frames(confidence_old_path, confidence_new_path);
end