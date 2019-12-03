clear all; close all;

image_folder = 'D:\GitHub\EECE5639_Computer-Vision\Project4\CarTrainImages';
file_names = dir(fullfile(image_folder,'*.JPG'));
total_images = numel(file_names);
img = cell(1,total_images);

psize_r = 12;
[height,width] = size(img{1});

for k = 1:total_images
    File = fullfile(image_folder,file_names(k).name);
    img{k} = imread(File);
end

outputVideo = VideoWriter(fullfile('D:\GitHub\EECE5639_Computer-Vision\Project4','frame.avi'));
outputVideo.FrameRate = 10;
open(outputVideo)
for ii = 1:total_images
   writeVideo(outputVideo,img{ii})
end
close(outputVideo)
%[interest_y,interest_x,m] = harris(img{k},1000);


