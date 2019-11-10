clear all; close all;

image_folder = '/Users/arsen/Documents/GitHub/EECE5639_Computer-Vision/Project3';
file_names = dir(fullfile(image_folder,'*.JPG'));
total_images = numel(file_names);
img = cell(1,total_images);

for k = 1:total_images
    File = fullfile(image_folder,file_names(k).name);
    img{k} = imread(File);
end

Cones_left = img{1};
Cones_right = img{2};
cast_left = img{3};
cast_right = img{4};

%[corr_left,corr_right] = getCorr_clean(Cones_left,Cones_right);
%[F,inlinerIndex] = estimateFundamentalMatrix(corr_left,corr_right);

i = 1; good = true;
while good == true
    [M_left_inliner,M_right_inliner,error(i),F(:,:,i)] = drawCorr_inliner(Cones_left,Cones_right);
    if error(i) ~=10
        MB_left_inliner = M_left_inliner;
        MB_right_inliner = M_right_inliner;
        FG = F(:,:,i-1);
        FB = F(:,:,i);
        good = false;
        ColorList = {'red','green','blue','yellow','cyan','magenta','white','black'};
        figure(1),
        stackedImage = cat(2, Cones_left, Cones_right); % Places the two images side by side
        imshow(stackedImage);
        title('Inliner Matches when picking bad Homography');
        width = size(Cones_left, 2);
        hold on;
        numPoints = length(MB_left_inliner(:,1)); % points2 must have same # of points
        % % Note, we must offset by the width of the image
        for i = 1 : numPoints
            color = mod(i,8) + 1;
            plot(MB_left_inliner(i, 1), MB_left_inliner(i, 2), 'y+', MB_right_inliner(i, 1) + width, ...
                 MB_right_inliner(i, 2), 'y+');
            line([MB_left_inliner(i, 1) MB_right_inliner(i, 1) + width], [MB_left_inliner(i, 2) MB_right_inliner(i, 2)], ...
                 'Color', ColorList{color});
        end

    end
    i = i+1;
end
%drawCorr(Cones_left,Cones_right);

% 
% [R_left,CornersHDC_left] = HarrisCornerDet(Cones_left);
% [R_right,CornersHDC_right] = HarrisCornerDet(Cones_right);
% [Filters,corrA] = getFilter(R_left,R_left,5);
% 
% for i = 1:length(Filters(1,1,:))
%     corr_map(:,:,i) = getNormCorr(R_right,Filters(:,:,i));
%     [x,y] = find(corr_map(:,:,i)==max(max(corr_map(:,:,i))));
%     corrB(i,1) = x;
%     corrB(i,2) = y;
% end
% 
% [F,inlinerIndex] = estimateFundamentalMatrix(corrA,corrB,'Method','RANSAC');
% left_inliner = corrA(find(inlinerIndex==1),:);
% right_inliner = corrB(find(inlinerIndex==1),:);
% 
% ColorList = {'red','green','blue','yellow','cyan','magenta','white','black'};
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
%     plot(left_inliner(i, 1), left_inliner(i, 2), 'y+', right_inliner(i, 1) + width, ...
%          right_inliner(i, 2), 'y+');
%     line([left_inliner(i, 1) right_inliner(i, 1) + width], [left_inliner(i, 2) right_inliner(i, 2)], ...
%          'Color', ColorList{color});
% end