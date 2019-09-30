clear all;
close all;

h = fspecial('gaussian',3,1.4);
%generate the gaussian filter with 1.4 sigma
rank = rank(h);

sum_en = sum(sum(h));
%note the rank of h and sum of all entires will be 1
[U,S,V] = svd(h);
%apply svd() function to devive for verticle and horizontle direction

h1 = U*sqrt(S);
h2 = sqrt(S)*V';
%use U and V to get each direction of the 1D mask filter

waiveh1 = U(:,1)*sqrt(S(1,1));
waiveh2 = sqrt(S(1,1))*V(:,1);
%waive near 0 coloum and row that the least the the 1D filter



