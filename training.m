%--------------------------------------------------------------------------
%   Once the training set has been created, this script trains the
%   classifiers.
%--------------------------------------------------------------------------

clear all;

IMSIZE = 24;    % The dimension of each image of the training set.

%
% read all the images from the training set
%
fprintf('reading positive images from the training set...\n');
positives = imreadall('img\training-set\faces\', IMSIZE, IMSIZE);
fprintf('positive images read: %d\n', size(positives,3));
fprintf('reading negative images from the training set...\n');
negatives = imreadall('img\training-set\not-faces\', IMSIZE, IMSIZE);
fprintf('negative images read: %d\n', size(negatives,3));

%
% calculate and store the integral images
%
fprintf('calculating the integral images...\n');
for i=1:size(positives,3)
    positives(:,:,i) = ii(positives(:,:,i));
end
for i=1:size(negatives,3)
    negatives(:,:,i) = ii(negatives(:,:,i));
end
fprintf('integral images calculated\n');

%
% calculate and store all the Haar-like features
%    ___ ___     __ __ __ 
%   |   |   |   |  |  |  |
%   |   |   |   |  |  |  |     ___ ___
%   |___|___|   |__|__|__|    |   |   |
%    feats_h2    feats_h3     |___|___|
%    _______     ________     |   |   |
%   |       |   |________|    |___|___|
%   |-------|   |________|     feats_4
%   |_______|   |________|
%    feats_v2    feats_v3 
%
fprintf('counting features for a window of %dx%d...\n', IMSIZE, IMSIZE);
[f2_cnt, f3_cnt, f4_cnt] = countfeatures(IMSIZE);
fprintf('counted %d horizontal two-rectangle features\n', f2_cnt);
fprintf('counted %d horizontal three-rectangle features\n', f3_cnt);
fprintf('counted %d vertical two-rectangle features\n', f2_cnt);
fprintf('counted %d vertical three-rectangle features\n', f3_cnt);
fprintf('counted %d vertical four-rectangle features\n', f4_cnt);

% feats_h2
