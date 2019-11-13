function [v_map, h_map, disparityMap]=densedisparitymap(I_A, I_B, CA, CB, F)

% Compute a dense disparity map using the Fundamental matrix to help reduce
% the search space. The output should be three images, one image with the
% vertical disparity component, and another image with the horizontal 
% disparity component, and a third image representing the disparity vector
% using color, where the direction of the vector is coded by hue, and the
% length of the vector is coded by saturation. For gray scale display,
% scale the disparity values so the lowest disparity is 0 and the highest
% disparity is 255
% 
% Input as corners info. of image A and B
%   I_A: input image A
%   I_B: input image B
%   CA: Corresponding matrix of points from input image A
%   CA: Corresponding matrix of points from input image B
%   F: 3x3 Fundamental matrix
% Output X and Y locations of highest NCC of A points to B points 
%   v_map: vertical disparity component
%   h_map: horizontal disparity component
%   disp_vector: the disparity vector using color
% 

% Test code for verification
inliers=ones(length(CA),1); %forced to inliers
%load stereoPointPairs
[fLMedS,inliers] = estimateFundamentalMatrix(CA,CB,'Method','RANSAC','NumTrial',4);

%Show the inliers in the first image.
I1 = I_A;
figure; 
subplot(121);
imshow(I1); 
title('Inliers and Epipolar Lines in First Image'); hold on;
plot(CA(inliers,1),CA(inliers,2),'go')

%Compute the epipolar lines in the first image.
epiLines = epipolarLine(fLMedS',CB(inliers,:));

%Compute the intersection points of the lines and the image border.
points = lineToBorderPoints(epiLines,size(I1));

%Show the epipolar lines in the first image
line(points(:,[1,3])',points(:,[2,4])');

%Show the inliers in the second image.
I2 = I_B;
subplot(122); 
imshow(I2);
title('Inliers and Epipolar Lines in Second Image'); hold on;
plot(CB(inliers,1),CB(inliers,2),'go')

%Compute and show the epipolar lines in the second image.
epiLines = epipolarLine(fLMedS,CA(inliers,:));
points = lineToBorderPoints(epiLines,size(I2));
line(points(:,[1,3])',points(:,[2,4])');
truesize;
% Test Code for verification END

% comput epipolar line equation Ax+By+C=0
x=1;
y=1;

fLMedS=int8(fLMedS);
A = x*fLMedS(1,1)+y*fLMedS(1,2)+fLMedS(1,3);
B = x*fLMedS(2,1)+y*fLMedS(2,2)+fLMedS(2,3);
C = x*fLMedS(3,1)+y*fLMedS(3,2)+fLMedS(3,3);

% Since we know the line is horizontal so the range is being 1 to 450
% For Homework 5 propose

grayImageA=double(rgb2gray(I_A));
grayImageB=double(rgb2gray(I_B));

[row,col]=size(grayImageA);

windowSize=3; % odd number
win_mask=zeros(windowSize);
win_mask(ceil(windowSize/2),ceil(windowSize/2))=1;

% padding grayscale images
pad_GA=conv2(grayImageA,win_mask);
pad_GB=conv2(grayImageB,win_mask);

%Normalization Cross Corelation factors
f=zeros(windowSize);
g=zeros(windowSize);
f_hat=zeros(windowSize);
g_hat=zeros(windowSize);

row_map=zeros(row,col);
col_map=zeros(row,col);

test_NCCR=zeros(row,col);

for i=1:row
    for j=1:col 
        
        max_cor=0;
        
        f = pad_GA(i:i+windowSize-1,j:j+windowSize-1);
        f_temp = f.^2;
        f_hat = f./sqrt(sum(f_temp(:)));
            
        for k=1:length(I_A)
            g = pad_GB(i:i+windowSize-1,k:k+windowSize-1);
            g_temp = g.^2;
            g_hat = g./sqrt(sum(g_temp(:)));
            
            % Calculate the NCCR between f and g
        
            NCCR_score=sum(f_hat.*g_hat, 'all' );
            
            test_NCCR(j,k)=NCCR_score; %XXX
            
            %NCC(i,j)=sum(temp(:)); not needed after Matlab 2018b
            if NCCR_score > max_cor
                max_cor = NCCR_score;
                
                row_map(i,j)=i;
                col_map(i,j)=k;
            end
            
        end
        
        
    end
end

% row = horizontal and col = vertical
v_map=zeros(row, col);
h_map=zeros(row, col);
disp_vector=zeros(row, col);

for i=1:row
    for j=1:col
        v_map(i,j)=col_map(i,j)-j;
        h_map(i,j)=row_map(i,j)-i;
        
        if v_map(i,j) < 0
            continue;
            %v_map(i,j) = 0;
        end
        
        if h_map(i,j) < 0
            continue;
        end
    end
end


% Test code for disparity map Start
combImg = stereoAnaglyph(I_A,I_B);
figure
imshow(combImg)
title('Red-Cyan composite view of the rectified stereo pair image')

grayImageA = rgb2gray(I_A);
grayImageB = rgb2gray(I_B);

disparityRange = [0 48];

disparityMap = disparityBM(grayImageA,grayImageB,'DisparityRange',...
    disparityRange,'UniquenessThreshold',20);

figure
imshow(disparityMap,disparityRange)
title('Disparity Map')
colormap jet
colorbar