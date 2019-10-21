clear all; close all;

A = zeros(3,3);

A = [1 0 0;0 1 0;0 1 0;2 3 5];

ans = sum(sum(A));

[row,col] = size(A);