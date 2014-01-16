function rf = rectfeature(I, X, Y)
% function rf = rectfeature(X, points)
%   Computes the value of a Haar-like rectangle feature of an image, given
%   its integral image
%   Parameters:
%   - I: The upper-left-0-padded integral image
%   - X: The x of the points of the features
%   - Y: The y of the points of the features
%
% Types of Haar-like rectangle features accepted from this function
%    ___ ___     __ __ __ 
%   |   |   |   |  |  |  |
%   | + | - |   | -| +| -|     ___ ___
%   |___|___|   |__|__|__|    | - | + |
%       A            B        |___|___|
%    _______     ________     | + | - |
%   |   +   |   |___-____|    |___|___|
%   |-------|   |___+____|        E
%   |___-___|   |___-____|
%       C            D 
%
numX = length(X);
numY = length(Y);
if (numX == 3 && numY == 2)
    % A feature
    rf = rectsum(I, Y(1), X(2), Y(2), X(1)) - rectsum(I, Y(1), X(3), Y(2), X(2));
elseif (numX == 4 && numY == 2)
    % B feature
    rf = rectsum(I, Y(1), X(3), Y(2), X(2)) - rectsum(I, Y(1), X(2), Y(2), X(1)) - rectsum(I, Y(1), X(4), Y(2), X(3));
elseif (numX == 2 && numY == 3)
    % C feature
    rf = rectsum(I, Y(1), X(2), Y(2), X(1)) - rectsum(I, Y(2), X(2), Y(3), X(1));
elseif (numX == 2 && numY == 4)
    % D feature
    rf = rectsum(I, Y(2), X(2), Y(3), X(1)) - rectsum(I, Y(1), X(2), Y(2), X(1)) - rectsum(I, Y(3), X(2), Y(4), X(1));
elseif (numX == 3 && numY == 3)
    % E feature
    rf = rectsum(I, Y(1), X(3), Y(2), X(2)) + rectsum(I, Y(2), X(2), Y(3), X(1)) - rectsum(I, Y(1), X(2), Y(2), X(1)) - rectsum(I, Y(2), X(3), Y(3), X(2));
else
    numX
    numY
    error('Invalid feature type');
end