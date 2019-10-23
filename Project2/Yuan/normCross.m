%function [NCC_A, matches] = normCross(img1,img2,Corners_A)


img1 = rgb2gray(ImageA);
img2 = rgb2gray(ImageB);

windowR = 2;
temp_img = zeros(windowR*2+1,windowR*2+1);
[row, col] = size(img1);
NCC_A = zeros(row,col);

[A_x,A_y] = find(Corners_A>100);
matches = zeros(2,length(A_x));

for i = 1:length(A_x)
    if A_x(i) > windowR & A_x(i)< row-windowR & A_y(i)>windowR & A_y(i)<col-windowR
        for s = A_x(i)-windowR:A_x(i)+windowR
            for t = A_y(i)-windowR:A_y(i)+windowR
                temp_img(s,t) = img1(s,t); 
            end
        end
    end
    C = normxcorr2(temp_img,img2);
    [ypeak,xpeak] = find(C==max(C(:)));
    yoffSet = ypeak-size(temp_img,1);
    xoffSet = xpeak-size(temp_img,2);
    matches(1,i) = yoffSet;
    matches(2,i) = xoffSet;
    NCC_A(A_x(i),A_y(i)) = max(C(:));
   
end