clc
clear all;
%This is a simple test that project 3 point with an affine trasnform and
 
%then tries to find the transformation:
 
% tform.T and M' should be equal
 
 
%Points are located at:
 
x0=0;
y0=0; 
x1=1;
y1=0; 
x2=0;
y2=1;
 
p1=[x0,y0; x1,y1; x2,y2];
 
%We rotate them (a roll-rotation around Z axes) theta degree, first
 
%building the rotation matrix
 
theta=24;
A11=cosd(theta);
A12=-sind(theta);
A21=sind(theta);
A22=cosd(theta);
%Translation part
 
Tx=1;
Ty=2;
 
tform = affine2d([A11 A12 0; A21 A22 0; Tx Ty 1]);
fprintf('3x3 transformation matrix:')
tform.T
 
[x,y]=transformPointsForward(tform,p1(:,1),p1(:,2));
fprintf('transformed points:')
[x,y]
 
 
xp0=x(1,1);
yp0=y(1,1);
xp1=x(2,1);
yp1=y(2,1);
xp2=x(3,1);
yp2=y(3,1);
 
 
 
%finding the tranformation matrix from set of points and their respective
 
%transformed points:
 
M=affine_least_square(x0,y0, x1,y1, x2,y2, xp0,yp0, xp1,yp1, xp2,yp2);
fprintf('3x3 affine transformation matrix from least_squares:')
M'
 
tform = affine2d(M');
[x,y]=transformPointsForward(tform,p1(:,1),p1(:,2));
[x,y];