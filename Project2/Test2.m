
pts1 = matchedPoints.Location';
pts2 = matchedPointsPrev.Location';

[H, CorrP] = findHomography(pts1,pts2);



figure(1),
plot(pts1(1,:),pts1(2,:),'r+'); hold on
plot(pts2(1,:),pts2(2,:),'g+'); hold on

plot(pts2(1,CorrP),pts2(2,CorrP),'bo')

