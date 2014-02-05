%
% This script computes all the Haar-like features for the training
% set.
% To configure the constants, please modify config_training.m
%
    
% Carica le costanti
config_training

fprintf('*** Computing Haar-like features for given training set ***\n');

% Carica gli esempi positivi
fprintf('Loading positive samples...\n');
positives_src = imreadall(POSITIVES_PATH, IMSIZE, IMSIZE, 1, 1);
tot_pos = size(positives_src,3);
fprintf('Loaded %d positive samples\n', tot_pos);

% Carica gli esempi negativi
fprintf('Loading negative samples...\n');
negatives_src = imreadall(NEGATIVES_PATH, IMSIZE, IMSIZE, 1, 1);
tot_neg = size(negatives_src,3);
fprintf('Loaded %d negative samples\n', tot_neg);

tot_samples = tot_pos + tot_neg;

% Calcola le immagini integrali
fprintf('Calculating integral images...\n');
integral_images = zeros(IMSIZE + 1, IMSIZE + 1, tot_samples);
for i = 1:tot_pos
    integral_images(:,:,i) = ii(positives_src(:,:,i));
end

for i = tot_pos+1:tot_samples
    integral_images(:,:,i) = ii(negatives_src(:,:,i-tot_pos));
end
fprintf('Calculated all the integral images\n');

% Conta il numero di Haar-like features per ogni immagine.
fprintf('Counting number of features for each image...\n');
tot_features = count_features(IMSIZE);
fprintf('Counted %d features\n', tot_features);

% Calcola tutte le features per ogni immagine
fprintf('Calculating features...\n|');
for i = 1:ceil(tot_features/FEAT_PER_GROUP)
    fprintf('-');
end
fprintf('|\n|');
[tot_groups,skipped] = calculate_all_features(integral_images, FEAT_PER_GROUP, FEAT_PATH, FEAT_FILE_PREFIX); 
fprintf('|\nGroups calculated: %d (Skipped: %d)\n', tot_groups, skipped);
if skipped > 0
   warning('Some features were skipped because they already exists. If you want to overwrite them, run ''clear_features'' before');
end

% Salva su file le variabili necessarie per il training
save(sprintf('%svars.mat', FEAT_PATH), 'tot_pos', 'tot_neg', 'tot_samples', 'tot_groups', 'tot_features');

% Pulisce la memoria, lasciando solo le costanti
clear -regexp [a-z]*