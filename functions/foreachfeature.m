function foreachfeature(size, func, feat_per_group)


%   Legend of cursors
%
%          columns
%  r    _1_ _2_ _3_ _ y0
%  o 1 |___|___|___|_ y1
%  w 2 |___|___|___|_ y2
%  s 3 |___|___|___|_ y3
%      |   |   |   |
%      x0  x1  x2  x3
%
%    The i_th cursor is positioned between the i_th and the i+1_th pixels.
    
    function n=inc
        cnt = cnt+1;
        if cnt > feat_per_group
            grp = grp + 1;
            cnt = 1;
        end
        n=cnt;
    end

    cnt=0;
    grp=1;
    if nargin < 3
        feat_per_group = inf;
    end
    exit_condition = nargout(func);

    % two-rectangle features use x0,x1,x2 and y0,y1 
    % (or y0,y1,y2 and x0,x1 for vertical features)
    for y0 = 0:size-1
        for x0 = 0:size-2
            for yscale = 1:size-y0
                for xscale = 1:floor((size-x0)/2)
                    y1 = y0 + yscale;
                    x1 = x0 + xscale;
                    x2 = x1 + xscale;
                    
                    % Check if the function returns an exit condition
                    if ~exit_condition
                        func([x0,x1,x2], [y0,y1], inc, grp);
                        func([y0,y1], [x0,x1,x2], inc, grp); % invert X and Y for vertical features.
                    else
                        if ~func([x0,x1,x2], [y0,y1], inc, grp)
                            return; % Return if exit condition was detected
                        end
                        
                        if ~func([y0,y1], [x0,x1,x2], inc, grp)
                            return; % Return if exit condition was detected
                        end
                    end
                end
            end
        end
    end

    % three-rectangle features use x0,x1,x2,x3 and y0,y1 
    % (or y0,y1,y2,y3 and x0,x1 for vertical features)
    for y0 = 0:size-1
        for x0 = 0:size-2
            for yscale = 1:size-y0
                for xscale = 1:floor((size-x0)/3)
                    y1 = y0 + yscale;
                    x1 = x0 + xscale;
                    x2 = x1 + xscale;
                    x3 = x2 + xscale;

                    % Check if the function returns an exit condition
                    if ~exit_condition
                        func([x0,x1,x2,x3], [y0,y1], inc, grp);
                        func([y0,y1], [x0,x1,x2,x3], inc, grp); % invert X and Y for vertical features.
                    else
                        if ~func([x0,x1,x2,x3], [y0,y1], inc, grp)
                            return; % Return if exit condition was detected
                        end
                        
                        if ~func([y0,y1], [x0,x1,x2,x3], inc, grp)
                            return; % Return if exit condition was detected
                        end
                    end
                end
            end
        end
    end

    % four rectangle features use x1,x2,x3 and y1,y2,y3
    for y0 = 0:size-1
        for x0 = 0:size-2
            for yscale = 1:floor((size-y0)/2)
                for xscale = 1:floor((size-x0)/2)
                    y1 = y0 + yscale;
                    y2 = y1 + yscale;
                    x1 = x0 + xscale;
                    x2 = x1 + xscale;
                    
                    % Check if the function returns an exit condition
                    if ~exit_condition
                        func([x0,x1,x2], [y0,y1,y2], inc, grp); % no inversion: four-rectangle features are simmetrical
                    else
                        if ~func([x0,x1,x2], [y0,y1,y2], inc, grp)
                            return; % Return if exit condition was detected
                        end
                    end
                end
            end
        end
    end

end
