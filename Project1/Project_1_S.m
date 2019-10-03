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
    
    %apply gaussianFilter before apllying the temporal dervivate
    gaussFilt_image = imgaussfilt(I_gray,2.0);
    gauss_d1Filt_image = gaussFilt_image;
    
    %apply d1 temporal derivate
    for v = 1:height
        for h = 2:width-1
            gauss_d1Filt_image(v,h) = (gaussFilt_image(v,h-1)*(-1)+gaussFilt_image(v,h+1)*1)*0.5;
        end
    end
    
    %apply gauss temporal derivate
    gauss_gaussFilt_image = gaussFilt_image;
    for v = 1:height
        for h = 2:width-1
            gauss_gaussFilt_image(v,h) = (gaussFilt_image(v,h-1)*gaussFilt(1,1))+(gaussFilt_image(v,h)*gaussFilt(1,2))+(gaussFilt_image(v,h+1)*gaussFilt(1,3));
        end
    end
    
    %function for getting the mask
    %create the gradian to store the gradian between images
    
    %when reading the first picture, create the original matrix to calculate
    %the gradian
    if k == 1
        tcd_gradian = three_cross_d1Filt_image;
        fcd_gradian = five_cross_d1Filt_image;
        gd_gradian = gauss_d1Filt_image;
        tcg_gradian = three_cross_gaussFilt_image;
        fcg_gradian = five_cross_gaussFilt_image;
        gg_gradian = gauss_gaussFilt_image;
        
    end
    %after the first image, it is avaiable to get the gradian
    if k > 1
        tcd_gradian = get_gradian(three_cross_d1Filt_image,tcd_temp_image);
        fcd_gradian = get_gradian(five_cross_d1Filt_image,fcd_temp_image);
        gd_gradian = get_gradian(gauss_d1Filt_image,gd_temp_image);
        tcg_gradian = get_gradian(three_cross_gaussFilt_image,tcg_temp_image);
        fcg_gradian = get_gradian(five_cross_gaussFilt_image,fcg_temp_image);
        gg_gradian = get_gradian(gauss_gaussFilt_image,gg_temp_image);
    end
    
    %set the current image as the base to calculate the next gradian
    tcd_temp_image = store(three_cross_d1Filt_image);
    fcd_temp_image = store(five_cross_d1Filt_image);
    gd_temp_image = store(gauss_d1Filt_image);
    tcg_temp_image = store(three_cross_gaussFilt_image);
    fcg_temp_image = store(five_cross_gaussFilt_image);
    gg_temp_image = store(gauss_gaussFilt_image);
    
    %here we have the gradian realize image which could check it is bad or
    %good
    
    
    %imshow(tcd_gradian)
    %imshow(fcd_gradian)
    %imshow(gd_gradian)
    %imshow(tcg_gradian)
    %imshow(fcg_gradian)
    %imshow(gg_gradian)
    %imshow(gaussFilt_image)
    %imshow(gauss_d1Filt_image)
    %imshow(gauss_gaussFilt_image)
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

function temp_image = store(image)
    temp_image = image;
end

function cal_gradian = get_gradian(image,temp_image)
    cal_gradian = abs(image - temp_image);
end
