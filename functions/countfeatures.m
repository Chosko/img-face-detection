function [f2, f3, f4] = countfeatures(size)
% function [fh2, fh3, fv2, fv3, f4] = countfeatures(size)
%   Count the number of features present into a square window of given size
%
%   Parameters:
%       - size: the width (or height) of the square window
%   Output:
%       - f2: two-rectangle features count (valid for both orizontal and
%       vertical)
%       - f3: three-rectangle features count (valid for both orizontal and
%       vertical)
%       - f4: four rectangle features count

f2 = 0;
f3 = 0;
f4 = 0;

%   Legend of cursors
%     ___ ___ ___ _ y1
%    |___|___|___|_ y2
%    |___|___|___|_ y3
%    |___|___|___|_ y4
%    |   |   |   |
%    x1  x2  x3  x4
%
%    The cursors are positioned just before the pixel

% two-rectangle features use x1,x2,x3 and y1,y2 
% (or y1,y2,y3 and x1,x2)
for y1 = 1:size
    for y2 = y1+1:size+1
        for x1 = 1:size-1
            for x2 = x1+1:size
                for x3 = x2+1:size+1
                    f2 = f2+1;
                end
            end
        end
    end
end
    
% three-rectangle features use x1,x2,x3,x4 and y1,y2
% (or y1,y2,y3,y4 and x1,x2)
for y1 = 1:size
    for y2 = y1+1:size+1
        for x1 = 1:size-2
            for x2 = x1+1:size-1
                for x3 = x2+1:size
                    for x4 = x3+1:size + 1
                        f3 = f3+1;
                    end
                end
            end
        end
    end
end

% four rectangle features use x1,x2,x3 and y1,y2,y3
for y1 = 1:size-1
    for y2 = y1+1:size
        for y3 = y2+1:size+1
            for x1 = 1:size-1
                for x2 = x1+1:size
                    for x3 = x2+1:size+1
                        f4 = f4 + 1;
                    end
                end
            end
        end
    end
end