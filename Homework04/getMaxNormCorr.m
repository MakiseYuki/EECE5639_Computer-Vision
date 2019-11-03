%function maxNormCorr = getMaxNormCorr(Corners,R,rSize)

Filter = getFilter(Corners_A,R_ImageA,2);
num = length(Filter);
[size_x,size_y] = size(Corners_A);
maxNormCorr = zeros(size_x,size_y,num);
for i = 1:num

    maxNormCorr(:,:,i) = getNormCorr(R_ImageB,Filter(:,:,i));

end



