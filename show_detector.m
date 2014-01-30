%
% This script shows the structure of the detector
%
config_training;

load(TRAINING_OUT_FILE);
tot_strong = length(cascade);
max_weak_len = 0;
for strong_cnt=1:tot_strong
    weak_len = length(cascade(strong_cnt).weak_classifiers);
    if weak_len > max_weak_len
        max_weak_len = weak_len;
    end
end

figure('units','normalized','outerposition',[0 0 1 1])
for strong_cnt=1:tot_strong
    cur_strong = cascade(strong_cnt);
    tot_weak = length(cur_strong.weak_classifiers);
    for weak_cnt = 1:tot_weak
        cur_weak = cur_strong.weak_classifiers(weak_cnt);
        subplottight(tot_strong, max_weak_len, weak_cnt + max_weak_len * (strong_cnt-1)), subimage(feat2img(IMSIZE,cur_weak));
        axis off;
    end
end