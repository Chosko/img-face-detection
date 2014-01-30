function Y = detect(windowsize, X, detector)
% function Y = detect(X,detector)
%   This function detects objects into images.
%   Parameters:
%   - windowsize: the size of the window used to learn the classifiers
%   - X: The image to process
%   - detector: The trained cascade of classifier

minscale = 16;
imwidth = size(X,2);
imheight = size(X,1);
maxscale = floor(min(imwidth,imheight)/windowsize);
scalesteps = (maxscale-minscale)/20;
initial_curstep = 4;
detected = [];
det_cnt = 0;
X = rgb2gray(X);
I = ii(X);
I = I(2:end,2:end);
for scale = minscale:scalesteps:maxscale
    cursize = round(windowsize * scale);
    cursteps = round(initial_curstep * scale);
    curimg = zeros(cursize+1);
    for cury=1:cursteps:imheight-cursize+1
        for curx=1:cursteps:imwidth-cursize+1
            curimg(2:end,2:end) = I(cury:cury+cursize-1,curx:curx+cursize-1);
            if(classifyimg(windowsize,curimg,detector))
                det_cnt = det_cnt + 1;
                detected(det_cnt,:) = [curx cury cursize];
            end
        end
    end
end

Y = X;
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