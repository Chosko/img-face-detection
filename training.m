%--------------------------------------------------------------------------
%   Once the training set has been created, this script trains the
%   classifiers.
%--------------------------------------------------------------------------
function training

    IMSIZE = 24;    % The dimension of each image of the training set.

    %
    % read all the images from the training set
    %
    fprintf('reading positive images from the training set...\n');
    original_positives = imreadall('img\training-set\faces\', IMSIZE, IMSIZE);
    fprintf('positive images read: %d\n', size(original_positives,3));
    fprintf('reading negative images from the training set...\n');
    original_negatives = imreadall('img\training-set\not-faces\', IMSIZE, IMSIZE);
    fprintf('negative images read: %d\n', size(original_positives,3));

    %
    % calculate and store the integral images
    %
    positives = zeros(IMSIZE+1, IMSIZE+1, size(original_positives,3));
    fprintf('calculating the integral images...\n');
    for i=1:size(original_positives,3)
        positives(:,:,i) = ii(original_positives(:,:,i));
    end
    clear original_positives;
    negatives = zeros(IMSIZE+1, IMSIZE+1, size(original_negatives,3));
    for i=1:size(original_negatives,3)
        negatives(:,:,i) = ii(original_negatives(:,:,i));
    end
    clear original_negatives
    fprintf('integral images calculated\n');
    
    %
    % Count the number of features
    %
    fprintf('counting features for a window of %dx%d...\n', IMSIZE, IMSIZE);
    fcnt = 0;
    function fcnt_increment(X,Y)
        fcnt = fcnt + 1;
    end
    foreachfeature(IMSIZE, @fcnt_increment);
    fprintf('counted %d Haar-like features\n', fcnt);
    
    %
    % Prepare the data structures
    %
    fprintf('creating data structures to store the features...\n');
    pos_feats = zeros(fcnt, size(positives,3));
    neg_feats = zeros(fcnt, size(negatives,3));
    fprintf('data structures created\n');
    
    
    %
    % calculate and store all the Haar-like features
    %    ___ ___     __ __ __ 
    %   |   |   |   |  |  |  |
    %   |   |   |   |  |  |  |     ___ ___
    %   |___|___|   |__|__|__|    |   |   |
    %       A            B        |___|___|
    %    _______     ________     |   |   |
    %   |       |   |________|    |___|___|
    %   |-------|   |________|        E
    %   |_______|   |________|
    %       C            D 
    %
    function calculate_pos_feature(X,Y)
        pos_feats(cur_feat, cur_img) = rectfeature(positives(:,:,cur_img),X,Y);
        cur_feat = cur_feat + 1;
        if(mod(cur_feat,10000) == 0)
            fprintf('.');
        end
    end
    function calculate_neg_feature(X,Y)
        neg_feats(cur_feat, cur_img) = rectfeature(negatives(:,:,cur_img),X,Y);
        cur_feat = cur_feat + 1;
        if(mod(cur_feat,10000) == 0)
            fprintf('.');
        end
    end
    
    fprintf('Calculating all the features for the positive images\n');
    tic;
    total = size(positives,3);
    for cur_img=1:length(positives)
        cur_feat = 1;
        fprintf('positive img %d of %d - %0.4f%%: ', cur_img, total, double(cur_img) / total);
        foreachfeature(IMSIZE, @calculate_pos_feature);
        fprintf('\n');
    end
    toc
    
    fprintf('Calculating all the features for the negative images\n');
    tic;
    total = size(negatives,3);
    for cur_img=1:length(negatives)
        cur_feat = 1;
        fprintf('negative img %d of %d - %0.4f%%: ', cur_img, total, double(cur_img) / total);
        foreachfeature(IMSIZE, @calculate_neg_feature);
        fprintf('\n');
    end
    toc
    
    % TODO: Inserire all'interno del processo di calcolo delle features
    % l'algoritmo AdaBoost modificato
end