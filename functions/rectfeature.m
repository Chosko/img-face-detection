function rf = rectfeature(I, X, Y)
% function rf = rectfeature(X, points)
%   Calcola il valore della rectangle feature di un'immagine, a partire
%   dall'immagine integrale.
%   Parametri:
%   - I: L'immagine integrale
%   - X: Le x dei punti delle features
%   - Y: Le y dei punti delle features

numX = length(X);
numY = length(Y);
if (numX == 3 && numY == 2)
    % feature "A"
    rf = rectsum(I, Y(1), X(3), Y(2), X(2)+1) - rectsum(I, Y(1), X(2), Y(2), X(1)); 
elseif (numX == 2 && numY == 3)
    % feature "B"
    rf = rectsum(I, Y(1), X(2), Y(2), X(1)) - rectsum(I, Y(2)+1, X(2), Y(3), X(1));
elseif (numX == 4 && numY == 2)
    % feature "C"
    rf = rectsum(I, Y(1), X(3), Y(2), X(2)+1) - rectsum(I, Y(1), X(2), Y(2), X(1)) - rectsum(I, Y(1), X(4), Y(2), X(3)+1);
elseif (numX == 3 && numY == 3)
    % feature "D"
    rf = rectsum(I, Y(1), X(3), Y(2), X(2)+1) + rectsum(I, Y(2)+1, X(2), Y(3), X(1)) - rectsum(I, Y(1), X(2), Y(2), X(1)) - rectsum(I, Y(2)+1, X(3), Y(3), X(2)+1);
else
    numX
    numY
    error('Invalid feature type');
end