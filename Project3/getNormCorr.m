function NormCorr = getNormCorr(Image,Filter)

[row_Filter,col_Filter] = size(Filter);
[row_Image,col_Image] = size(Image);

r = (row_Filter-1)/2;
NormCorr = zeros(row_Image,col_Image);

for i = 1+r:row_Image-r
    for j = 1+r:col_Image-r
        
        f_out = Image(i-r:i+r,j-r:j+r);
        f_sum = sqrt(sum(sum(f_out.^2)));
        f_top = f_out./f_sum;
        g_sum = sqrt(sum(sum(Filter.^2)));
        g_top = Filter./g_sum;
        
        normcorr = f_top.*g_top;
        
        NormCorr(i,j) = sum(sum(normcorr));
        
    end
end
