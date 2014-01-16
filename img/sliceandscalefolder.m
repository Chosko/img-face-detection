function sliceandscalefolder(inpath, outpath, outstartnumber, divide_by_start, divide_by_end)
% function sliceandscalefolder(path, outpath)
%   Invoca la funzione sliceandscale per ogni file trovato nel path
%   specificato
%   Parametri:
%       - inpath: percorso della cartella da cui leggere i files
%       - outpath: percorso della cartella in cui scrivere i files in input
%       - outstartnumber: Il numero da cui comincia per dare il nome alle

all_files = dir(inpath);
for divide_by = divide_by_start:divide_by_end
    for i = 1:length(all_files)
        if(all_files(i).isdir == 0)
            X = imread(strcat(strcat(inpath, '/'), all_files(i).name));
            l = round(size(X,2) / divide_by);
            outstartnumber = sliceandscale(X, l, l, 24, 24, outpath, outstartnumber);
        end
    end
end