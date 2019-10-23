%clear all; close all;

image_folder = '/Users/arsen/Documents/GitHub/EECE5639_Computer-Vision/Project2/Yuan/DanaHallWall';
file_names = dir(fullfile(image_folder,'*.jpg'));
total_images = numel(file_names);

ImageA = imread(fullfile(image_folder,file_names(1).name));

ImageB = imread(fullfile(image_folder,file_names(2).name));

ImageC = imread(fullfile(image_folder,file_names(3).name));

I1 = rgb2gray(ImageB);
I2 = rgb2gray(ImageC);

points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

[f1, vpts1] = extractFeatures(I1, points1);
[f2, vpts2] = extractFeatures(I2, points2);

indexPairs = matchFeatures(f1, f2) ;
matchedPoints1 = vpts1(indexPairs(1:7, 1));
matchedPoints2 = vpts2(indexPairs(1:7, 2));

figure; ax = axes;
showMatchedFeatures(ImageB,ImageC,matchedPoints1,matchedPoints2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
%legend(ax, 'Matched points 1','Matched points 2');