function Y = ii(X)
% Restituisce l'immagine integrale di X.
% Funziona solo con immagini in scala di grigio

X = double(X);
[rows, columns] = size(X);
Xint = zeros(rows+1,columns+1);

for r=2:rows+1
    for c=2:columns+1
        Xint(r,c) = Xint(r-1,c) + Xint(r,c-1) - Xint(r-1,c-1) + X(r-1,c-1);
    end
end

Y = Xint(2:end,2:end);