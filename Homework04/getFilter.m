function Filter = getFilter(Corners,R,rSize)

[x_size,y_size] = size(Corners);

[x,y] = find(Corners~=0);
num = length(x);

for i = 1:num
    
    if x(i)-rSize > 0 & x(i)+rSize < x_size & y(i)-rSize > 0 & y(i)+rSize < y_size

        Filter(:,:,i) = R(x(i)-rSize:x(i)+rSize,y(i)-rSize:y(i)+rSize);

    end

end
