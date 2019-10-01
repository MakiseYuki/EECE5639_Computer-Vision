close all; clear;

sfilter = 0.5*[-1,0,1];     %Simple filter
gfilter = 0.25*[1,2,1];     %Gaussian filter
temp = zeros(1,3);

% Mac Format; copy from dir directly
image_folder = '/Users/arsen/Documents/EECE5639/Project1/RedChair/';
file_names = dir(fullfile(image_folder,'*.jpg'));
total_images = numel(file_names);

% Read in a sequence of image frames and make them grayscale.
for k = 1:total_images
    F = fullfile(image_folder,file_names(k).name);
    
    I = imread(F);
    I_gray = rgb2gray(I);
    
    %apply 1D filter to the gray image when each read
    %image pixel is 240*320 (verticle, horizontal)
    %the fileter will let the border be the same
    d1Filt_image = I_gray;
    for v = 1:240
        for h = 2:319
            d1Filt_image(v,h) = (I_gray(v,h-1)*(-1)+I_gray(v,h+1)*1)*0.5;
        end
    end
    
    
    
    tsigma = 4.0;
    tsigma = double(tsigma);
    %use gaussian filter
    gassFilt_image = exp(-I_gray^2/(2*tsigma^2))/(tsigma*sqrt(2*pi));
    
    
    
    
    
    %imshow(I_gray)
    %imshow(d1Filt_image)
    %imshow(gaussFilt_image)
     
    
end
