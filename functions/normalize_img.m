function Y = normalize_img( X )
% This function normalizes the image with mean 0 and variance 1

Y = (X-mean(X(:)))./var(X(:));
end

