function images = imreadall( path, width, height )
%function images = imreadall( path, width, height )
%   Read all the images contained in a specific directory
%   It works only with images of the same resolution
%
%   Parameters:
%       - path: the directory path (ending with '/')
%       - width: the width of the images
%       - height: the height of the images

listing = dir(path);
images = zeros(height,width,length(listing));
count = 0;
for i=1:length(listing)
    if(listing(i).isdir == 0)
        curfile = strcat(path, listing(i).name);
        try
            images(:,:,count+1) = imread(curfile);
            count = count + 1;
        catch err
            if strcmp(err.identifier, 'MATLAB:imagesci:imread:fileFormat')
                warning('Discarded file because of his format: %s', curfile); 
            else
                rethrow(err);
            end
        end
    end
end

if count == 0
    warning('No images were found into %s', path);
    images = 0;
else
    images = images(:,:,1:count);
end
