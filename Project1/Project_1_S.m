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
    % d1Filt_image is the siple filt operator filt original image without
    % other filer method
    
    %create the gaussian 1D array to apply on image
    gaussFilt_image = I_gray;
    gaussFilt = fspecial('gaussian',[1,3],2.0);
    
    %use gaussian [1,3] array to apply on the original image without other
    %filter method
    for v = 1:240
        for h = 2:319
            gaussFilt_image(v,h) = (I_gray(v,h-1)*gaussFilt(1,1))+(I_gray(v,h)*gaussFilt(1,2))+(I_gray(v,h+1)*gaussFilt(1,3));
        end
    end
    
    %before getting the temporal derivative aplly 3*3 box filter to filt
    %the original image (smoothing)
    three_cross_threeFilt_image = imboxfilt(I_gray,3);
    three_cross_d1Filt_image = three_cross_threeFilt_image;
    three_cross_gaussFilt_image = three_cross_threeFilt_image;
    %than apply the simple filter to the the temporal derivative
    [height,width] = size(three_cross_threeFilt_image);
    for v = 1:height
        for h = 2:width-1
            three_cross_d1Filt_image(v,h) = (three_cross_threeFilt_image(v,h-1)*(-1)+three_cross_threeFilt_image(v,h+1)*1)*0.5;
        end
    end
    
    %same but filter withe the gaussian filter
    for v = 1:height
        for h = 2:width-1
            three_cross_gaussFilt_image(v,h) = (three_cross_threeFilt_image(v,h-1)*gaussFilt(1,1))+(three_cross_threeFilt_image(v,h)*gaussFilt(1,2))+(three_cross_threeFilt_image(v,h+1)*gaussFilt(1,3));
        end
    end
 
    %before getting the temporal derivative aplly 5*5 box filter to filt
    %the original image (smoothing)
    five_cross_fiveFilt_image = imboxfilt(I_gray,5);
    five_cross_d1Filt_image = five_cross_fiveFilt_image;
    five_cross_gaussFilt_image = five_cross_fiveFilt_image;
    [height, width] = size(five_cross_fiveFilt_image);
    for v = 1:height
        for h = 2:width-1
            five_cross_d1Filt_image(v,h) = (five_cross_fiveFilt_image(v,h-1)*(-1)+five_cross_fiveFilt_image(v,h+1)*1)*0.5;
        end
    end
    
    %same but filter withe the gaussian filter
    for v = 1:height
        for h = 2:width-1
            five_cross_gaussFilt_image(v,h) = (five_cross_fiveFilt_image(v,h-1)*gaussFilt(1,1))+(five_cross_fiveFilt_image(v,h)*gaussFilt(1,2))+(five_cross_fiveFilt_image(v,h+1)*gaussFilt(1,3));
        end
    end
    
    %function for getting the mask
    
    
    
    %imshow(five_cross_d1Filt_image)
    %imshow(three_cross_d1Filt_image)
    %imshow(five_cross_gaussFilt_image)
    %imshow(three_cross_gaussFilt_image)
    %imshow(three_cross_threeFilt_image)
    %imshow(five_cross_fiveFilt_image)
    %imshow(I_gray)
    %imshow(d1Filt_image)
    %imshow(gaussFilt_image)
     
    
end
