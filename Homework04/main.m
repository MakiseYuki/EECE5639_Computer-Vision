%clear all; close all;

% Read in two images. If the images are large, you may want to reduce
% theirsize to keep running time reasonable!
% Document in your report the scale factor you used
image_folder = '/Users/arsen/Documents/GitHub/EECE5639_Computer-Vision/Homework04/DanaHallWall';
file_names = dir(fullfile(image_folder,'*.jpg'));
total_images = numel(file_names);

ImageA = imread(fullfile(image_folder,file_names(1).name));

img1 = ImageA(:,:,1);
ImageB = imread(fullfile(image_folder,file_names(2).name));

img2 = ImageB(:,:,1);
ImageC = imread(fullfile(image_folder,file_names(3).name));

% Apply Harris corner detector to both images: compute Harris R function 
% over the image, and then do non-maimum suppression to get a sparse set of
% corner features.

[R_ImageA, Corners_A] = HarrisCornerDet(ImageA);

[R_ImageB, Corners_B] = HarrisCornerDet(ImageB);

[R_ImageC, Corners_C] = HarrisCornerDet(ImageC);

maxNormCorr = getMaxNormCorr(Corners_A,R_ImageB,2);




