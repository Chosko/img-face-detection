function foreachfeature(size, func)
% function [fh2, fh3, fv2, fv3, f4] = countfeatures(size)
%   Count the number of features present into a square window of given size
%
%   Parameters:
%       - size: the width (or height) of the square window
%       - func: a function to invoke for each feature. The function must
%       have parameters (X,Y);
%       - extargs: external arguments to pass to the function


%   Legend of cursors
%
%          columns
%  r    _1_ _2_ _3_ _ y0
%  o 1 |___|___|___|_ y1
%  w 2 |___|___|___|_ y2
%  s 3 |___|___|___|_ y3
%      |   |   |   |
%      x0  x1  x2  x3
%
%    The i_th cursor is positioned between the i_th and the i+1_th pixels.

% two-rectangle features use x0,x1,x2 and y0,y1 
% (or y0,y1,y2 and x0,x1 for vertical features)
for y0 = 0:size-1
    for x0 = 0:size-2
        for yscale = 1:size-y0
            for xscale = 1:floor((size-x0)/2)
                y1 = y0 + yscale;
                x1 = x0 + xscale;
                x2 = x1 + xscale;
                
                func([x0,x1,x2], [y0,y1]);
                func([y0,y1], [x0,x1,x2]); % invert X and Y for vertical features.
            end
        end
    end
end

% three-rectangle features use x0,x1,x2,x3 and y0,y1 
% (or y0,y1,y2,y3 and x0,x1 for vertical features)
for y0 = 0:size-1
    for x0 = 0:size-2
        for yscale = 1:size-y0
            for xscale = 1:floor((size-x0)/3)
                y1 = y0 + yscale;
                x1 = x0 + xscale;
                x2 = x1 + xscale;
                x3 = x2 + xscale;
                
                func([x0,x1,x2,x3], [y0,y1]);
                func([y0,y1], [x0,x1,x2,x3]); %invert X and Y for vertical features.
            end
        end
    end
end

% four rectangle features use x1,x2,x3 and y1,y2,y3
for y0 = 0:size-1
    for x0 = 0:size-2
        for yscale = 1:floor((size-y0)/2)
            for xscale = 1:floor((size-x0)/2)
                y1 = y0 + yscale;
                y2 = y1 + yscale;
                x1 = x0 + xscale;
                x2 = x1 + xscale;
                
                func([x0,x1,x2], [y0,y1,y2]);
                % no inversion: four-rectangle features are simmetrical
            end
        end
    end
end
