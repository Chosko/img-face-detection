function positive = weak_classify(weak_classifier, value_index)
    f = weak_classifier;
    positive = f.polarity * f.values(value_index) < f.polarity * f.threshold;
end