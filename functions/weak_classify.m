function positive = weak_classify(I,X,Y,p,threshold)
    f = rectfeature(I,X,Y);
    positive = p*f < p*threshold;
end