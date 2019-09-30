

for num = 1:10
    name = "noiseimage_" + num + ".bmp";
    I = imread(name);
    name = "noiseimage_filt_" + num + ".bmp";
    imwrite(imboxfilt(I),name)
end

e_bar = zeros(256,256);
for num = 1:10
    name = "noiseimage_filt_" + num + ".bmp";
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
