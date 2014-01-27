%--------------------------------------------------------------------------
%   Once the training set has been created, this script trains the
%   classifiers.
%--------------------------------------------------------------------------
function training
    
    %----------------------------------------------------------------------
    % NESTED FUNCTIONS
    %----------------------------------------------------------------------
    
    %
    % Trova il miglior classificatore debole
    %
    function find_best_weak_classifier(X,Y,feat_cnt,group_cnt)
        if(feat_cnt == 1)
            fprintf('.');
        end
        
        % Se il gruppo corrente non corrisponde a quello della feature corrente
        if(group.n ~= group_cnt)
            % Se il gruppo corrente è da salvare
            if group.saved == 0
                % Lo contrassegno come salvato e lo salvo su file
                group.saved = 1;
                filename = sprintf('./tmp/featgroup_%d.mat', group.n);
                save(filename, 'group');
            end
            
            % Aggiorno il gruppo corrente caricando quello della feature corrente
            filename = sprintf('./tmp/featgroup_%d.mat', group_cnt);
            
            % Se esiste il file del gruppo richiesto lo carico
            if(exist(filename, 'file'))
                loaded = load(filename, 'group');
                group = loaded.group;
                clear loaded;
            % Altrimenti creo un gruppo nuovo e lo contrassegno come da salvare
            else
                group.n = group_cnt;
                group.saved = 0;
                group.values = [];
            end
        end
        
        % Se la feature corrente è stata già calcolata per il gruppo corrente
        if(size(group.values,1) >= feat_cnt)
            % La carico dal gruppo corrente
            cur_feat_values = group.values(feat_cnt, :);
        else
            % Altrimenti la creo
            cur_feat_values = zeros(1,tot_examples);

            % Calcolo la feature per tutte le immagini
            for j=1:tot_examples
                cur_feat_values(j) = rectfeature(integral_images(:,:,j),X,Y);
            end

            % Inserisco la feature nel gruppo
            group.values(feat_cnt, :) = cur_feat_values;

            % Contrassegno il gruppo come "da salvare"
            group.saved = 0;
        end
        
        % Inizializzo una lista ordinata di immagini
        [sorted_examples,sorted_indices] = sort(cur_feat_values);
        
        % Inizializzo S+ e S-
        Spos = 0;
        Sneg = 0;
        
        % Per ogni immagine
        for j=1:tot_examples
            % Se l'immagine non è ancora stata scartata
            if(positives(sorted_indices(j)))
                
                % Calcola questa formula:
                %
                % e = min(S+ + (T- - S-), S- + (T+ - S+))
                %         |____________|  |____________|
                %                |               |
                %               p=-1            p=1
                
                e1 = Spos + (Tneg - Sneg);
                e2 = Sneg + (Tpos - Spos);
                
                if e1 < e2
                    p = -1;
                    eTmp = e1;
                else
                    p = 1;
                    eTmp = e2;
                end
                
                % Se l'errore è minore di quelli calcolati
                % precedentemente, salva il valore corrente come valore
                % soglia, e salva il weak_classifier.
                if eTmp < e
                    e = eTmp;
                    weak_classifiers(weak_cnt).X = X;
                    weak_classifiers(weak_cnt).Y = Y;
                    weak_classifiers(weak_cnt).p = p;
                    weak_classifiers(weak_cnt).threshold = sorted_examples(j);
                end
                
                if sorted_indices(j) > tot_pos
                    Sneg = Sneg + weights(sorted_indices(j));
                else
                    Spos = Spos + weights(sorted_indices(j));
                end
            end
        end
    end
    
    %
    % Conta le features
    %
    function fcnt_increment(X,Y,feat_cnt, grp)
        tot_features = tot_features + 1;
    end

    %
    % Questa funzione conta i falsi positivi rimasti
    %
    function fp = false_positives
        fp = sum(positives(tot_pos+1:tot_examples));
    end
    
    %
    % Questa funzione conta i falsi negativi rimasti
    %
    function fn = false_negatives
        fn = tot_pos - true_positives;
    end
    
    %
    % Questa funzione conta i veri positivi
    %
    function tp = true_positives
        tp = sum(positives(1:tot_pos));
    end
    
    %
    % Questa funzione conta i veri negativi
    %
    function tn = true_negatives
        tn = tot_neg - false_positives;
    end

    %
    % Questa funzione stampa lo stato corrente
    %
    function print_status
        fprintf('- positives marked as positives (correct): %s\n', printpercent(sum(positives(1:tot_pos)), tot_pos));
        fprintf('- positives marked as negatives (false negatives): %s\n', printpercent(tot_pos - sum(positives(1:tot_pos)), tot_pos));
        fprintf('- negatives marked as positives (false positives): %s\n', printpercent(sum(positives(tot_pos+1:tot_examples)), tot_neg));
        fprintf('- negatives marked as negatives (correct): %s\n', printpercent(tot_neg - sum(positives(tot_pos+1:tot_examples)), tot_neg));
    end
    
    %----------------------------------------------------------------------
    % TRAINING ALGORITHM
    %----------------------------------------------------------------------

    IMSIZE = 24;            % The dimension of each image of the training set.
    FEAT_PER_GROUP = 1000;    % The number of Haar-like features per group

    %
    % read all the images from the training set
    %
    fprintf('reading positive images from the training set...\n');
    original_positives = imreadall('img\training-set\faces\', IMSIZE, IMSIZE);
    fprintf('positive images read: %d\n', size(original_positives,3));
    fprintf('reading negative images from the training set...\n');
    original_negatives = imreadall('img\training-set\not-faces\', IMSIZE, IMSIZE);
    fprintf('negative images read: %d\n', size(original_negatives,3));

    %
    % initialize useful variables
    %
    tot_pos = size(original_positives,3);                           % Numero di esempi positivi
    tot_neg = size(original_negatives,3);                           % Numero di esempi negativi
    tot_examples = tot_pos + tot_neg;                               % Numero totale di esempi
    integral_images = zeros(IMSIZE+1, IMSIZE+1, tot_pos + tot_neg); % Gli esempi
    
    %
    % calculate the integral images
    %
    fprintf('calculating the integral images...\n');
    for i=1:tot_pos
        integral_images(:,:,i) = ii(original_positives(:,:,i));
    end
    for i=tot_pos+1:tot_examples
        integral_images(:,:,i) = ii(original_negatives(:,:,i-tot_pos));
    end
    fprintf('integral images calculated\n');
    
    %
    % Count the number of features
    %
    fprintf('counting number of features for a window of %dx%d...\n', IMSIZE, IMSIZE);
    tot_features = 0;
    foreachfeature(IMSIZE, @fcnt_increment);
    fprintf('counted %d Haar-like features\n', tot_features);
    
    %
    % Inizializzo le variabili
    %
    strong_cnt = 0;                                                     % Numero del classificatore forte corrente
    positives = ones(1, tot_examples);                                  % Array che contrassegna gli esempi considerati positivi dall'algoritmo
    strong_classifiers = struct('weak_classifiers', 0);                 % Gli strong classifiers della cascata
    group = struct('n',0,'saved',1,'values',[]);
    
    fprintf('### training started! ###\n');
    fprintf('Keep calm and do anything else: this will take a very long time...\n');
    tic;
    % Finchè ho falsi positivi
    while false_positives > 0
        strong_cnt = strong_cnt + 1;
        
        % Inizializzo variabili per il ciclo
        weak_cnt = 0;                                                           % Numero del classificatore debole corrente
        neg_pruned = 0;                                                         % Numero di esempi negativi potati dal classificatore forte
        pos_approved = 0;                                                       % Numero di esempi positivi approvati dal classificatore forte
        neg_to_prune = false_positives;                                         % Numero di esempi negativi ancora da potare
        pos_to_approve = false_negatives;                                       % Numero di esempi positivi ancora da approvare
        neg_ok = true_negatives;                                                % Numero di esempi negativi già potati
        pos_ok = true_positives;                                                % Numero di esempi positivi già approvati
        
        weak_classifiers = struct('X',0,'Y',0,'p',0,'threshold',0, 'alpha',0);  % I weak classifiers dello strong classifier corrente
        
        % Inizializzo i pesi
        weights(1:tot_pos) = 1/(2*pos_ok);
        weights(tot_pos+1:tot_examples) = 1/(2*neg_to_prune);
        
        fprintf('*** computing cascade stage n. %d ***\n', strong_cnt);
        print_status
        
        % Finchè il numero di negativi potati è meno del 50%, ciclo le
        while(neg_pruned < neg_to_prune / 2)
            weak_cnt = weak_cnt + 1;            % Numero del classificatore debole corrente
            fprintf('--- selecting the weak classifier n. %d for this stage... ---\n', weak_cnt);
            
            % Normalizzo i pesi rispetto agli esempi positivi rimasti
            weights = weights./sum(weights .* positives);
            
            % Inizializzo T+ e T- al loro valore (che non cambierà fino al prossimo ciclo)
            Tpos = sum(positives(1:tot_pos).*weights(1:tot_pos));
            Tneg = sum(positives(tot_pos+1:tot_examples).*weights(tot_pos+1:tot_examples));
            
            % Inizializza le variabili per trovare l'errore minimo
            weak_classifiers(weak_cnt).p = 0;
            e = inf;
            
            fprintf('|----progress bar');
            for i = 17:ceil(tot_features/FEAT_PER_GROUP)
                fprintf('-');
            end
            fprintf('|\n|');
            
            % Trova il miglior classificatore debole rispetto al peso
            foreachfeature(IMSIZE, @find_best_weak_classifier, FEAT_PER_GROUP);
            fprintf('|\n');
            fprintf('updating weights...\n');
            
            % Aggiorno i pesi
            beta = e/(1-e);
            for i = 1:tot_examples
                if positives(i) ~= 1
                    continue;
                end
                cur_feat = weak_classifiers(weak_cnt);
                pos = weak_classify(integral_images(:,:,i), cur_feat.X, cur_feat.Y, cur_feat.p, cur_feat.threshold);
                if i <= tot_pos && pos || i > tot_pos && ~pos
                    weights(i) = weights(i) * beta;
                end
            end
            fprintf('weights updated\n');
            
            fprintf('\nweak classifier chosen:\n- X: [');
            fprintf(' %d', cur_feat.X);
            fprintf(' ]\n- Y: [');
            fprintf(' %d', cur_feat.Y);
            fprintf(' ]\n- polarity: %d\n- threshold: %d\n', cur_feat.p, cur_feat.threshold);
            
            % Imposta le variabili per lo strong classifier
            weak_classifiers(weak_cnt).alpha = log(1/beta);
            
            fprintf('testing the strong classifier (composed by %d weak classifiers)...\n', weak_cnt);
            % Testa lo strong classifier sulle immagini negative
            pruned = [];
            approved = [];
            neg_pruned = 0;
            neg_approved = 0;
            pos_pruned = 0;
            pos_approved = 0;
            for i = 1:tot_examples
                if strong_classify(integral_images(:,:,i),weak_classifiers)
                    if positives(i)
                        continue;
                    end
                    approved = [approved i];
                    if i <= tot_pos
                        pos_approved = pos_approved + 1;
                    else
                        neg_approved = neg_approved + 1;
                    end
                else
                    if positives(i) ~= 1
                        continue;
                    end
                    pruned = [pruned i];
                    if i > tot_pos
                        neg_pruned = neg_pruned + 1;
                    else
                        pos_pruned = pos_pruned + 1;
                    end
                end
            end
            fprintf('- positive samples approved (correct): %s\n', printpercent(pos_approved, pos_to_approve));
            fprintf('- positive samples pruned (wrong): %s\n', printpercent(pos_pruned, pos_ok));
            fprintf('- negative samples approved (wrong): %s\n', printpercent(neg_approved, neg_ok));
            fprintf('- negative samples pruned (correct): %s\n', printpercent(neg_pruned, neg_to_prune));
        end
        fprintf('\n');
        
        % Applico le modifiche alle immagini
        positives(pruned) = 0;
        positives(approved) = 1;
        
        % Aggiungo lo strong classifier risultante alla cascata
        strong_classifiers(strong_cnt).weak_classifiers = weak_classifiers;
    end
    toc
    save ('classifier_cascade.mat', 'strong_classifiers');
end