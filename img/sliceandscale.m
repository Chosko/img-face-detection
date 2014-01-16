function nextoutnumber =  sliceandscale(X, inwidth, inheight, outwidth, outheight, outfolder, outstartnumber)
% function nextoutnumber =  sliceandscale(X, inwidth, inheight, outwidth, outheight, outfolder, outstartnumber)
%   Divide un'immagine in tante sottoimmagini, scalandole ad una data
%   dimensione e trasformandole in scala di grigio.
%   Parametri:
%   - X: L'immagine originale
%   - inwidth: La larghezza di una singola sottoimmagine, calcolata
%   sull'immagine in input
%   - inheight: L'altezza di una singola sottoimmagine, calcolata
%   sull'immagine in input
%   - outwidth: La larghezza che assumerà una singola sottoimmagine in
%   output
%   - outheight: L'altezza che assumerà una singola sottoimmagine in output
%   - outstartnumber: Il numero da cui comincia per dare il nome alle
%   immagini in output sul disco.
%   Output:
%   - nextoutnumber: il prossimo numero da cui partire se si vuole
%   continuare l'operazione con un'altra immagine


% trasforma l'immagine in scala di grigio, se necessario
if(size(X,3) > 1)
    X = rgb2gray(X);
end

if nargin < 7
    outstartnumber = 1;
end 

[H,W] = size(X);
left = 1;
top = 1;
current = zeros(inheight, inwidth);
i=outstartnumber;

while(top < H)
    bottom = min(top + inheight, H);
    while(left < W)
        right = min(left + inwidth, W);
        current = X(top+2:bottom-2, left+2:right-2);
        if size(current, 1) ~= 0 && size(current,2) ~= 0
            current = imresize(current, [outheight, outwidth]);
            imwrite(current, strcat(outfolder,'/',int2str(i),'.png'));
        end
        left = left + inwidth;
        i = i+1;
    end
    left = 0;
    top = top + inheight;
end
nextoutnumber = i;