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
    % initialize useful variables
    %
    tot_pos = size(original_positives,3);                           % Numero di esempi positivi
    tot_neg = size(original_negatives,3);                           % Numero di esempi negativi
    tot_examples = tot_pos + tot_neg;                               % Numero totale di esempi
    integral_images = zeros(IMSIZE+1, IMSIZE+1, tot_pos + tot_neg);    % Gli esempi
    
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
    fcnt = 0;
    function fcnt_increment(X,Y)
        fcnt = fcnt + 1;
    end
    foreachfeature(IMSIZE, @fcnt_increment);
    fprintf('counted %d Haar-like features\n', fcnt);
    
    %-----------------------------------------------
    % Training algorithm
    %-----------------------------------------------
    
    % Inizializzo le variabili
    cascade_stage = 0;                                  % Numero del classificatore forte corrente (livello della cascata di classificatori)
    positives = ones(1, tot_examples);           % Array che contrassegna gli esempi considerati positivi dall'algoritmo
    
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
        fn = tot_pos - sum(positives(1:tot_pos));
    end
    
    fprintf('>>> training started! <<<');
    fprintf('Keep calm and do anything else: this will take a very long time...');
    tic;
    % Finchè ho falsi positivi
    while false_positives > 0
        cascade_stage = cascade_stage + 1;
        
        % Inizializzo variabili per il ciclo
        t = 0;                                  % Numero del classificatore debole corrente
        neg_pruned = 0;                         % Numero di esempi negativi potati dal classificatore forte
        neg_left = false_positives;             % Numero di esempi negativi ancora da potare
        pos_left = tot_pos - false_negatives;   % Numero di esempi positivi rimasti illesi
        
        % Inizializzo i pesi
        weights(1:tot_pos) = 1/(2*pos_left);
        weights(tot_pos+1:tot_examples) = 1/(2*neg_left);
        
        fprintf('computing cascade stage n. %d\n', cascade_stage); 
        
        % Finchè il numero di negativi potati è meno del 50%
        while(neg_pruned < neg_left / 2)
            t = t + 1;
            
            % Normalizzo i pesi Wt,i
            
            
            % Inizializzo T+ e T- al loro valore (che non cambierà)
            
            % Seleziono il miglior weak classifier rispetto all'errore
            % pesato: Per ogni feature
            
                % Inizializzo una lista ordinata di immagini
                
                % Inizializzo S+ e S-
                
                % Per ogni immagine
                
                    % Se l'immagine non è ancora stata scartata
                
                    % e = min(S+ + (T- - S-), S- + (T+ - S+))
                    %         |____________|  |____________|
                    %                |               |
                    %               p=-1            p=1
                    
                    % Se l'errore è minore di quelli calcolati
                    % precedentemente, salva il valore corrente come valore
                    % soglia, e salva p.
           
            % Aggiorno i pesi
        end
        fprintf('negative samples pruned: %d' + neg_pruned);
        
        % Aggiungo lo strong classifier risultante alla cascata
    end
    toc
end