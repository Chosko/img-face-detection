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

% gli strong_classifiers della cascata e i weak classifiers di ogni stage
current_strong_classifiers(1:MAX_STRONG_CNT) = new_strong_classifier;
current_weak_classifiers(1, MAX_WEAK_CNT) = new_weak_classifier;

% Vettore di boolean che determina se un esempio è stato contrassegnato
% come positivo
positives = ones(1, tot_samples);

% Variabili di ciclo
strong_cnt = 0;         % n. dello stage corrente
false_pos = inf;        % n. di falsi positivi
false_neg = inf;        % n. di falsi negativi

% Aggiunge stages finchè non si ottiene il 100% di accuratezza (il ciclo
% viene interrotto dall'interno quando si raggiunge il massimo numero di
% livelli)
while false_pos + false_neg > 0
    % Incrementa il numero di stage
    strong_cnt = strong_cnt + 1;
    if strong_cnt > MAX_STRONG_CNT
        break;
    end
    
    % Variabili di ciclo
    tmp_pos = sum(positives(1:tot_pos));                                % n. di samples positivi rimasti da elaborare
    tmp_neg = sum(positives(tot_pos+1:tot_samples));                    % n. di samples negativi rimasti da elaborare
    weak_cnt = 0;                                                       % n. del weak_classifier corrente
    neg_pruned = 0;                                                     % n. di samples negativi potati dallo strong classifier corrente
    current_weak_classifiers(1, MAX_WEAK_CNT) = new_weak_classifier;    % i weak classifiers dello stage corrente
    
    % Inizializza i pesi
    weights = [ones(1,tot_pos) / (2*tmp_pos), ones(1,tot_neg) / (2*tmp_neg) ];
    
    fprintf('\n\n=== Computing cascade stage n. %d ===\n', strong_cnt);
    
    % Aggiunge weak classifiers allo stage corrente finchè non sono stati
    % potati almeno il 50% di samples negativi
    while neg_pruned < tmp_neg / 2
        % Incrementa il numero di weak classifier
        weak_cnt = weak_cnt + 1;
        if weak_cnt > MAX_WEAK_CNT
            break;
        end
        
        fprintf('\n--- Computing weak classifier n. %d of stage %d ---\n', weak_cnt, strong_cnt);
        
        % Normalizza i pesi
        weights = weights / sum(positives .* weights);
        
        % Cerca il miglior weak classifier
        e = inf;                                                                        % L'errore apportato dal weak classifier in esame
        TPos = sum(positives(1:tot_pos) .* weights(1:tot_pos));                         % La somma dei pesi dei samples positivi
        TNeg = sum(positives(tot_pos+1:tot_samples) .* weights(tot_pos+1:tot_samples)); % La somma dei pesi dei samples negativi
        feat_cnt = 0;                                                                   % Il numero della feature corrente
        
        % Stampa una progress bar molto rudimentale
        fprintf('|');
        for i = 1:tot_groups
            fprintf('-');
        end
        fprintf('|\n|');
        
        % Scorre tutti i gruppi di features
        for i = 1:tot_groups
            filename = sprintf('%s%s_%d.mat', FEAT_PATH, FEAT_FILE_PREFIX, i);
            load(filename, 'group');
            fprintf('.');
            
            current_group_length = size(group,1);
            [sorted_group, indices] = sort(group,2);
            
            % Per ogni feature del gruppo, trova il threshold che minimizza l'errore
            for j = 1:current_group_length
                % Incrementa il numero della feature corrente
                feat_cnt = feat_cnt + 1;
                
                SPos = 0;   % La somma dei pesi dei samples positivi calcolati finora
                SNeg = 0;   % La somma dei pesi dei samples negativi calcolati finora
                
                % Calcola la feature per ogni immagine
                for k = 1:tot_samples
                    % Esegue solo per le immagini ancora non escluse dagli step precedenti
                    if positives(indices(j,k))
                        
                        % Calcola questa formula:
                        %
                        % e = min(S+ + (T- - S-), S- + (T+ - S+))
                        %         |____________|  |____________|
                        %                |               |
                        %               p=-1            p=1
                        
                        % Calcolo parziale errore
                        e1 = SPos + (TNeg - SNeg);
                        e2 = SNeg + (TPos - SPos);
                        
                        % Trovo p e memorizzo l'errore
                        if e2 < e1
                            tmp_e = e2;
                            tmp_p = 1;
                        else
                            tmp_e = e1;
                            tmp_p = -1;
                        end
                        
                        % Se l'errore è minore di e, vuol dire che ho
                        % trovato una feature migliore. Me la salvo e
                        % aggiorno e.
                        if tmp_e < e
                            e = tmp_e;
                            tmp_feat_cnt = feat_cnt; %  memorizza l'indice di feature corrente che servirà dopo
                            current_weak_classifiers(weak_cnt).polarity = tmp_p;
                            current_weak_classifiers(weak_cnt).threshold = sorted_group(j,k);
                            current_weak_classifiers(weak_cnt).values = group(j, :);
                        end
                        
                        % Aggiorno SPos o SNeg
                        if indices(j,k) > tot_pos
                            SNeg = SNeg + weights(indices(j,k));
                        else
                            SPos = SPos + weights(indices(j,k));
                        end
                    end
                end  
            end
        end
        fprintf('|\n');
        
        % Calcola la feature corrente e se ne salva le coordinate
        [X, Y] = get_weak_classifier(IMSIZE, tmp_feat_cnt);
        current_weak_classifiers(weak_cnt).X = X;
        current_weak_classifiers(weak_cnt).Y = Y;
        
        % Stampa una visualizzazione del weak classifier selezionato
        fprintf('Weak classifier selected:\n');
        print_weak_classifier(IMSIZE, current_weak_classifiers(weak_cnt));
        
        fprintf('Updating weights...\n');
        
        % beta è un numero che serve per aggiornare i pesi
        beta = e / (1-e);
        cur = current_weak_classifiers(weak_cnt);
        
        % Aggiorno i pesi per i samples positivi
        for i = 1:tot_pos
            % Esegue solo per i samples che non sono ancora stati scartati
            if positives(i)
                if cur.polarity * cur.values(i) < cur.polarity * cur.threshold
                    weights(i) = weights(i) * beta;
                end
            end
        end
        
        % Aggiorno i pesi per i samples negativi
        for i = tot_pos+1:tot_samples
            % Esegue solo per i samples che non sono ancora stati scartati
            if positives(i)
                if cur.polarity * cur.values(i) >= cur.polarity * cur.threshold
                    weights(i) = weights(i) * beta;
                end
            end
        end
        
        fprintf('Finalizing the weak classifier...\n');
        % Imposta alpha sul weak_classifier (serve poi per calcolare lo strong classifier
        current_weak_classifiers(weak_cnt).alpha = log(1/beta);
        
        % Imposta il weak classifier come 'definitivo' e lo salva nello strong classifier corrente
        current_weak_classifiers(weak_cnt).confirmed = 1;
        current_strong_classifiers(strong_cnt).weak_classifiers(weak_cnt) = current_weak_classifiers(weak_cnt);
        
        fprintf('Updating the strong classifier...\n');
        % Imposta il threshold dello strong classifier corrente
        current_strong_classifiers(strong_cnt).threshold = inf;
        for i = 1:tot_pos
            if positives(i)
                HS = 0;
                for j = 1:weak_cnt
                    if weak_classify(current_weak_classifiers(j), i)
                        HS = HS + current_weak_classifiers(j).alpha;
                    end
                end
                if HS < current_strong_classifiers(strong_cnt).threshold
                   current_strong_classifiers(strong_cnt).threshold = HS;
                end
            end
        end
        
        fprintf('Testing the strong classifier against the negative samples...\n');
        % Testa lo strong classifier sui samples negativi
        neg_pruned = 0;
        for i = tot_pos + 1 : tot_samples
            if positives(i)
                HS = 0;
                for j = 1:weak_cnt
                    if weak_classify(current_weak_classifiers(j), i)
                        HS = HS + current_weak_classifiers(j).alpha;
                    end
                end
                if HS < current_strong_classifiers(strong_cnt).threshold
                    neg_pruned = neg_pruned + 1;
                end
            end
        end
        fprintf('Negative examples pruned: %s\n', printpercent(neg_pruned, tmp_neg));
    end
    
    fprintf('Finalizing the strong classifier...\n');
    % Toglie i weak classifiers rimasti inutilizzati
    cnt = 0;
    for i = 1:length(current_strong_classifiers(strong_cnt).weak_classifiers)
        if current_strong_classifiers(strong_cnt).weak_classifiers(i).confirmed
            cnt = cnt + 1;
        else
            break;
        end
    end
    current_strong_classifiers(strong_cnt).weak_classifiers = current_strong_classifiers(strong_cnt).weak_classifiers(1:weak_cnt);
    current_strong_classifiers(strong_cnt).confirmed = 1;
    
    fprintf('Evaluating samples with the strong classifier...\n');
    % Valuta i samples positivi con lo strong classifier appena aggiornato
    false_neg = 0;
    for i = 1:tot_pos
        if positives(i)
            HS = 0;
            for j = 1:cnt
                if weak_classify(current_strong_classifiers(strong_cnt).weak_classifiers(j), i)
                    HS = HS + current_strong_classifiers(strong_cnt).weak_classifiers(j).alpha;
                end
            end
            if HS >= current_strong_classifiers(strong_cnt).threshold
                positives(i) = 1;
            else
                false_neg = false_neg + 1;
                positives(i) = 0;
            end
        end
    end
    
    % Valuta i samples negativi con lo strong classifier appena aggiornato
    false_pos = 0;
    for i = tot_pos+1:tot_samples
        if positives(i)
            HS = 0;
            for j = 1:cnt
                if weak_classify(current_strong_classifiers(strong_cnt).weak_classifiers(j), i)
                    HS = HS + current_strong_classifiers(strong_cnt).weak_classifiers(j).alpha;
                end
            end
            if HS >= current_strong_classifiers(strong_cnt).threshold
                false_pos = false_pos + 1;
                positives(i) = 1;
            else
                positives(i) = 0;
            end
        end
    end
    
    fprintf('- False positives introduced: %d\n', false_pos);
    fprintf('- False negatives introduced: %d\n', false_neg);
    fprintf('Current status:\n');
    fprintf('- positives marked as positives (correct): %s\n', printpercent(sum(positives(1:tot_pos)), tot_pos));
    fprintf('- positives marked as negatives (false negatives): %s\n', printpercent(tot_pos - sum(positives(1:tot_pos)), tot_pos));
    fprintf('- negatives marked as positives (false positives): %s\n', printpercent(sum(positives(tot_pos+1:tot_samples)), tot_neg));
    fprintf('- negatives marked as negatives (correct): %s\n', printpercent(tot_neg - sum(positives(tot_pos+1:tot_samples)), tot_neg));
end

fprintf('\nTraining terminated, saving results...\n');
% Finalizza la cascata di classificatori e salva su file
weak_classifier = struct('X',zeros(1,4), 'Y', zeros(1,4), 'polarity', 0, 'threshold', 0, 'alpha', 0);
cascade = struct('weak_classifiers', weak_classifier, 'threshold', 0);
for i = 1:MAX_STRONG_CNT
    cur_strong = current_strong_classifiers(i);
    if cur_strong.confirmed
        cascade(i).threshold = cur_strong.threshold;
        weak_cnt = length(cur_strong.weak_classifiers);
        for j = 1:weak_cnt
            cur_weak = cur_strong.weak_classifiers(j);
            if cur_weak.confirmed
                cascade(i).weak_classifiers(j).X = cur_weak.X;
                cascade(i).weak_classifiers(j).Y = cur_weak.Y;
                cascade(i).weak_classifiers(j).polarity = cur_weak.polarity;
                cascade(i).weak_classifiers(j).threshold = cur_weak.threshold;
                cascade(i).weak_classifiers(j).alpha = cur_weak.alpha;
            else
                break;
            end
        end
    else
        break;
    end
end
save(TRAINING_OUT_FILE, 'cascade');