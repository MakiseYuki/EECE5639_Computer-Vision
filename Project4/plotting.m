plot(1:100,MEAN_list_F3,'r'); hold on,
plot(1:100,MEAN_list_F5,'g'); hold on,
plot(1:100,MEAN_list_F7,'b'); hold on,
plot(1:100,MEAN_list_h100,'c'); hold on,
plot(1:100,MEAN_list_h500,'k');
legend('With filter 3','With fileter 5','With filter 7','harris points 100','harris points 500');
title('K value and Score Value');
ylabel('Score Value')
xlabel('K Value')
