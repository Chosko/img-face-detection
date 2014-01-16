function Y = ii(X)
% Calculates the upper-left 0-padded integral image of X

X = double(X);
[rows, columns] = size(X);
Xint = zeros(rows+1,columns+1);

for r=2:rows+1
    for c=2:columns+1
        Xint(r,c) = Xint(r-1,c) + Xint(r,c-1) - Xint(r-1,c-1) + X(r-1,c-1);
    end
end

Y = Xint;