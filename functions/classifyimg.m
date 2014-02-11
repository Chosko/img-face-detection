function is_obj = classifyimg(windowsize, I, detector, factor)

if size(I,2) ~= size(I,1)
    error('the width and the height of the image must be the same');
end
if nargin < 4
    factor = 1;
end

scale = (size(I,1)-1)/windowsize;
is_obj = 1;
for strong_cnt = 1:length(detector)
    cur_strong = detector(strong_cnt);
    
    HS = 0;
    tot_weak = length(cur_strong.weak_classifiers);
    for weak_cnt = 1:tot_weak;
        cur_weak = cur_strong.weak_classifiers(weak_cnt);
        cur_value = rectfeature(I, round(cur_weak.X * scale), round(cur_weak.Y*scale));
        if cur_weak.polarity * cur_value < cur_weak.polarity * cur_weak.threshold;
            HS = HS + cur_weak.alpha * factor;
        end
    end
    if HS < cur_strong.threshold
        is_obj = 0;
        break;
    end
    
end

end