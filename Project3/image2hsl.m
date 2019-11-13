function HSL = image2hsl(Image)

[x,y,p] = size(Image);
Image = im2double(Image);

R = Image(:,:,1);
G = Image(:,:,2);
B = Image(:,:,3);

RGB = [R G B];

for i = 1:x
    for j = 1:y
        rgb = [R(i,j),G(i,j),B(i,j)];
        hsl = rgb2hsl(rgb);
        HSL(i,j,1) = hsl(1);
        HSL(i,j,2) = hsl(2);
        HSL(i,j,3) = hsl(3);
    end
end

