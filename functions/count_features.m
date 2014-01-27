function cnt = count_features( window_size )
% function cnt = count_features( window_size )
%   This function counts the number of all the Haar-like features for the
%   given window_size

    cnt = 0;
    function inc(X,Y,f,g)
        cnt = cnt + 1;
    end
    
    foreachfeature(window_size, @inc);
end

