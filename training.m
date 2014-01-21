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
    
    %-----------------------------------------------
    % Training algorithm
    %-----------------------------------------------
    
    % Inizializzo le variabili
    layer = 0;                                  % Numero del classificatore forte corrente (livello della cascata di classificatori)
    tot_neg = length(negatives);                % Numero di esempi negativi
    tot_pos = length(positives);                % Numero di esempi positivi
    false_positives = tot_neg;                  % Numero di falsi positivi rimasti
    
    % Finchè ho falsi positivi
    while false_positives > 0
        layer = layer + 1;
        
        % Inizializzo i pesi
        positive_weights(1:tot_pos) = 1/(2*tot_pos);
        negative_weights(1:tot_neg) = 1/(2*tot_neg);
        
        % Inizializzo variabili per il ciclo
        t = 0;                                  % Numero del classificatore debole corrente
        neg_pruned = 0;                         % Numero di negativi potati dal classificatore forte
        
        % Finchè il numero di negativi potati è meno del 50%
        while(neg_pruned < tot_neg / 2)
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
        % Aggiungo lo strong classifier risultante alla cascata
    end
end