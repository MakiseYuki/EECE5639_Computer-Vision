function  SSD = getSSD(Image,Filter)

[row_Filter,col_Filter] = size(Filter);
[row_Image,col_Image] = size(Image);

r = (col_Filter-1)/2;
SSD = zeros(row_Image,col_Image);

for i = 1+r:col_Image-r
    for j = 1+r:row_Image-r
        
        f_out = Image(i-r:i+r,j-r:j+r);
        ssd = sum(sum((Filter-f_out).^2));
        SSD(i,j) = ssd;
        
    end
end


