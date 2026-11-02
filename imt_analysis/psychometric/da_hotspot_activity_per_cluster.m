function [left_hotspot_cluster_activity,right_hotspot_cluster_activity, ...
    left_hotspot_cluster_num_cnx, right_hotspot_cluster_num_cnx, ...
    left_hotspot_cluster_num_strio, right_hotspot_cluster_num_strio, ...
    left_hotspot_cost_cluster_activity, right_hotspot_cost_cluster_activity, ...
    left_hotspot_cost_cluster_num_cnx, right_hotspot_cost_cluster_num_cnx, ...
    left_hotspot_cost_cluster_num_strio, right_hotspot_cost_cluster_num_strio, ...
    left_strio_cluster_activity, right_strio_cluster_activity, ...
    left_strio_cost_cluster_activity, right_strio_cost_cluster_activity, rew_cluster_table, cost_cluster_table, new_table] ...
    = da_hotspot_activity_per_cluster(full_db, all_clean_behavior, save_to)

if isempty(full_db)
    load("all_vox_activity_all_subjects.mat")
end

if isempty(all_clean_behavior)
    [all_clean_behavior, ~] = get_clean_behavior();
end


rew_clusters = 5;
rew_cluster_table = cluster_in_scanner_psychs(all_clean_behavior, "rew_b", "rew_c", rew_clusters, "rew", save_to);

cost_clusters = 5;
cost_cluster_table = cluster_in_scanner_psychs(all_clean_behavior, "cost_b", "cost_c", rew_clusters, "cost", save_to);


left_hotspot_cluster_activity = cell(1, rew_clusters);
right_hotspot_cluster_activity = cell(1, rew_clusters);

left_strio_cluster_activity = cell(1, rew_clusters);
right_strio_cluster_activity = cell(1, rew_clusters);

left_hotspot_cluster_num_cnx = cell(1, rew_clusters);
right_hotspot_cluster_num_cnx = cell(1, rew_clusters);

left_hotspot_cluster_num_strio = cell(1, rew_clusters);
right_hotspot_cluster_num_strio = cell(1, rew_clusters);

left_hotspot_cost_cluster_activity = cell(1, cost_clusters);
right_hotspot_cost_cluster_activity = cell(1, cost_clusters);

left_strio_cost_cluster_activity = cell(1, rew_clusters);
right_strio_cost_cluster_activity = cell(1, rew_clusters);

left_hotspot_cost_cluster_num_cnx =  cell(1, cost_clusters);
right_hotspot_cost_cluster_num_cnx =  cell(1, cost_clusters);

left_hotspot_cost_cluster_num_strio =  cell(1, cost_clusters);
right_hotspot_cost_cluster_num_strio =  cell(1, cost_clusters);


new_table = [];
for j = 1:length(full_db)
    curr_subj_data = full_db{1,j};

    subj_event_table = curr_subj_data{1,1};
    subj_vox_table = curr_subj_data{1,2};

    subjectidnumber = str2double(subj_event_table.paricipant(1));

    rew_cluster = rew_cluster_table(rew_cluster_table.participant == subjectidnumber, :).cluster_idx;
    cost_cluster = cost_cluster_table(cost_cluster_table.participant == subjectidnumber, :).cluster_idx;
    
    if isempty(rew_cluster) | isempty(cost_cluster)
        continue
    end

    try
        rew_cluster = rew_cluster(1);
        cost_cluster = cost_cluster(1);
        [~, ~, snc_activity_w_trial_lvls_ext, left_strio_snc_hotspots, right_strio_snc_hotspots, left_strio_activity, right_strio_activity, ...
            left_hotspot_activity, right_hotspot_activity] = ...
            da_hotspot_activity_per_subject(subj_event_table, subj_vox_table, all_clean_behavior);

        right_striosomes = subj_vox_table.right_caudate_full_striosome_0_thresh{1,1}; 
        left_striosomes = subj_vox_table.left_caudate_full_striosome_0_thresh{1,1}; 

    catch
        left_hotspot_activity = [];
        right_hotspot_activity = [];
        left_strio_activity = 0;
        right_strio_activity = 0;
        left_strio_snc_hotspots = [];
        right_strio_snc_hotspots = [];
        left_striosomes = 0;
        right_striosomes = 0;  
    end
    
    % this was a crazy way to organize this -- need to remake it into a
    % table instead


    % snc activity in clusters (rew + cost)
    
    left_hotspot_cluster_activity{rew_cluster} = [left_hotspot_cluster_activity{rew_cluster}; mean(left_hotspot_activity, 'all', 'omitnan')];
    right_hotspot_cluster_activity{rew_cluster} = [right_hotspot_cluster_activity{rew_cluster};  mean(right_hotspot_activity, 'all', 'omitnan')];

    left_hotspot_cost_cluster_activity{cost_cluster} = [left_hotspot_cost_cluster_activity{cost_cluster}; mean(left_hotspot_activity, 'all', 'omitnan')];
    right_hotspot_cost_cluster_activity{cost_cluster} = [right_hotspot_cost_cluster_activity{cost_cluster};  mean(right_hotspot_activity, 'all', 'omitnan')];
    
    % strio activity in clusters (rew + cost)
    left_strio_cluster_activity{rew_cluster} = [left_strio_cluster_activity{rew_cluster}; mean(left_strio_activity, 'all', 'omitnan')];
    right_strio_cluster_activity{rew_cluster} = [right_strio_cluster_activity{rew_cluster};  mean(right_strio_activity, 'all', 'omitnan')];
    
    left_strio_cost_cluster_activity{cost_cluster} = [left_strio_cost_cluster_activity{cost_cluster}; mean(left_strio_activity, 'all', 'omitnan')];
    right_strio_cost_cluster_activity{cost_cluster} = [right_strio_cost_cluster_activity{cost_cluster};  mean(right_strio_activity, 'all', 'omitnan')];
    

    % num hi strio to snc cnx in clusters (rew + cost)
    left_hotspot_cluster_num_cnx{rew_cluster}  = [left_hotspot_cluster_num_cnx{rew_cluster};  length(left_strio_snc_hotspots)];
    right_hotspot_cluster_num_cnx{rew_cluster}  = [right_hotspot_cluster_num_cnx{rew_cluster} ;  length(right_strio_snc_hotspots)];
    
    left_hotspot_cost_cluster_num_cnx{cost_cluster}  = [left_hotspot_cost_cluster_num_cnx{cost_cluster};  length(left_strio_snc_hotspots)];
    right_hotspot_cost_cluster_num_cnx{cost_cluster}  = [right_hotspot_cost_cluster_num_cnx{cost_cluster} ;  length(right_strio_snc_hotspots)];
    
    % num striosomes in clusters (rew + cost)
    left_hotspot_cluster_num_strio{rew_cluster}  = [left_hotspot_cluster_num_strio{rew_cluster}; size(left_striosomes,1 )];
    right_hotspot_cluster_num_strio{rew_cluster}  = [right_hotspot_cluster_num_strio{rew_cluster}; size(right_striosomes, 1)];

    left_hotspot_cost_cluster_num_strio{cost_cluster} = [left_hotspot_cost_cluster_num_strio{cost_cluster}; size(left_striosomes, 1)];
    right_hotspot_cost_cluster_num_strio{cost_cluster} = [right_hotspot_cost_cluster_num_strio{cost_cluster}; size(right_striosomes, 1)];  
    
    close all

    new_row.subjectidnumber = subjectidnumber;
    new_row.in_scanner_rew_cluster = rew_cluster;
    new_row.in_scanner_cost_cluster = cost_cluster;
    new_row.left_hotspot_cluster_activity  = mean(left_hotspot_activity, 'all', 'omitnan');
    new_row.right_hotspot_cluster_activity = mean(right_hotspot_activity, 'all', 'omitnan');
    new_row.left_strio_cost_cluster_activity = mean(left_strio_activity, 'all', 'omitnan');
    new_row.right_strio_cost_cluster_activity = mean(right_strio_activity, 'all', 'omitnan');
    new_row.left_hotspot_cluster_num_cnx = length(left_strio_snc_hotspots);
    new_row.right_hotspot_cluster_num_cnx = length(right_strio_snc_hotspots);
    new_row.left_hotspot_cost_cluster_num_strio = size(left_striosomes,1 );
    new_row.right_hotspot_cost_cluster_num_strio = size(left_striosomes,1 );

    new_table = [new_table; new_row];

end

new_table = struct2table(new_table);

end