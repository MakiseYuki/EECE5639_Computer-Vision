A = imread('DanaHallWay1/DSC_0281.jpg');

A= rgb2gray(A)

[y,x,m] = harris(A,1000,'tile',[2 2],'disp');