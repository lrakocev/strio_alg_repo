function mt_sinai_w_clusters_n_stats = prep_mt_sinai_data_for_combining()

% if there is no "mt_sinai_demo_db.mat", run demo_db_for_mt_sinai.m
load('mt_sinai_demo_db.mat')
load('imt_wkspc.mat')

curr_sheet = "avg_data"; % "win_money"
imt_table = readtable("C:\Users\lrako\OneDrive\Documents\human_dm_data\all_k_subject_imt_data.xlsx","Sheet",curr_sheet,"NumHeaderLines",0);

rew = imt_table.Rew;
cost = imt_table.Cost;

curr_table = table;
imt_formatted = [];
var_names = imt_table.Properties.VariableNames;

for j = 1:length(var_names)
    var_name = var_names{j};
    if var_name(1) == "K" & length(var_name) == 4
        id = string(var_name(1:4));
        responses = imt_table.(var_name);
        rts = imt_table.(id + "_RT");
            
        ids_for_rows = repelem(id, length(responses),1);
        curr_table.id = ids_for_rows;

        if curr_sheet == "avg_data"
            curr_table.raw_response = responses;
            curr_table.approach_rate = (responses / 4) * 100;
        else
            number_responses = responses == "y";
            curr_table.raw_response = number_responses;
            curr_table.approach_rate = number_responses * 100;    
        end

        curr_table.reaction_time = rts;
        curr_table.rew = rew;
        curr_table.cost = cost;

        imt_formatted = [imt_formatted; curr_table];
    end
end


summary_behavior_per_subj = [];

unique_subs = unique(imt_formatted.id);

for k = 1:length(unique_subs)
    curr_id = unique_subs(k);
    curr_sub_behavior_table = imt_formatted(imt_formatted.id == curr_id, :);

    responses = curr_sub_behavior_table.raw_response / 4;
    avg_appr = mean(responses);
    
    behavior_grid = reshape(responses, 7, 8);
    behavior_entropy = entropy(behavior_grid);

    k01_subid = extractAfter(curr_id,"K");
    new_row.K01_SUBID = str2double(k01_subid);
    new_row.avg_appr = avg_appr;
    new_row.entropy = behavior_entropy; 

    summary_behavior_per_subj = [summary_behavior_per_subj; new_row];
end

summary_behavior_per_subj = struct2table(summary_behavior_per_subj); 

mt_sinai_w_clusters_n_stats = join(summary_behavior_per_subj,mt_sinai_w_clusters);
 
mt_sinai_w_clusters_n_stats.appr_category = discretize(mt_sinai_w_clusters_n_stats.avg_appr, 4);
mt_sinai_w_clusters_n_stats.ent_category = discretize(mt_sinai_w_clusters_n_stats.entropy, 4);

mt_sinai_w_clusters_n_stats.ghr_bin = discretize(mt_sinai_w_clusters_n_stats.aGHR, 4);
mt_sinai_w_clusters_n_stats.testos_bin = discretize(mt_sinai_w_clusters_n_stats.TotalTestos_ng_dL_, 4);
mt_sinai_w_clusters_n_stats.estr_bin = discretize(mt_sinai_w_clusters_n_stats.Estradiol_pg_mL_, 4);

end
