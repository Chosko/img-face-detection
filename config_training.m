% Numero di features per gruppo
FEAT_PER_GROUP = 1000;

% Path della directory in cui vengono salvati i risultati del calcolo delle features
FEAT_PATH = 'features/';

% Prefisso del nome di ogni file in cui è salvato un gruppo di features
FEAT_FILE_PREFIX = 'featgroup';

% File di output della fase di training
TRAINING_OUT_FILE = 'out/cascade.mat';

% File temporaneo che salva lo stato dell'esecuzione per effettuare resume
% in caso di crash
TRAINING_TMP_FILE = 'out/tmp.mat';

% Path in cui sono salvate le funzioni
FUNCTIONS_PATH = 'functions/';

% Percorso in cui si trovano gli esempi positivi
POSITIVES_PATH = 'img/newtraining/face/';

% Percorso in cui si trovano gli esempi negativi
NEGATIVES_PATH = 'img/newtraining/non-face/';

% Percorso delle immagini positive che servono per testare il detector dopo
% che è stato allenato
POSITIVE_TEST_PATH = 'img/newtraining/test/face/';

% Percorso delle immagini negative che servono per testare il detector dopo
% che è stato allenato
NEGATIVE_TEST_PATH = 'img/newtraining/test/non-face/';

% Dimesione della finestra
IMSIZE = 19;

% Massimo numero di weak classifiers per ogni strong classifiers
MAX_WEAK_CNT = 50;

% Massimo numero di stages nella cascata di strong classifiers
MAX_STRONG_CNT = 20;

% Environment di test
if exist('TEST', 'var') && TEST
    FEAT_PER_GROUP = 1000;
    MAX_WEAK_CNT = 10;
    MAX_STRONG_CNT = 10;
    FEAT_PATH = 'test/features/';
    POSITIVES_PATH = 'test/training-set/faces/';
    NEGATIVES_PATH = 'test/training-set/not-faces/';
    POSITIVE_TEST_PATH = 'test/training-set/faces/';
    NEGATIVE_TEST_PATH = 'test/training-set/not-faces/';
    TRAINING_OUT_FILE = 'test/out/cascade.mat';
    TRAINING_TMP_FILE = 'test/out/tmp.mat';
    IMSIZE = 19;
end

addpath(FUNCTIONS_PATH);