fprintf('This script will restart the training, DELETING ALL THE DATA of the previous training.\n');
in = '';
while(~strcmp(in,'y') && ~strcmp(in,'n'))
    in = input('Do you really want to RESET the training? [y/n] ', 's');
end
if strcmp(in,'y')
    fprintf('### RESET STARTED ###\n');
    clear_features;
    compute_features;
    training;
    show_detector;
    test_detector;
else
    fprintf('Reset aborted\n');
end