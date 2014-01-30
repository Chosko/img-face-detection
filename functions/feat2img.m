function img = feat2img( feat_size, weak_classifier, window )
% function showfeat( weak_classifier )
%   Show an image with the feature

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

X = weak_classifier.X;
Y = weak_classifier.Y;
if nargin < 3
    img = uint8(ones(feat_size) .* 128);
else
    img = uint8(window);
    scale = size(window,1) / feat_size;
    X = round(X .* scale);
    Y = round(Y .* scale);
end

numX = length(X);
numY = length(Y);
if (numX == 3 && numY == 2)
    % A feature
    img(Y(1)+1:Y(2),X(1)+1:X(2)) = 255;
    img(Y(1)+1:Y(2),X(2)+1:X(3)) = 0;
elseif (numX == 4 && numY == 2)
    % B feature
    img(Y(1)+1:Y(2),X(1)+1:X(2)) = 0;
    img(Y(1)+1:Y(2),X(2)+1:X(3)) = 255;
    img(Y(1)+1:Y(2),X(3)+1:X(4)) = 0;
elseif (numX == 2 && numY == 3)
    % C feature
    img(Y(1)+1:Y(2),X(1)+1:X(2)) = 255;
    img(Y(2)+1:Y(3),X(1)+1:X(2)) = 0;
elseif (numX == 2 && numY == 4)
    % D feature
    img(Y(1)+1:Y(2),X(1)+1:X(2)) = 0;
    img(Y(2)+1:Y(3),X(1)+1:X(2)) = 255;
    img(Y(3)+1:Y(4),X(1)+1:X(2)) = 0;
elseif (numX == 3 && numY == 3)
    % E feature
    img(Y(1)+1:Y(2),X(1)+1:X(2)) = 0;
    img(Y(1)+1:Y(2),X(2)+1:X(3)) = 255;
    img(Y(2)+1:Y(3),X(1)+1:X(2)) = 255;
    img(Y(2)+1:Y(3),X(2)+1:X(3)) = 0;
else
    numX
    numY
    error('Invalid feature type');
end

end