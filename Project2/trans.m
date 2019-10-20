x=[];
for i =1:6
    x=[x;tforms(i).T(3,1:2)];
end
scatter(x(:,1),x(:,2))