function [row,col,thre] = findCornerIndex(Corner_Image,num)

thre = 0;
count = 340*512;

while count > num
  count = size(find(Corner_Image > thre));
  thre = thre + 1;
end

[row,col,thre] = find(Corner_Image > thre);
