function drawCorr(Cones_left,Cones_right)

% Finding points and features in left
grayImage = rgb2gray(Cones_left);
[y,x]= harris(grayImage,1000,'tile',[2 2],'disp');
points_left = cornerPoints([x y]);
[features_left, points_left] = extractFeatures(grayImage, points_left);

% Finding points and features in right
grayImage = rgb2gray(Cones_right);
[y,x]= harris(grayImage,1000,'tile',[2 2],'disp');
points_right = cornerPoints([x y]);
[features_right, points_right] = extractFeatures(grayImage, points_right);

indexPairs = matchFeatures(features_right, features_left, 'Unique', true);
matchedPoints_right = points_right(indexPairs(:,1), :);
matchedPoints_left = points_left(indexPairs(:,2), :);

M_left = matchedPoints_left.Location;
M_right = matchedPoints_right.Location;

figure,
stackedImage = cat(2, Cones_left, Cones_right); % Places the two images side by side
imshow(stackedImage);
width = size(Cones_left, 2);
hold on;
numPoints = size(M_left, 1); % points2 must have same # of points
% % Note, we must offset by the width of the image
ColorList = {'red','green','blue','yellow','cyan','magenta','white','black'};
for i = 1 : numPoints
    color = mod(i,8) + 1;
    plot(M_left(i, 1), M_left(i, 2), 'y+', M_right(i, 1) + width, ...
         M_right(i, 2), 'y+');
    line([M_left(i, 1) M_right(i, 1) + width], [M_left(i, 2) M_right(i, 2)], ...
         'Color', ColorList{color});
end
