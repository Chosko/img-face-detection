function positive = strong_classify(I,weak_classifiers)
    threshold = 0;
    value = 0;
    
    for i = 1:length(weak_classifiers)
        cur = weak_classifiers(i);
        threshold = threshold + cur.alpha;
        value = value + cur.alpha * weak_classify(I,cur.X,cur.Y,cur.p,cur.threshold);
    end
    threshold = threshold/2;
    
    positive = value >= threshold;
end

