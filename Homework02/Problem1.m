clear all;
close all;

mask = zeros(256,256);

    for k = 1:256
        for i = 1:256
            mask(i,k) = randperm(128,1);
        end
    end
    
    imwrite(uint8(mask),'originimage.bmp');
        
for num = 1:10  
        I = imread('originimage.bmp');
        J = imnoise(I,'gaussian',0,4.0);
        name = "noiseimage_" + num + ".bmp";
        imwrite(J,name)  
end

e_bar = zeros(256,256);

for num = 1:10
    name = "noiseimage_" + num + ".bmp";
    rmask = imread(name);
    
    for i = 1:256
        for k = 1:256
            e_bar(i,k) = e_bar(i,k) + rmask(i,k)/10;            
        end
    end
end

%now we have the Estimate bar in 256*256

e_sigma = zeros(256,256);

name = "originimage.bmp";
rmask = imread(name);
    
for i = 1:256
    for k = 1:256
        e_sigma(i,k) = e_sigma(i,k) + ((e_bar(i,k) - rmask(i,k))^2)/9;
    end
end

for i = 1:256
    for k = 1:256
        e_sigma(i,k) = e_sigma(i,k)^(0.5);
    end
end

sum_sigma = sum(e_sigma);
avg_sigma = sum(sum_sigma)/(256*256);




    



