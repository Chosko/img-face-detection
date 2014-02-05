function Y = normalize_img( X )
% This function normalizes the image with mean 0 and variance 1

varX = var(X(:));
if varX == 0
    Y = X .* 0;
else
    Y = (X-mean(X(:)))./varX(:);
end
end

