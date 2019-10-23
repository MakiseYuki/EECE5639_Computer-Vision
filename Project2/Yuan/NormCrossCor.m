function [NCC_A,NCC_B] = NormCrossCor(R_ImageA, R_ImageB, Corners_A, Corners_B)

% Given two set of corners from the two images, compute normalized cross 
% correlation (NCC) of image patches centered at each corner. (Note that 
% this will be O(n^2) process.) 
% Choose potential corner matches by finding pair of corners (one from 
% each image) such that they have the highest NCC value. 
% You may also set a threshold to keep only matches that have a large NCC 
% score.
% Input as image I
%   Corners_A: input corner matrix of given image A
%   Corners_B: input corner matrix of given image B
% Output as normalized cross correlation (NCC) of image patches centered
%        at each corner
%   NCC: normalized cross correlation (NCC)
%   bm_x:
%   bm_y:
% 

[row, col] = size(R_ImageA);
NCC = zeros(row,col);
NCC_T = zeros(row,col);

R_ImageA = Corners_A;
R_ImageB = Corners_B;

c_threshold = 0;
windowR = 7;

[A_x,A_y] = find(Corners_A > c_threshold);
[B_x,B_y] = find(Corners_B > c_threshold);

C = zeros(1,length(B_x));

f_top = 0; g_top = 0; index = 0; z = 1; temp = 0; tt = 0;
for i = 1:length(A_x)
    if A_x(i) > windowR & A_x(i)< row-windowR & A_y(i)>windowR & A_y(i)<col-windowR
        
        for s = A_x(i)-windowR:A_x(i)+windowR
            for t = A_y(i)-windowR:A_y(i)+windowR
                f_top = f_top + R_ImageA(s,t)^2; 
            end
        end
        f_top = sqrt(f_top);
        f_top = R_ImageA(A_x(i),A_y(i))/f_top;
        
        for j = 1:length(B_x)
            if B_x(j) > windowR & B_x(j)< row-windowR & B_y(j)>windowR & B_y(j)<col-windowR
                
                for s = B_x(j)-windowR:B_x(j)+windowR
                    for t = B_y(j)-windowR:B_y(j)+windowR
                        g_top = g_top + R_ImageB(s,t)^2;
                    end
                end
                g_top = sqrt(g_top);
                g_top = R_ImageB(B_x(j),B_y(j))/g_top;
            end
            c = f_top*g_top;
            
            C(j) = c;
            g_top = 0;
            
            
            if c > tt
            m_index = j;
            tt = c;
            
            end
            NCC_T(B_x(j),B_y(j)) = tt;
            c = 0;
        end
        index = find(C==max(C));
        
        temp = max(C);
        
    end
    if temp~=0
        
    NCC(A_x(i),A_y(i)) = temp;
   
    
    
    end
    
    C = 0; 
    f_top = 0;
    temp = 0;
      
end
NCC_B = NCC_T;
NCC_A = NCC;
match_map = NCC;

for i = 1:row
    for j = 1:col
        if match_map(i,j) > 0.3
            match_map(i,j) = 255;
        else
            match_map(i,j) = 0;
        end
    end
end




