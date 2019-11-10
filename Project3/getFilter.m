function [Filter,corr] = getFilter(Corners,R,rSize)

[x_size,y_size] = size(Corners);

[x,y] = find(Corners>220);
% corrs(:,1) = x;
% corrs(:,2) = y;
num = length(x);
j = 1;
for i = 1:num
    
    if x(i)-rSize > 0 & x(i)+rSize < x_size & y(i)-rSize > 0 & y(i)+rSize < y_size
        corr(j,1) = x(i);
        corr(j,2) = y(i);
        Filter(:,:,j) = R(x(i)-rSize:x(i)+rSize,y(i)-rSize:y(i)+rSize);
        j = j+1;

    end

end
