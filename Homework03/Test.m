clear all;
close all;
origin(20,20) = 0;
origin = double(origin);

for i = 11:20
    for j = 1:10
        origin(i,j) = 40;
    end
end

for i = 1:10
    for j = 11:20
        origin(i,j) = 40;
    end
end

%apply 3*3 Prewitt
ex(20,20) = 0;
ex = double(ex);
ey(20,20) = 0;
ey = double(ey);

for i = 2:19
    for j = 2:19
        for inner = -1:1
           ex(i,j) = ex(i,j) + (origin(i+inner,j+1)-origin(i+inner,j-1));
        end
    end
end

for i = 2:19
    for j = 2:19
        for inner = -1:1
           ey(i,j) = ey(i,j) + (origin(i+1,j+inner)-origin(i-1,j+inner));
        end
    end
end

for i = 1:20
    for j = 1:20
        C_e_pic(i,j,2,2) = 0;
    end
end

for i = 4:17
    for j = 4:17
       
        C_matrix = [0 0;0 0];
        C_matrix = double(C_matrix);
        
        for ini = -3:3
            for inj = -3:3
                C_matrix(1,1) = C_matrix(1,1) + ex(i+ini,j+inj)^2;
            end
        end
        
        for ini = -3:3
            for inj = -3:3
                C_matrix(2,2) = C_matrix(2,2) + ey(i+ini,j+inj)^2;
            end
        end
        
        for ini = -3:3
            for inj = -3:3
                C_matrix(1,2) = C_matrix(1,2) + ex(i+ini,j+inj)*ey(i+ini,j+inj);
            end
        end
        
        C_matrix(2,1) = C_matrix(1,2);
        C_e_pic(i,j,:,:) = C_matrix;
    end
    
    
end

a = C_e_pic(10,10,:,:);
b = C_e_pic(10,11,:,:);
c = C_e_pic(11,10,:,:);
d = C_e_pic(11,11,:,:);
A = zeros(2,2);
B = zeros(2,2);
C = zeros(2,2);
D = zeros(2,2);
for i = 1:2
    for j = 1:2
        A(i,j) = a(:,:,i,j);
        B(i,j) = a(:,:,i,j);
        C(i,j) = a(:,:,i,j);
        D(i,j) = a(:,:,i,j);
    end
end

eig_a = eig(A);
eig_b = eig(B);
eig_c = eig(C);
eig_d = eig(D);

