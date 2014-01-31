fprintf('This script will restart the training, DELETING ALL THE DATA of the previous training.\n');
in = '';
while(~strcmp(in,'y') && ~strcmp(in,'n'))
    in = input('Do you really want to RESET the training? [y/n] ', 's');
end
if strcmp(in,'y')
    fprintf('### RESET STARTED ###\n');
    clear_features;
    compute_features;
    delete(TRAINING_TMP_FILE);
    training;
    show_detector;
    Y = detect(IMSIZE,imread('test\testimage.jpg'),cascade);
    figure;
    imshow(Y);
else
    fprintf('Reset aborted\n');
end