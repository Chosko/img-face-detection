%
% This script clears all the Haar-like features computed with
% compute_features.m
%

% Carica le costanti
config_training;

fprintf('Clearing all the features computed with compute_features.m\n');
fprintf('All the *.mat files into %s will be deleted\n', FEAT_PATH);
sure = '';
while (~strcmp(sure,'y')) && (~strcmp(sure,'n'))
    sure = input('Are you sure? [y/n] ', 's');
end
if strcmp(sure, 'y')
    listing = dir(FEAT_PATH);
    cnt = 0;
    for i = 1:length(listing)
        if ~isempty(regexp(listing(i).name, '.mat$'))
            cnt = cnt + 1;
            delete(sprintf('%s%s', FEAT_PATH, listing(i).name));
        end
    end
    fprintf('%d files cleared!\n', cnt);
else
    fprintf('Features were not cleared\n');
end