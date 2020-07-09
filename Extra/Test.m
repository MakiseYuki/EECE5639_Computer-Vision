clear all; close all;
% 
% image_folder = 'C:\Users\arsen\Documents\GitHub\EECE5639_Computer-Vision\Extra\hotel';
% file_names = dir(fullfile(image_folder,'*.png'));
% total_images = numel(file_names);
% img = cell(1,total_images);
% 
% 
% for k = 1:total_images
%     File = fullfile(image_folder,file_names(k).name);
%     img{k} = imread(File);
% end


videoFileReader = vision.VideoFileReader('frame.avi');
videoPlayer = vision.VideoPlayer('Position',[100,100,680,520]);
objectFrame = videoFileReader();
objectRegion = [320,160,100,100];
objectImage = insertShape(objectFrame,'Rectangle',objectRegion,'Color','red');
figure;
imshow(objectImage);
title('Red box shows object region');

points = detectHarrisFeatures(rgb2gray(objectFrame), 'ROI',objectRegion);
distance = zeros(length(points(:,1)),2);
pointImage = insertMarker(objectFrame,points.Location,'+','Color','white');
figure;
imshow(pointImage);
title('Detected interest points');

tracker = vision.PointTracker('MaxBidirectionalError',1);

initialize(tracker,points.Location,objectFrame);

while ~isDone(videoFileReader)
      temp = points;
      frame = videoFileReader();
      [points,validity] = tracker(frame);
      out = insertMarker(frame,points(validity, :),'+');
      videoPlayer(out);
end

release(videoPlayer);
release(videoFileReader);
