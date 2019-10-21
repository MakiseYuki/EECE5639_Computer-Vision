clear all;

image_folder = '/Users/arsen/Documents/GitHub/EECE5639_Computer-Vision/Project2/DanaHallWay1/';
file_names = dir(fullfile(image_folder,'*.JPG'));
total_images = numel(file_names);
img = cell(1,total_images);

for k = 1:total_images
    F = fullfile(image_folder,file_names(k).name);
    img{k} = imread(F);
end

A = img{1};

A = rgb2gray(A)

[y,x] = harris(A,500,'tile',[2 2],'disp');