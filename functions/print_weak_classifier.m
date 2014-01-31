function print_weak_classifier( size, feat, picture )
% function print_weak_classifier( size, weak_classifier )
%   Prints a visualization of the given weak_classifier
    
    if nargin < 3
        picture = 0;
    end
    if(picture)
        X = [1, feat.X, size];
        Y = [1, feat.Y, size];
        for row = 1:size
            fprintf('  ');
            for column = 1:size
                if max(ismember(X, column)) && max(ismember(Y, row))
                    fprintf('+ ');
                elseif max(ismember(X, column))
                    fprintf('| ');
                elseif max(ismember(Y, row))
                    fprintf('--');
                else
                    fprintf('  ');
                end
            end
            fprintf('\n');
        end
    end
    fprintf('- X: ['); fprintf(' %d', feat.X); fprintf(' ]\n');
    fprintf('- Y: ['); fprintf(' %d', feat.Y); fprintf(' ]\n');
    fprintf('- polarity: %d\n', feat.polarity);
    fprintf('- threshold: %d\n', feat.threshold);
end

