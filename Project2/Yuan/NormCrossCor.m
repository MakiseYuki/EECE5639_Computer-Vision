%function [NCC_A,match_map] = NormCrossCor(R_ImageA, R_ImageB, Corners_A, Corners_B)

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

c_threshold = 50;
windowR = 2;

[A_x,A_y] = find(Corners_A > c_threshold);
[B_x,B_y] = find(Corners_B > c_threshold);

f_top = 0; g_top = 0; temp = 0;
for i = 1:length(A_x)
    if A_x(i) > windowR & A_x(i)< row-windowR & A_y(i)>windowR & A_y(i)<col-windowR
        for j = 1:length(B_x)
            if B_x(j) > windowR & B_x(j)< row-windowR & B_y(j)>windowR & B_y(j)<col-windowR
                for s = A_x(i)-windowR:A_x(i)+windowR
                    for t = A_y(i)-windowR:A_y(i)+windowR
                        f_top = f_top + R_ImageA(s,t)^2; 
                    end
                end
                f_top = sqrt(f_top);
                f_top = R_ImageA(A_x(i),A_y(i))/f_top;
                for s = B_x(j)-windowR:B_x(j)+windowR
                    for t = B_y(j)-windowR:B_y(j)+windowR
                        g_top = g_top + R_ImageB(s,t)^2;
                    end
                end
                g_top = sqrt(g_top);
                g_top = R_ImageB(B_x(j),B_y(j))/g_top;
            end
            c = f_top*g_top;
            if c > temp
                temp = f_top*g_top;
            end
            
        end
        NCC(A_x(i),A_y(i)) = temp;
    end
end
NCC_A = NCC;
match_map = NCC;

for i = 1:row
    for j = 1:col
        if match_map(i,j) == 1
            match_map(i,j) = 255;
        end
    end
end



% for s = 1:length(A_x)
%     if A_x(s) > windowR & A_x(s)< row-windowR & A_y(s)>windowR & A_y(s)<col-windowR
%         for i = A_x(s)-windowR:A_x(s)+windowR
%             for j = A_y(s)-windowR:A_y(s)+windowR
%                 f_top = f_top + R_ImageA(i,j)^2;
%                 g_top = g_top + R_ImageB(i,j)^2;
%             end
%         end
%         f_top = sqrt(f_top);
%         g_top = sqrt(g_top);
%         f_top = R_ImageA(A_x(s),A_y(s))/f_top;
%         g_top = R_ImageB(A_x(s),A_y(s))/g_top;
%         NCC(A_x(s),A_y(s)) = f_top*g_top;
%     end
% end
% 
% NCC_A = NCC;
% [f_row,f_col]= find(NCC>0.01);
% f_map = zeros(row,col);
% for i = 1:length(f_row)
%     f_map(f_row(i),f_col(i)) = 255;
% end
% f_mapA = f_map;
% 
% for s = 1: length(B_x)
%     if B_x(s) > windowR & B_x(s)< row-windowR & B_y(s)>windowR & B_y(s)<col-windowR
%     for i = B_x(s)-windowR:B_x(s)+windowR
%         for j = B_y(s)-windowR:B_y(s)+windowR
%             f_top = f_top + R_ImageA(i,j)^2;
%             g_top = g_top + R_ImageB(i,j)^2;
%         end
%     end
%     f_top = sqrt(f_top);
%     g_top = sqrt(g_top);
%     f_top = R_ImageA(B_x(s),B_y(s))/f_top;
%     g_top = R_ImageB(B_x(s),B_y(s))/g_top;
%     NCC(B_x(s),B_y(s)) = f_top*g_top;
%     end
% end
% 
% [f_row,f_col]= find(NCC>0.01);
% NCC_B = NCC;
% f_map = zeros(row,col);
% for i = 1:length(f_row)
%     f_map(f_row(i),f_col(i)) = 255;
% end
% f_mapB = f_map;


