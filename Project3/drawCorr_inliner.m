function [M_left,M_right,error,F]= drawCorr_inliner(Cones_left,Cones_right)

% Finding points and features in left
grayImage = rgb2gray(Cones_left);
[y,x]= harris(grayImage,1000);
points_left = cornerPoints([x y]);
[features_left, points_left] = extractFeatures(grayImage, points_left);

% Finding points and features in right
grayImage = rgb2gray(Cones_right);
[y,x]= harris(grayImage,1000);
points_right = cornerPoints([x y]);
[features_right, points_right] = extractFeatures(grayImage, points_right);

indexPairs = matchFeatures(features_right, features_left, 'Unique', true);
matchedPoints_right = points_right(indexPairs(:,1), :);
matchedPoints_left = points_left(indexPairs(:,2), :);

M_left = matchedPoints_left.Location;
M_right = matchedPoints_right.Location;
[F,inlinerIndex] = estimateFundamentalMatrix(M_left,M_right,'Method','RANSAC','NumTrial',4);
error = length(find(inlinerIndex==0));
M_left_inliner = M_left(find(inlinerIndex==1),:);
M_right_inliner = M_right(find(inlinerIndex==1),:);
M_left_outliner = M_left(find(inlinerIndex==0),:);
M_right_outliner = M_right(find(inlinerIndex==0),:);
% ColorList = {'red','green','blue','yellow','cyan','magenta','white','black'};
% 
% figure(1),
% stackedImage = cat(2, Cones_left, Cones_right); % Places the two images side by side
% imshow(stackedImage);
% title('Inliner Matches');
% width = size(Cones_left, 2);
% hold on;
% numPoints = length(find(inlinerIndex==1)); % points2 must have same # of points
% % % Note, we must offset by the width of the image
% for i = 1 : numPoints
%     color = mod(i,8) + 1;
%     plot(M_left_inliner(i, 1), M_left_inliner(i, 2), 'y+', M_right_inliner(i, 1) + width, ...
%          M_right_inliner(i, 2), 'y+');
%     line([M_left_inliner(i, 1) M_right_inliner(i, 1) + width], [M_left_inliner(i, 2) M_right_inliner(i, 2)], ...
%          'Color', ColorList{color});
% end
% 
% figure(2),
% stackedImage = cat(2, Cones_left, Cones_right); % Places the two images side by side
% imshow(stackedImage);
% title('Outliner Matches');
% width = size(Cones_left, 2);
% hold on;
% numPoints = length(find(inlinerIndex==0)); % points2 must have same # of points
% % % Note, we must offset by the width of the image
% for i = 1 : numPoints
%     color = mod(i,8) + 1;
%     plot(M_left_outliner(i, 1), M_left_outliner(i, 2), 'y+', M_right_outliner(i, 1) + width, ...
%          M_right_outliner(i, 2), 'y+');
%     line([M_left_outliner(i, 1) M_right_outliner(i, 1) + width], [M_left_outliner(i, 2) M_right_outliner(i, 2)], ...
%          'Color', ColorList{color});
% end
