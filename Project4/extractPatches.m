function [img_sub, img_dis]  = extractPatches(I,P)
% function extractPatches extract a fixed size image patch (25 × 25 pixels)
% and use the vector of raw pixel intensities as the ?descriptor?.
% Input:
%   I: input image
%   P: interest points
% Output:
%   img_sub: cropped image in vectorization
%   img_dis: cropped image center pixel location
% 

% this has to be an odd x odd pixels, interested point at the center
pSize = 25; % 25 x 25 pixels
[rId, cId] = find(P);
marg=floor(pSize/2);
img_count=0;
img_sub={};
img_dis={};

% Check the dimensions of the image. number of Color Bands should be = 1.
% This section can comment out if we know the image is gray scale
[row, col, band] = size(I);
if band > 1
    % It's not gray scale Image and convert it to gray scale
    I_gray = double(rgb2gray(I));    
elseif band == 1
    % It's gray scale Image
    I_gray = double(I);
end


% Output the patches around interest points, ignore the boundry ones
for i = 1:length(rId)
    if (rId(i) > marg) && (rId(i) < row-marg)...
            &&(cId(i) > marg) && (cId(i) < col-marg)
        
        img_count=img_count+1;
        % Vectorization patch into n x p data matrix
        img_pat=I_gray(rId(i)-marg:rId(i)+marg,cId(i)-marg:cId(i)+marg);
        img_loc=[rId(i),cId(i)];
        %imshow(img_pat)
        % "img_pat(:)" turns image into 625x1 vector
        img_sub{end+1} = img_pat(:); 
        img_dis{end+1} = img_loc(:);
    end
    
end

img_sub=[img_sub{:}];
img_dis=[img_dis{:}];