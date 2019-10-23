%clear all; close all;

% Read in two images. If the images are large, you may want to reduce
% theirsize to keep running time reasonable!
% Document in your report the scale factor you used
image_folder = '/Users/arsen/Documents/GitHub/EECE5639_Computer-Vision/Project2/Yuan/DanaHallWall';
file_names = dir(fullfile(image_folder,'*.jpg'));
total_images = numel(file_names);

ImageA = imread(fullfile(image_folder,file_names(1).name));
%ImageA_gray = rgb2gray(ImageA);
%imshow(ImageA);
img1 = ImageA(:,:,1);
ImageB = imread(fullfile(image_folder,file_names(2).name));
%ImageB_gray = rgb2gray(ImageB);
%imshow(ImageB);
img2 = ImageB(:,:,1);
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
% 
[NCC_A,NCC_B] = NormCrossCor(R_ImageA, R_ImageB, Corners_A, Corners_B);


% [x,y] = find(NCC_A>0.3);
% [x2,y2] = find(NCC_B>0.3);
% 
% for i = 1:length(x2)
%     s(i) = NCC_BA(x2(i),y2(i));
% end
% M = maxk(s,length(x)); m = min(M);
% 
% [x2,y2] = find(NCC_BA >= m);
% 
% pts1 = zeros(2,length(x));
% pts2 = zeros(2,length(x2));
% % 
% pts1(1,:) = x;
% pts1(2,:) = y;
% 
% pts2(1,:) = x2;
% pts2(2,:) = y2;
% 
% pts1 = pts1';
% pts2 = pts2';
% % 
% line_color = ["blue" "green" "yellow" "cyan" "magenta" "red"];
% c = 1;
% figure;
% stackedImage = cat(1, img2, img1); % Places the two images side by side
% imshow(stackedImage);
% width = size(img1, 1);
% hold on;
% numPoints = length(pts1); % points2 must have same # of points
% % Note, we must offset by the width of the image
% for i = 1 : numPoints
%     
%     if c == 6
%         c = 1;
%     end
%     plot(pts1(1, i), pts1(2, i), 'y+', pts2(1, i), ...
%          pts2(2, i)+ width, 'y+');
%     line([pts1(1, i) pts1(1, i)], [pts2(2, i) pts1(2, i) + width], ...
%          'Color', line_color(c));
%     c = c+1;
% end

%[minx,miny] = find(NCC_AB==min(NCC))

% count = 0;
% min_x = zeros(1,4);
% min_y = zeros(1,4);
% min_x2 = zeros(1,4);
% min_y2 = zeros(1,4);

% thre = 0.9;
% [x,y] = find(NCC_A ~= 0);
%[x2,y2] = find(NCC_B > thre);



% for i = 1:4
%     p4_x(i) = (x(i*600));
%     p4_y(i) = (y(i*600));
%     p4_x2(i) = (x2(i*800));
%     p4_y2(i) = (y2(i*800));
% end



%[x2,y2] = find(NCC_BA>0.8);
% 
% x_t = zeros(2,length(x)); y_t = zeros(2,length(y2));
% 
% x_t(1,:) = x'; x_t(2,:) = y'; y_t(1,:) = x2'; y_t(2,:) = y2';
% 
% [H,Corrptx] = findHomography(x_t,y_t);


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

% I = cell(1,2);
% 
% I{1} = rgb2gray(ImageA);
% I{2} = rgb2gray(ImageB);
% 
% out = imtile(I);
% imshow(out);
% axis on
% hold on;
% plot(p4_x(1),p4_y(1), 'r+', 'MarkerSize', 5, 'LineWidth', 1);
% plot(p4_x2(1)+512,p4_y2(1), 'g+', 'MarkerSize', 5, 'LineWidth', 1);






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