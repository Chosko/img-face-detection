% Dimesione della finestra
IMSIZE = 24;

% Numero di features per gruppo
FEAT_PER_GROUP = 1000;

% Path della directory in cui vengono salvati i risultati del calcolo delle features
FEAT_PATH = 'features/';

% Prefisso del nome di ogni file in cui è salvato un gruppo di features
FEAT_FILE_PREFIX = 'featgroup';

% Path in cui sono salvate le funzioni
FUNCTIONS_PATH = 'functions/';

% Percorso in cui si trovano gli esempi positivi
POSITIVES_PATH = 'img/training-set/faces/';

% Percorso in cui si trovano gli esempi negativi
NEGATIVES_PATH = 'img/training-set/not-faces/';

% Dimesione della finestra
IMSIZE = 24;

% Massimo numero di weak classifiers per ogni strong classifiers
MAX_WEAK_CNT = 50;

% Massimo numero di stages nella cascata di strong classifiers
MAX_STRONG_CNT = 20;

% Environment di test
if exist('TEST', 'var') && TEST
    % Numero di features per gruppo
    FEAT_PER_GROUP = 10000;

    % Path della directory in cui vengono salvati i risultati del calcolo delle features
    FEAT_PATH = 'test/features/';

    % Percorso in cui si trovano gli esempi positivi
    POSITIVES_PATH = 'test/training-set/faces/';

    % Percorso in cui si trovano gli esempi negativi
    NEGATIVES_PATH = 'test/training-set/not-faces/';
end

addpath(FEAT_PATH);
addpath(FUNCTIONS_PATH);