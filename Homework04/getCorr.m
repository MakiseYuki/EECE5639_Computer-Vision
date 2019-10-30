function Corr = getCorr(Image,Filter)

[row_Filter,col_Filter] = size(Filter);
[row_Image,col_Image] = size(Image);

r = (col_Filter-1)/2;
Corr = zeros(row_Image,col_Image);

for i = 1+r:col_Image-r
    for j = 1+r:row_Image-r
        
        f_out = Image(i-r:i+r,j-r:j+r);
        corr = sum(sum(f_out.*Filter));
        Corr(i,j) = corr;
        
    end
end