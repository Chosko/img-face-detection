function s = rectsum(I, top, right, bottom, left)
% function s = rectsum(I, X, Y)
%   Calculates the sum of all the pixels into a given rectangle
%   
%   Parameters:
%   - I: The upper-left 0-padded integral image
%   - top: The upper bound of the rectangle
%   - right: The right bound of the rectangle
%   - bottom: The bottom bound of the rectangle
%   - left: The left bound of the rectangle

%    ____________________
%   |                    |
%   |    A______B        |
%   |    |      |        |
%   |    |______|        |
%   |    C      D        |
%   |____________________|

bottom = bottom + 1;
right = right + 1;
top = top + 1;
left = left + 1;
s = I(bottom, right) - I(top, right) - I(bottom, left) + I(top, left);