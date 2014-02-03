function images = imreadall( path, width, height, progress, preprocess )
%function images = imreadall( path, width, height )
%   Read all the images contained in a specific directory
%   It works only with images of the same resolution
%
%   Parameters:
%       - path: the directory path (ending with '/')
%       - width: the width of the images
%       - height: the height of the images
%       - progress (optional): prints a progress bar
%       - preprocess (optional): process the image to make the training and the
%                       detection easier

if nargin < 4
    progress = 0;
end
if nargin < 5
    preprocess = 0;
end

if progress
    fprintf('|--------------------|\n|');
end
listing = dir(path);
images = zeros(height,width,length(listing));
count = 0;
discarded = [];
disc_cnt = 0;
for i=1:length(listing)
    if(listing(i).isdir == 0)
        curfile = strcat(path, listing(i).name);
        try
            X = double(imread(curfile));
            if preprocess
                X = normalize_img(X);
            end
            images(:,:,count+1) = X;
            count = count + 1;
        catch err
            if strcmp(err.identifier, 'MATLAB:imagesci:imread:fileFormat')
                disc_cnt = disc_cnt + 1;
                discarded(disc_cnt) = i; 
            else
                rethrow(err);
            end
        end
    end
    if progress && mod(i, ceil(length(listing)/20)) == 1
        fprintf('.');
    end
end
if progress
    fprintf('|\n');
end

if disc_cnt > 0
    warn_str = sprintf('\n  %s',strcat(path, listing(discarded).name));
    warning('Discarded file(s) because of his format:%s', warn_str);
end
if count == 0
    error('No images were found into %s', path);
    images = 0;
else
    images = images(:,:,1:count);
end
