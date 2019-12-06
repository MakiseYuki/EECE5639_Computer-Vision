function patches = extractPatch_v2(ImageA,corners,Size)

[height, width] = size(ImageA);
r = (Size-1)/2;
x = corners(:,1);
y = corners(:,2);
corners_c = length(corners(:,1));

for i = 1:corners_c
    if x > r & x <= width-r & y > r & y < height-r
        patches(:,:,i) = ImageA(x-r:x+r,y-r:y+r);
    end
end

