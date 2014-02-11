function Y = detect(windowsize, X, detector, progress, scale, factor)
% function Y = detect(X,detector)
%   This function detects objects into images.
%   Parameters:
%   - windowsize: the size of the window used to learn the classifiers
%   - X: The image to process
%   - detector: The trained cascade of classifier

if nargin < 4
    progress = 0;
end
if nargin < 6
    factor = 1;
end

minscale = 1;
imwidth = size(X,2);
imheight = size(X,1);
maxscale = floor(min(imwidth,imheight)/windowsize);
scalesteps = (maxscale-minscale)/20;
initial_curstep = 4;
detected = [];
det_cnt = 0;
Xsrc = X;

if  nargin >= 5
   minscale = scale;
   maxscale = scale;
end

if size(X,3) == 3
    X = double(rgb2gray(X));
else
    X = double(X);
end
if progress
    fprintf('|');
    for i=minscale:scalesteps:maxscale
        fprintf('-');
    end
    fprintf('|\n|');
end
cnt=0;
for scale = minscale:scalesteps:maxscale
    if progress
        fprintf('.');
    end
    cursize = round(windowsize * scale);
    cursteps = round(initial_curstep * scale);
    curimg = zeros(cursize+1);
    for cury=1:cursteps:imheight-cursize+1
        for curx=1:cursteps:imwidth-cursize+1
            cursrc = X(cury:cury+cursize-1,curx:curx+cursize-1);
            cursrc = normalize_img(cursrc);
            curimg = ii(cursrc);
            cnt = cnt+1;
            if(classifyimg(windowsize,curimg,detector,factor))
                det_cnt = det_cnt + 1;
                detected(det_cnt,:) = [curx cury cursize];
            end
        end
    end
end
fprintf('|\nmarking detected objects...\n');

Y = Xsrc;
for i=1:size(detected,1)
    det = detected(i,:);
    top = det(2);
    left = det(1);
    bottom = top + det(3) - 1;
    right = left + det(3) - 1;
    Y(top, left:right) = 255;
    Y(bottom, left:right) = 255;
    Y(top:bottom, left) = 255;
    Y(top:bottom, right) = 255;
end
end