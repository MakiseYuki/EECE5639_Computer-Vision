function [I_N]  = nonMax_Supression(Es, Eo)

% Compute NONMAX Supression to get a sparse set of input features.
% Input as The inputs are Es and Eo (outputs of CANNY_ENHANCER)
% Consider 4 directions D={ 0,45,90,135} with respect to (wrt) x
%   Es: Estimate edge strength: Es(i,j) = (Jx2(i,j)+ Jy2(i,j))1/2
%   Eo: Estimate edge orientation: Eo(i,j) = arctan(Jx(i,j)/Jy(i,j))
% Output is the thinned edge image I_N
%   I_N: the thinned edge image
% 

% Assume Es and Eo have same size.
[row, col]=size(Es);
marg=9;   % margin, MUST be odd number;
win_mask=zeros(marg); % 1;
win_mask(ceil(marg/2),ceil(marg/2))=1;
%pad_I=conv2(Es,[0,0,0;0,1,0;0,0,0]);
pad_I=conv2(Es,win_mask);
I_N = zeros(row, col);

if marg == 1
% For each pixel (i,j), if {Es(i,j) is smaller than at least one of its 
% neighor along d, then IN(i,j)=0, Otherwise, IN(i,j)= Es(i,j)
    for i = 1:row
        for j = 1:col
            if i-marg<1 && j-marg<1
                % Check UPPER LEFT corner Start
                if  Es(i,j) < Es(i+marg,j)
    %                break;
                elseif Es(i,j) < Es(i,j+marg)
    %                break;
                elseif Es(i,j) < Es(i+marg,j+marg)
    %                break;
                else
                    I_N(i,j) = Es(i,j);
                end
                % Check UPPER LEFT corner End
            elseif i-marg<1 && j+marg>col
                % Check UPPER RIGHT corner Start
                if Es(i,j) < Es(i,j-marg)
    %                break;
                elseif Es(i,j) < Es(i+marg,j-marg)
    %                break;
                elseif Es(i,j) < Es(i+marg,j)
    %                break;
                else
                    I_N(i,j) = Es(i,j);
                end
                % Check UPPER RIGHT corner End
            elseif i+marg>row && j-marg<1
                % Check LOWER LEFT corner Start
                if Es(i,j) < Es(i-marg,j)
    %                break;
                elseif Es(i,j) < Es(i-marg,j+marg)
    %                break;
                elseif Es(i,j) < Es(i,j+marg)
    %                break;
                else
                    I_N(i,j) = Es(i,j);
                end
                % Check LOWER LEFT corner End
            elseif i+marg>row && j+marg>col
                % Check LOWER RIGHT corner Start
                if Es(i,j) < Es(i-marg,j-marg)
    %                break;
                elseif Es(i,j) < Es(i,j-marg)
    %                break;
                elseif Es(i,j) < Es(i-marg,j)
    %                break;
                else
                    I_N(i,j) = Es(i,j);
                end
                % Check LOWER RIGHT corner End
            elseif i-marg<1
                % Check UPPER side Start
                if Es(i,j) < Es(i,j-marg)
    %                break;
                elseif Es(i,j) < Es(i+marg,j-marg)
    %                break;
                elseif Es(i,j) < Es(i+marg,j)
    %                break;
                elseif Es(i,j) < Es(i,j+marg)
    %                break;
                elseif Es(i,j) < Es(i+marg,j+marg)
    %                break;
                else
                    I_N(i,j) = Es(i,j);
                end
                % Check UPPER side End
            elseif j-marg<1
                % Check LEFT side Start
                if Es(i,j) < Es(i-marg,j)
    %                break;
                elseif Es(i,j) < Es(i+1,j)
    %                break;
                elseif Es(i,j) < Es(i-marg,j+marg)
    %                break;
                elseif Es(i,j) < Es(i,j+marg)
    %                break;
                elseif Es(i,j) < Es(i+marg,j+marg)
    %                break;
                else
                    I_N(i,j) = Es(i,j);
                end
                % Check LEFT side End
            elseif j+marg>col
                % Check RIGHT side Start
                if Es(i,j) < Es(i-marg,j-marg)
    %                break;
                elseif Es(i,j) < Es(i,j-marg)
    %                break;
                elseif Es(i,j) < Es(i+marg,j-marg)
    %                break;
                elseif Es(i,j) < Es(i-marg,j)
    %                break;
                elseif Es(i,j) < Es(i+marg,j)
    %                break;
                else
                    I_N(i,j) = Es(i,j);
                end
                % Check RIGHT side End
            elseif i+marg>row
                % Check BOTTOM side Start
                if Es(i,j) < Es(i-marg,j-marg)
    %                break;
                elseif Es(i,j) < Es(i,j-marg)
    %                break;
                elseif Es(i,j) < Es(i-marg,j)
    %                break;
                elseif Es(i,j) < Es(i-marg,j+marg)
    %                break;
                elseif Es(i,j) < Es(i,j+marg)
    %                break;
                else
                    I_N(i,j) = Es(i,j);
                end
                % Check BOTTOM side End
            else
                % Check every directions Start
                if Es(i,j) < Es(i-marg,j-marg)
    %                break;
                elseif Es(i,j) < Es(i,j-marg)
    %                break;
                elseif Es(i,j) < Es(i+marg,j-marg)
    %                break;
                elseif Es(i,j) < Es(i-marg,j)
    %                break;
                elseif Es(i,j) < Es(i+marg,j)
    %                break;
                elseif Es(i,j) < Es(i-marg,j+marg)
    %                break;
                elseif Es(i,j) < Es(i,j+marg)
    %                break;
                elseif Es(i,j) < Es(i+marg,j+marg)
    %                break;
                else
                    I_N(i,j) = Es(i,j);
                end
                % Check every directions End
            end
        end
    end

elseif mod(marg,2)==1
    for i=1:row
        for j=1:col
            win_mask=pad_I(i:i+marg-1, j:j+marg-1);     %reuse for temp
            win_mask(ceil(marg/2),ceil(marg/2))=0;      %zero middle cell
            if Es(i,j) > max(win_mask,[],'all')         %find only the max
                I_N(i,j)=Es(i,j);
            end
            
        end
    end
    
else
    disp('error, marg shoud be an odd number.');
end
test=1;
