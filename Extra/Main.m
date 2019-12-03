clear all; close all;

image_folder = 'D:\GitHub\EECE5639_Computer-Vision\Extra\hotel';
file_names = dir(fullfile(image_folder,'*.png'));
total_images = numel(file_names);
img = cell(1,total_images);


for k = 1:total_images
    File = fullfile(image_folder,file_names(k).name);
    img{k} = imread(File);
end
% for k = 1:total_images
%     imshow(img{k})
% end
outputVideo = VideoWriter(fullfile('D:\GitHub\EECE5639_Computer-Vision\Extra','frame.avi'));
outputVideo.FrameRate = 10;
open(outputVideo)
for i = 1:total_images
   writeVideo(outputVideo,img{i})
end
pointTracker = vision.PointTracker;
[points,point_validity,scores] = pointTracker(outputVideo);
close(outputVideo)
%[interest_y,interest_x,m] = harris(img{k},1000);


