%
%   This script trains a cascade of classifiers
%   It uses the files created by compute_features
%

% Carica le costanti
config_training

% Carica le variabili
varfile = sprintf('%svars.mat', FEAT_PATH);
if exist(sprintf('%svars.mat', FEAT_PATH), 'file')
    load(varfile);
    clear varfile;
else
    error('The features were not fully computed. Run compute_features before');
end

fprintf('*** Training started ***\n');
fprintf('This will take a lot of time!! Keep calm and be Buren!\n');

fprintf('Initializing data structures...\n');
% Variabili che servono per costruire nuovi classifiers
new_weak_classifier = struct('X',zeros(1,4), 'Y', zeros(1,4), 'polarity', 0, 'threshold', 0, 'alpha', 0, 'confirmed', 0, 'values', zeros(1,tot_samples));
new_strong_classifier = struct('weak_classifiers', new_weak_classifier, 'threshold', 0, 'confirmed', 0);
new_strong_classifier.weak_classifiers(1:MAX_WEAK_CNT) = new_weak_classifier;

% Weak classifiers correnti e strong_classifiers della cascata
current_weak_classifiers(1, MAX_WEAK_CNT) = new_weak_classifier;
current_strong_classifiers(1:MAX_STRONG_CNT) = new_strong_classifier;

% Vettore per calcolare l'accuratezza dell'algoritmo
accuracy = zeros(4, MAX_STRONG_CNT);

% Vettore di boolean che determina se un esempio è stato contrassegnato
% come positivo
positives = ones(1, tot_samples);

% I valori delle features del gruppo corrente
current_feats = zeros(FEAT_PER_GROUP, tot_samples);

% Variabili di ciclo
strong_cnt = 0;
false_pos = inf;
false_neg = inf;

% Aggiunge stages finchè non si ottiene il 100% di accuratezza (il ciclo
% viene interrotto dall'interno quando si raggiunge il massimo numero di
% livelli)
while false_pos + false_neg > 0
    strong_cnt = strong_cnt + 1;
    if strong_cnt > MAX_STRONG_CNT
        break;
    end
    
    % Variabili di ciclo
    tmp_pos = sum(positives(1:tot_pos));                % n. di samples positivi rimasti da elaborare
    tmp_neg = sum(positives(tot_pos+1:tot_samples));    % n. di samples negativi rimasti da elaborare
    
    % Inizializza i pesi
    weights = [ones(1,tot_pos) / (2*tmp_pos), ones(1,2*tot_neg) / (2*tmp_neg) ];
    
end