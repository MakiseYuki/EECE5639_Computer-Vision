function [M_left,M_right,F,inlinerIndex] = getFundamental(Cones_left,Cones_right)

% Finding points and features in left
grayImage = rgb2gray(Cones_left);
[y,x]= harris(grayImage,2000,'tile',[2 2],'disp');
points_left = cornerPoints([x y]);
[features_left, points_left] = extractFeatures(grayImage, points_left);

% Finding points and features in right
grayImage = rgb2gray(Cones_right);
[y,x]= harris(grayImage,2000,'tile',[2 2],'disp');
points_right = cornerPoints([x y]);
[features_right, points_right] = extractFeatures(grayImage, points_right);

indexPairs = matchFeatures(features_right, features_left, 'Unique', true);
matchedPoints_right = points_right(indexPairs(:,1), :);
matchedPoints_left = points_left(indexPairs(:,2), :);

M_left = matchedPoints_left.Location;
M_right = matchedPoints_right.Location;
[F,inlinerIndex] = estimateFundamentalMatrix(M_left,M_right,'Method','RANSAC','NumTrial',4);
