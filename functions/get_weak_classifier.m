function [ X, Y ] = get_weak_classifier( size, index )
% function [ X, Y ] = get_weak_classifier( input_args )
%   This function returns the weak_classifier identified by its index
    
    function fcontinue = get_feat(cur_X,cur_Y,f,g)
        fcontinue = 1;
        if(f == index)
            X = cur_X;
            Y = cur_Y;
            fcontinue = 0;
        end
    end
    
    X = [];
    Y = [];
    
    foreachfeature(size, @get_feat);
end

