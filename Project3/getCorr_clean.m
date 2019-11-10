function [corr_left,corr_right] = getCorr_clean(ImageA,ImageB)

% Finding points and features in left
grayImage = rgb2gray(ImageA);
[y,x]= harris(grayImage,1000,'tile',[2 2],'disp');
points_left = cornerPoints([x y]);
[features_left, points_left] = extractFeatures(grayImage, points_left);

% Finding points and features in right
grayImage = rgb2gray(ImageB);
[y,x]= harris(grayImage,1000,'tile',[2 2],'disp');
points_right = cornerPoints([x y]);
[features_right, points_right] = extractFeatures(grayImage, points_right);

indexPairs = matchFeatures(features_right, features_left, 'Unique', true);
matchedPoints_right = points_right(indexPairs(:,1), :);
matchedPoints_left = points_left(indexPairs(:,2), :);

corr_left = matchedPoints_left.Location;
corr_right = matchedPoints_right.Location;