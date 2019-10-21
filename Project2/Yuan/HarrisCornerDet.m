function [R, Corners_HCD]  = HarrisCornerDet(I)

% Compute Harris R function over the image, and then do non-maimum 
% suppression to get a sparse set of corner features.
% Input as image I
%   I: input image
% Output as Harris R function over image I and sparse set of corner features
%   R: Harris R function over the image I.
%   Corners_HCD: Corners of image I
% 

I_gray = rgb2gray(I);
[row, col] = size(I_gray);

R=zeros(row,col);
M=zeros(2,2);
k=0.05;
highTH=50000;
lowTH=-50000;

Corners_HCD=zeros(row,col);
Edges_HCD=zeros(row,col);
Flats_HCD=zeros(row,col);

% Compute the Image Gradient Gx, Gy
[Gx,Gy] = imgradientxy(I_gray);

% Compute products of derivatives at each pixel
Gxx = Gx.*Gx;
Gyy = Gy.*Gy;
Gxy = Gx.*Gy;

% Compute the sums of the products at each pixel using a window averaging:
Sxx = movmean(Gxx,9);
Syy = movmean(Gyy,9);
Sxy = movmean(Gxy,9);


for i = 1:row
    for j = 1:col
        % Define the Matrix at each pixel M = [Sxx Sxy ; Sxy Syy]
        M = [Sxx(i,j), Sxy(i,j); Sxy(i,j), Syy(i,j)];
        
        % Compute the response R = det(M) - k trace(M)^2
        R(i,j) = det(M) - k*(trace(M)^2);
        
        % Threshold R identify Corner, Edges and Flats.
        if R(i,j)>highTH
            Corners_HCD(i,j) = I_gray(i,j);
        elseif R(i,j)<lowTH
            Edges_HCD(i,j) = I_gray(i,j);
        else
            Flats_HCD(i,j) = I_gray(i,j);
        end
        
    end
end

% Compute Nonmax suppression