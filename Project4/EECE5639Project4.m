close all; clear; clc;

% for reproducibility, this can be comment out for real training.
rng('default');



k=16;
image_score_list = zeros(1,100);
MEAN_list = zeros(1,100);
for k = 16:16
bagofwords={}; %training
train_displ={}; %train displacement


%% Training
% Given a set of training cropped images prepare a vocabulary and 
% GHT translation vectors:
tic;
image_folder = '/Users/arsen/Documents/GitHub/EECE5639_Computer-Vision/Project4/CarTrainImages/';
file_names = dir(fullfile(image_folder,'*.jpg'));
total_images = numel(file_names);
patches = {};
for i=1:total_images
    ImageA = imread(fullfile(image_folder,file_names(i).name));
    %ImageA_gray = double(rgb2gray(ImageA)); 
    %imshow(ImageA);
    
    % Use detector to collect interesting points in the training images.
    [R_ImageA, Corners_A] = HarrisCornerDet(ImageA);
    %points = detectHarrisFeatures(ImageA,'FilterSize',5);
%     [y,x]= harris(ImageA,500,'tile',[2 2],'disp');
%     points = cornerPoints([x y]);
%     cordinate = uint16(points.Location);
%     cordinate = double(cordinate);
%     [features, val_points] = extractFeatures(ImageA, points);
%     patches{end+1} = extractPatches_v2(ImageA, cordinate, 25);
%     figure; imshow(ImageA); hold on
%     plot(corners)
    %imshow(Corners_A);

    % Apply Canny_Enhancer to the training image;
    %[Es_A, Eo_A] = canny_enhancer(ImageA);
    % Apply non-maimum suppression to get a sparse set of corner features.
    [I_N_A] = nonMax_Supression(Corners_A, R_ImageA);
    %imshow(I_N_A);
    %showInterestPoints(ImageA,I_N_A)
%     I_N_A = zeros(40,100);
%     for j = 1:length(cordinate(:,1))
%         I_N_A(cordinate(j,2),cordinate(j,1)) = 1;
%     end
    % At each interest point, extract a fixed (25 ×25 pixels)size image patch 
    % use the vector of raw pixel intensities as the descriptor.
    [img_descriptors, img_points] = extractPatches(ImageA, I_N_A);
    bagofwords{end+1} = img_descriptors;
    train_displ{end+1} = img_points;

end

% convert bag of word from cell to matrix
bagofwords=[bagofwords{:}];
train_displ=[train_displ{:}];

% Cluster the patches from the training images into clusters using K-means 
% (use kmeans command in Matlab). This step is meant to significantly
% reduce the number of possible visual words. The clusters that you find
% here constitute a visual vocabulary.
[idxOfKmean, C] = kmeans(bagofwords',k,'MaxIter',2000,'Options',statset('UseParallel',1)); % it needs to find the best k value

% Having found the vocabulary "C", to assign each training example of local
% patches to visual words in the vocabulary. An image patch is
% assigned to the visual word which is closest using Euclidean distance (SSD).

% I think this is the "idx"...

% For each visual word occurrence in the training examples, record the
% possible displacement vectors between it and the object center. Assume
% that the object center is the center of the cropped training image.
% Note that a given visual word may have multiple displacement vectors,
% depending on its appearance (for example, the "wheel-like" word in car images.)
disp_mag=zeros(1,length(train_displ));
disp_dir=zeros(1,length(train_displ));

for i=1:length(train_displ)
    disp_mag(i)=norm([20,50]-train_displ(:,i)');
    
    % O1=atan2d((50-45),(20-15)); = 45      => -45
    % O2=atan2d((50-45),(20-25)); = 135     => -135
    % O3=atan2d((50-55),(20-15)); = -45     => 45
    % O4=atan2d((50-55),(20-25)); = -135    => 135
    disp_dir(i)= -atan2d((50-train_displ(2,i)),(20-train_displ(1,i)));
end

% for each k, it has multiple displacement vectors... Is this right...?

% show total time spent on running training
fprintf('Total training time spent: %f\n', toc)
%% Testing
load('/Users/arsen/Documents/GitHub/EECE5639_Computer-Vision/Project4/GroundTruth/CarsGroundTruthBoundingBoxes.mat')

tic;
image_folder = '/Users/arsen/Documents/GitHub/EECE5639_Computer-Vision/Project4/CarTestImages/';
file_names = dir(fullfile(image_folder,'*.jpg'));
total_images = numel(file_names);

% manually change image or run the whole image list
TESTIMAGE = 2;     %this is same as i

for TESTIMAGE=1:100   % to test with single image from CarTestImages
    % Given a novel test image, detect instances of the object
    ImageB = imread(fullfile(image_folder,file_names(TESTIMAGE).name));
    [ib_row,ib_col]=size(ImageB);
    vote_board=zeros(ib_row, ib_col);
    %ImageB_gray = double(rgb2gray(ImageB)); 
    %imshow(ImageB);
    
    % Extract the groundtruth matrix
    [GT_row, GT_col]=size(groundtruth(TESTIMAGE).topLeftLocs);
    if GT_row == 1
        GT=struct2array(groundtruth(TESTIMAGE));
    else
        temp1=ones(GT_row,1)*groundtruth(TESTIMAGE).boxW(1);
        temp2=ones(GT_row,1)*groundtruth(TESTIMAGE).boxH(1);
        GT=horzcat(groundtruth(TESTIMAGE).topLeftLocs, temp1, temp2);
    end
    
     % Run the corner detector to find interesting points.
    [R_ImageB, Corners_B] = HarrisCornerDet(ImageB);
    %points = detectHarrisFeatures(ImageB,'FilterSize',5);
%     [y,x]= harris(ImageA,500,'tile',[2 2],'disp');
%     points = cornerPoints([x y]);
%     cordinate = uint16(points.Location);
%     cordinate = double(cordinate);
%     [features, val_points] = extractFeatures(ImageB, points);
    %imshow(Corners_B);

    % Apply Canny_Enhancer to the testing images;
    %[Es_B, Eo_B] = canny_enhancer(ImageB);
    % Apply non-maimum suppression to get a sparse set of corner features.
    [I_N_B] = nonMax_Supression(Corners_B, R_ImageB);
    %imshow(I_N_B);
%     I_N_B = zeros(40,100);
%     for j = 1:length(cordinate(:,1))
%         I_N_B(cordinate(j,2),cordinate(j,1)) = 200;
%     end
    %showInterestPoints(ImageB,I_N_B)

    % At each interesting point, use a fixed image patch (of the same size
    % as the ones used during training) to create a raw pixel descriptor.
    [test_descriptors, test_points] = extractPatches(ImageB, I_N_B);
    
    % Assign to each patch a visual word.
    [t_row, t_col]=size(test_points);
    for j=1:t_col
        %distances = pdist2(test_descriptors(:,j)', C);
        %[minDistance, indexOfMinDistance] = min(distances);
        [minDist, idxOfMinDist] = min(pdist2(test_descriptors(:,j)', C));
        
        %Let each visual word occurrence vote for the position of the
        % object using the stored displacement vectors.
        for l=1:length(idxOfKmean)
            if idxOfKmean(l) == idxOfMinDist
                % start point: test_points
                % direction: disp_dir
                % magnitude: disp_mag
                vote_row=round(test_points(1,j)+disp_mag(l)*sind(disp_dir(l)));
                vote_col=round(test_points(2,j)+disp_mag(l)*cosd(disp_dir(l)));
                if vote_row>0 && vote_row<=ib_row && vote_col>0 && vote_col<=ib_col
                    vote_board(vote_row,vote_col)=vote_board(vote_row,vote_col)+1;
                end
                
            end
        end
        
    end
    
    % After all votes are cast, analyze the votes in the accumulator array,
    max_vote=max(vote_board(:));
    %imshow(vote_board);
    
    % threshold and predict where the object occurs. 
    %vote_board(find(abs(vote_board)<max_vote)) = 0;    %Not efficient
    vote_board=vote_board.*(vote_board>max_vote-1);    %Better efficiency
    imshow(vote_board);
    [rec_row, rec_col]=find(vote_board);
    
    
    % To predict the fixed size bounding box placement, assume that the
    % object center is the bounding box center. Note that the object of
    % interest may occur multiple times in the test image.
    % choose boxW = 100 boxH = 40; same as groundtruth
    overlap = 0;        % calculate total overlap area
    score = 0;          % calculate total score
    figure(1),
    imshow(ImageB);
    hold on;
    for j=1:length(rec_row)
        rectangle('Position',[rec_col(j)-50 rec_row(j)-20 100 40],...
            'EdgeColor','y','LineWidth',3)
        
        % Compute the accuracy of the predictions. 
        % based on the overlap between the predicted and true bounding boxes.
        % Specifically, a predicted detection is counted as correct if the area of
        % the intersection of the boxes, normalized by the area of their union exceeds 0.5.
        area = rectint([rec_col(j)-50 rec_row(j)-20 100 40],GT);
        
        overlap = overlap + sum(area(:));
        score = overlap/(groundtruth(TESTIMAGE).boxW(1)*groundtruth(TESTIMAGE).boxH(1));
        
    end
    hold off;
    filename = strcat('maxV/maxV_',num2str(TESTIMAGE),'.jpg');
    saveas(figure(1),filename);
    fprintf('Score for Image %i is: %f\n', TESTIMAGE, score)
    image_score_list(TESTIMAGE) = score;
end
MEAN_list(k) = mean(image_score_list);
% show total time spent on running training
fprintf('Total testing time spent: %f\n', toc)
end

