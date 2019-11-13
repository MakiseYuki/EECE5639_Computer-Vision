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

hsv = rgb2hsv(Cones_left);

% disp_corr = getDisp_corr(Cones_left,Cones_right);
% disp_hor = disp_corr(:,1);
% disp_ver = disp_corr(:,2);
% 
% HSL = image2hsl(Cones_left);
% 
% F = getFundamental(Cones_left,Cones_right);


[corrA,corrB,F,inlinerIndex] = getFundamental(cast_left,cast_right);

[v_map,h_map,disp_map] = densedisparitymap(cast_left,cast_right,corrA,corrB,F);

[x,y] = size(v_map);

for i = 1:x
    for j = 1:y
        d1 = v_map(i,j);
        if j-d1 > 0 && j-d1 <= y
            c_map(i,j) = d1 - v_map(i,j-d1);
        else
            c_map(i,j) = NaN;
        end
            
    end
end

C = abs(c_map);
ids = find(C<5);

true_map = zeros(size(C));
true_map(ids) = v_map(ids); 
true_map(find(true_map==0)) = NaN;
true_map(find(true_map>10)) = NaN;
%true_map = mat2gray(abs(true_map));


% [map_v,map_h,map_dis] = disparitymap(Cones_left,Cones_right);
% map_h = mat2gray(map_h);
% map_v = mat2gray(map_v);
% map_dis = mat2gray(map_dis);
% 
% HSV(:,:,1) = hsv(:,:,1);
% HSV(:,:,2) = hsv(:,:,2);
% HSV(:,:,3) = map_dis;
% 
% HSV = hsv2rgb(HSV);
% 
% figure(1), subplot(1,3,1);
% imshow(map_h);
% figure(1), subplot(1,3,2);
% imshow(map_v);
% figure(1), subplot(1,3,3);
% imshow(map_dis);
