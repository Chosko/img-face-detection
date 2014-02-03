%
% This scripts tests the detector against a set of test images
%

% Carica le impostazioni
config_training;

% Carica il set di test
fprintf('loading test images...\n');
positives_src = imreadall(POSITIVE_TEST_PATH,IMSIZE,IMSIZE);
negatives_src = imreadall(NEGATIVE_TEST_PATH,IMSIZE,IMSIZE);
tot_pos = size(positives_src,3);
tot_neg = size(negatives_src,3);
tot_samples = tot_pos + tot_neg;
fprintf('loaded %d positive and %d negative images\n', tot_pos, tot_neg);

% Calcola le immagini integrali
fprintf('Calculating integral images...\n');
integral_images = zeros(IMSIZE + 1, IMSIZE + 1, tot_samples);
for i = 1:tot_pos
    integral_images(:,:,i) = ii(positives_src(:,:,i));
end
for i = tot_pos+1:tot_samples
    integral_images(:,:,i) = ii(negatives_src(:,:,i-tot_pos));
end

% Carica il detector
fprintf('loading detector...\n');
if exist(TRAINING_OUT_FILE, 'file')
   load(TRAINING_OUT_FILE);
else
    error('The detector was not found... did you trained the detector using ''training''?');
end
tot_stages = length(cascade);

fprintf('*** Testing started! ***\n');

% Imposta le variabili
positives = ones(1,tot_samples);        % Esempi classificati come positivi
accuracy = zeros(4,tot_stages);         % Stats
false_negatives = 0;                    % Numero di falsi negativi

% Per ogni stage della cascata
for strong_cnt = 1:tot_stages
    fprintf('Testing stage %d\n',strong_cnt);
    fprintf('|--------------------|\n|');
    
    cur_strong = cascade(strong_cnt);
    accuracy(2,strong_cnt) = sum(positives(1:tot_pos));
    accuracy(4,strong_cnt) = sum(positives(tot_pos+1:tot_samples));
    
    false_positives = 0; % Numero di falsi positivi. Si azzera ad ogni ciclo perchè vanno ricalcolati per ogni stage che si aggiunge
    
    % Per ogni esempio
    for i=1:tot_samples
        if mod(i, ceil(tot_samples/20)) == 1
            fprintf('.');
        end
        
        % Esegue solo se l'immagine non è ancora stata scartata
        if positives(i)
            HS = 0;
            
            %Per ogni weak classifier
            for weak_cnt = 1:length(cur_strong.weak_classifiers)
                cur_weak = cur_strong.weak_classifiers(weak_cnt);
                if cur_weak.polarity * rectfeature(integral_images(:,:,i),cur_weak.X,cur_weak.Y) < cur_weak.polarity * cur_weak.threshold
                    HS = HS + cur_weak.alpha;
                end
            end
            if HS >= cur_strong.threshold
                positives(i) = 1;
                if i > tot_pos
                    false_positives = false_positives + 1;
                end
            else
                positives(i) = 0;
                if i <= tot_pos
                    false_negatives = false_negatives + 1;
                end
            end
        end
    end
    fprintf('|\n');
    
    % Salva le statistiche
    accuracy(1,strong_cnt) = false_positives;
    accuracy(3,strong_cnt) = false_negatives;
end

% Stampa i risultati
figure
plot(1:tot_stages, accuracy(1,:)/tot_neg,'-k')
hold on
plot(1:tot_stages, accuracy(3,:)/tot_pos,'-b')
hold off
title('Experimental Accuracy')
ylabel('rate')
xlabel('stage')
legend('false positive','false negative','location','northeast');
