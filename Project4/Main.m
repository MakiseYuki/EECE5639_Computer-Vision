clear all; close all;

image_folder = 'D:\GitHub\EECE5639_Computer-Vision\Project4\CarTrainImages';
file_names = dir(fullfile(image_folder,'*.JPG'));
total_images = numel(file_names);
img = cell(1,total_images);

for k = 1:total_images
    File = fullfile(image_folder,file_names(k).name);
    img{k} = imread(File);
end

 [interest_y,interest_x,m] = harris(img{1},1000);



