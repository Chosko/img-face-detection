function [tot_groups, groups_skipped] = calculate_all_features( integral_images, feats_per_group, output_path, group_file_prefix )
% Calcola tutte le features per le immagini inserite e le salva sui file

    function savegroup
        if(~saved && ~skip)
            
            % Salvo il gruppo su file
            filename = sprintf('%s%s_%d.mat', output_path, group_file_prefix, current_group);
            save(filename, 'group');
            
        end
        if skip
            groups_skipped = groups_skipped + 1;
        end
    end

    function ex=existgroup
        group_filename = sprintf('%s%s_%d.mat', output_path, group_file_prefix, current_group);
        ex = exist(group_filename, 'file');
    end

    function calc_feats(X,Y,feat_cnt,group_cnt)
        % Se il gruppo corrente non corrisponde a quello della feature corrente
        if(current_group ~= group_cnt)
            savegroup
            fprintf('.');
            current_group = group_cnt;
            group = [];
            if existgroup
                saved = 1;
                skip = 1;
            else
                saved = 0;
                skip = 0;
            end
        end
        
        if(~skip)
            % Creo la variabile che contiene le features
            tot_examples = size(integral_images,3);
            cur_feat_values = zeros(1,tot_examples);

            % Calcolo la feature per tutte le immagini
            for j=1:tot_examples
                cur_feat_values(j) = rectfeature(integral_images(:,:,j),X,Y);
            end

            % Inserisco la feature nel gruppo
            group(feat_cnt, :) = cur_feat_values;
        end
    end

    current_group = 0;
    saved = 1;
    skip = 0;
    group = [];
    groups_skipped = 0;
    imsize = size(integral_images,1) - 1;
    foreachfeature(imsize, @calc_feats, feats_per_group);
    savegroup;
    tot_groups = current_group;
end

