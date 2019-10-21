clear all; close all;

% Read in two images. If the images are large, you may want to reduce
% theirsize to keep running time reasonable!
% Document in your report the scale factor you used
image_folder = '/Users/arsen/Documents/GitHub/EECE5639_Computer-Vision/Project2/Yuan/DanaHallWall';
file_names = dir(fullfile(image_folder,'*.jpg'));
total_images = numel(file_names);

ImageA = imread(fullfile(image_folder,file_names(1).name));
%ImageA_gray = rgb2gray(ImageA);
%imshow(ImageA);

ImageB = imread(fullfile(image_folder,file_names(2).name));
%ImageB_gray = rgb2gray(ImageB);
%imshow(ImageB);

ImageC = imread(fullfile(image_folder,file_names(3).name));
%ImageB_gray = rgb2gray(ImageB);
%imshow(ImageB);

% Apply Harris corner detector to both images: compute Harris R function 
% over the image, and then do non-maimum suppression to get a sparse set of
% corner features.

[R_ImageA, Corners_A] = HarrisCornerDet(ImageA);
%imshow(Corners_A);

[R_ImageB, Corners_B] = HarrisCornerDet(ImageB);
%imshow(Corners_B);

[R_ImageC, Corners_C] = HarrisCornerDet(ImageC);
%imshow(Corners_C)
% Find correspondences between the two images: given two set of corners 
% from the two images, compute normalized cross correlation (NCC) of image 
% patches centered at each corner. (Note that this will be O(n^2) process.)
% Choose potential corner matches by finding pair of corners (one from each
% image) such that they have the highest NCC value. You may also set a
% threshold to keep only matches that have a large NCC score.

[NCC_A,match_A] = NormCrossCor(R_ImageA, R_ImageB, Corners_A, Corners_B);
[NCC_B,match_B] = NormCrossCor(R_ImageB, R_ImageC, Corners_B, Corners_C);
[NCC_C,match_C] = NormCrossCor(R_ImageC, R_ImageB, Corners_C, Corners_B);

% [NCC_B,NCC_C,B_fmap,C_fmap] = NormCrossCor(R_ImageB, R_ImageB, Corners_B, Corners_C);
% 
subplot(2,2,1); imshow(match_A), title('NCC A');
subplot(2,2,2); imshow(match_B), title('NCC B');
subplot(2,2,3); imshow(match_C), title('NCC C');

% 
% [x,y] = find(AB_fmap==255);
% pts1(1,:) = x;
% pts1(2,:) = y;
% [x,y] = find(BC_fmap==255);
% pts2(1,:) = x;
% pts2(2,:) = y;
% 
% [match scores] = match_descr(pts1,pts2);

% [A_row,A_col] = find(Corners_A > 0);
% [B_row,B_col] = find(Corners_B > 0);

% match_p = zeros(A_row,A_col);
% 
% if size(A_row) > size(B_row)      
%         match_p(i,j) = R_AB(A_row(i),A_col(i));
% else
%         match_p(i,j) = R_AB(B_row(i),B_col(i));
% end






% pts_A = [row_A;col_A];
% pts_B = [row_B;col_B];
% 
% [H corrPtIdx] = findHomography(pts_A,pts_B);


% % Use RANSAC to robustly estimate the homography from the noisy
% % correspondences:
% filtered_Corres_AB = myRANSAC(Corres_AB);
% 
% % Estimate the homography using the above correspondences.
% E_homog = estHomoG(filtered_Corres_AB);
% 
% % Warp one image onto the other one, blending overlapping pixels together
% % to create a single image that shows the union of all pixels from both
% % input images. You can choose which of the images to warp. 
% com_ImageAB = imgWarp(ImageA, ImageB, E_homog);
% %imshow(com_ImageAB);