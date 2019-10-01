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

%    imshow(I_gray)
    % save grayscale to str_array.data.
    % The following should be hided AT (b)ii >>
    file_names(k).data = I_gray;
    
    % Try applying 2D spatial smoothing filter
    % The following should be hided before (b)ii >>
    % filters grayscal image with a 2-D, n-by-n box filter
    %>>file_names(k).data = imboxfilt(I_gray, 5); 
    
    % The following should be hided before (b)ii >>
    % filters grayscal image with a Gaussian filter with std deviation
    % ssigma
    %>>file_names(k).data = imgaussfilt(I_gray, 2); 
    %imshow(I_gray)
end

for l=1:total_images
    [m,n]=size(file_names(l).data);
    cop_img=zeros(m,n);
    if (l ~= 1 && l ~= total_images)
        for i=1:m
            for j=1:n
                temp = [file_names(l-1).data(i,j),file_names(l).data(i,j), ...
                    file_names(l+1).data(i,j)];
                % Apply Simple filter
%                cop_img(i,j) = sfilter * double(temp)';
                
                % Apply Gaussian filter with std deviation tsigma
%                cop_img(i,j) = gfilter * double(temp)';
%                test = filter(gausswin(3),1,temp');
            end
        end
    end

    % Apply 1-D differential operator at each pixel compute temporal derivative
    abs_temp_deriv = abs(gradient(cop_img));
    
    % Threshold the absolute values of the derivatives to create a 0 and 1 
    % mask of the moving objects
    BW = (abs_temp_deriv > 2);
    
    % Combine the mask with the original frame to display the results
    comb_img = imread(fullfile(image_folder,file_names(l).name));
    comb_img(BW ~= 0) = BW(BW ~= 0);
    imshow(comb_img);
end
