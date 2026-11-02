%% load relevant info

load("all_clean_behavior.mat")
%load("all_vox_activity_all_subjects.mat")
load('mt_sinai_demo_db.mat')

%% out of scanner into same coords

out_of_scanner_table = mt_sinai_w_clusters(:, {'x_coord','y_coord','z_coord', 'K01_SUBID'});
out_of_scanner_table = renamevars(out_of_scanner_table, {'x_coord','y_coord','z_coord', 'K01_SUBID'}, {'rew_a','rew_b','rew_c','participant'});
out_of_scanner_table.in_or_out = repelem("out", height(out_of_scanner_table), 1);

in_scanner_table = all_clean_behavior(:, {'rew_a','rew_b','rew_c','participant'});
in_scanner_table.in_or_out = repelem("in", height(all_clean_behavior), 1);

all_psychs_table = unique([out_of_scanner_table; in_scanner_table], "rows");

%% analysing clusters

cluster_info_save_to =  'C:\Users\lrako\OneDrive\Documents\mt_sinai\cluster_info_' + string(date);
mkdir(cluster_info_save_to)
rew_clusters = 5;
rew_cluster_table = cluster_in_scanner_psychs(all_psychs_table, "rew_b", "rew_c", rew_clusters, "reward", cluster_info_save_to);

examine_cluster_info(rew_cluster_table, "rew_a", "rew_b", "rew_c", cluster_info_save_to)


%% strio/snc/etc activity per cluster

cluster_info_save_to =  'C:\Users\lrako\OneDrive\Documents\mt_sinai\cluster_info_' + string(date);
mkdir(cluster_info_save_to)

 [left_hotspot_cluster_activity,right_hotspot_cluster_activity, ...
    left_hotspot_cluster_num_cnx, right_hotspot_cluster_num_cnx, ...
    left_hotspot_cluster_num_strio, right_hotspot_cluster_num_strio, ...
    left_hotspot_cost_cluster_activity, right_hotspot_cost_cluster_activity, ...
    left_hotspot_cost_cluster_num_cnx, right_hotspot_cost_cluster_num_cnx, ...
    left_hotspot_cost_cluster_num_strio, right_hotspot_cost_cluster_num_strio, ...
    left_strio_cluster_activity, right_strio_cluster_activity, ...
    left_strio_cost_cluster_activity, right_strio_cost_cluster_activity, rew_cluster_table, cost_cluster_table, in_scanner_brain_data] ...
    = da_hotspot_activity_per_cluster(full_db, all_clean_behavior, cluster_info_save_to);

%% viz of cluster v strio/snc/etc activity in scanner using only in scanner clusters

save_to = "C:\Users\lrako\OneDrive\Documents\mt_sinai\in_scanner_clusters_" + string(date);
mkdir(save_to)


run_all_bar_plots(left_hotspot_cluster_activity,right_hotspot_cluster_activity, ...
    left_hotspot_cluster_num_cnx, right_hotspot_cluster_num_cnx, ...
    left_hotspot_cluster_num_strio, right_hotspot_cluster_num_strio, ...
    left_strio_cluster_activity, right_strio_cluster_activity, ...
    left_hotspot_cost_cluster_activity, right_hotspot_cost_cluster_activity, ...
    left_hotspot_cost_cluster_num_cnx, right_hotspot_cost_cluster_num_cnx, ...
    left_hotspot_cost_cluster_num_strio, right_hotspot_cost_cluster_num_strio, ...
    left_strio_cost_cluster_activity, right_strio_cost_cluster_activity, save_to);

%% viz of cluster v strio/snc/etc activity in scanner using in + out of scanner clusters

in_scanner_save_to = "C:\Users\lrako\OneDrive\Documents\mt_sinai\in_scanner_combined_clustering_" + string(date);
mkdir(in_scanner_save_to)

in_scanner_combined_clusters = rew_cluster_table(rew_cluster_table.in_or_out == "in", :);


[left_hotspot_cluster_activity,right_hotspot_cluster_activity, ...
    left_hotspot_cluster_num_cnx, right_hotspot_cluster_num_cnx, ...
    left_hotspot_cluster_num_strio, right_hotspot_cluster_num_strio, ...
     left_strio_cluster_activity, right_strio_cluster_activity] = ...
    plot_out_of_scanner_psychs(in_scanner_brain_data, in_scanner_combined_clusters);

run_all_bar_plots(left_hotspot_cluster_activity,right_hotspot_cluster_activity, ...
    left_hotspot_cluster_num_cnx, right_hotspot_cluster_num_cnx, ...
    left_hotspot_cluster_num_strio, right_hotspot_cluster_num_strio, ...
    left_strio_cluster_activity, right_strio_cluster_activity, ...
    left_hotspot_cost_cluster_activity, right_hotspot_cost_cluster_activity, ...
    left_hotspot_cost_cluster_num_cnx, right_hotspot_cost_cluster_num_cnx, ...
    left_hotspot_cost_cluster_num_strio, right_hotspot_cost_cluster_num_strio, ...
    left_strio_cost_cluster_activity, right_strio_cost_cluster_activity, in_scanner_save_to);



%% viz of cluster v strio/snc/etc activity out of scanner


out_of_scanner_save_to = "C:\Users\lrako\OneDrive\Documents\mt_sinai\out_of_scanner_combined_clustering_" + string(date);
mkdir(out_of_scanner_save_to)

out_scanner_combined_clusters = rew_cluster_table(rew_cluster_table.in_or_out == "out", :);


[left_hotspot_cluster_activity,right_hotspot_cluster_activity, ...
    left_hotspot_cluster_num_cnx, right_hotspot_cluster_num_cnx, ...
    left_hotspot_cluster_num_strio, right_hotspot_cluster_num_strio, ...
     left_strio_cluster_activity, right_strio_cluster_activity] = ...
    plot_out_of_scanner_psychs(in_scanner_brain_data, out_scanner_combined_clusters);


run_all_bar_plots(left_hotspot_cluster_activity,right_hotspot_cluster_activity, ...
    left_hotspot_cluster_num_cnx, right_hotspot_cluster_num_cnx, ...
    left_hotspot_cluster_num_strio, right_hotspot_cluster_num_strio, ...
    left_strio_cluster_activity, right_strio_cluster_activity, ...
    [], [], ...
    [], [], ...
    [], [], ...
    [], [], out_of_scanner_save_to);


%% size of each rew cluster

figure 
gc_in_cluster = groupcounts(in_scanner_combined_clusters, "cluster_idx");
bar(gc_in_cluster.cluster_idx, gc_in_cluster.GroupCount)
ylabel("num pts in cluster")
xlabel("cluster")
title("size of in scanner clusters")
saveas(gcf, cluster_info_save_to+"\inside_cluster_counts.fig")
close

figure 
gc_out_cluster = groupcounts(out_scanner_combined_clusters, "cluster_idx");
bar(gc_out_cluster.cluster_idx, gc_out_cluster.GroupCount)
title("size of out of scanner clusters")
ylabel("num pts in cluster")
xlabel("cluster")
saveas(gcf, cluster_info_save_to+"\outside_cluster_counts.fig")

%clost cluster table counts

cost_in_scanner_table = unique(cost_cluster_table(:, {'cluster_idx', 'participant','cost_a','cost_b','cost_c'}),"rows");

figure 
gc_in_cost_cluster = groupcounts(cost_in_scanner_table, "cluster_idx");
bar(gc_in_cost_cluster.cluster_idx, gc_in_cost_cluster.GroupCount)
title("size of inside of scanner COST clusters")
ylabel("num pts in cluster")
xlabel("cluster")
saveas(gcf, cluster_info_save_to+"\inside_cost_cluster_counts.fig")

%% in scanner rew

in_scanner_combined_clusters = rew_cluster_table(rew_cluster_table.in_or_out == "in", :);

br_activity_vs_psych_parameters(in_scanner_brain_data, in_scanner_combined_clusters, "in scanner rew psychometric funcs: " + string(date))

%% in scanner cost

cost_in_scanner_table = unique(cost_cluster_table(:, {'cluster_idx', 'participant','cost_a','cost_b','cost_c'}),"rows");

br_activity_vs_psych_parameters(in_scanner_brain_data, cost_in_scanner_table, "in scanner cost psychometric funcs: " + string(date))

%% out of scanner rew

out_scanner_combined_clusters = rew_cluster_table(rew_cluster_table.in_or_out == "out", :);

br_activity_vs_psych_parameters(in_scanner_brain_data, out_scanner_combined_clusters, "out of scanner rew psychometric funcs: " + string(date))

%% 

all_snc_strio_table = strio_snc_v_rew_cost_runme(full_db, all_clean_behavior, save_to);

%%

joint_snc_strio_table = [];
for j= 1:length(all_snc_strio_table)
    curr_table = all_snc_strio_table{1, j};
    curr_table.hotspot_activity = mean(curr_table.hotspot_activity, 2,'omitnan' );
    curr_table.left_strio_activity = mean(curr_table.left_strio_activity, 2,'omitnan' );
    curr_table.right_strio_activity = mean(curr_table.right_strio_activity, 2,'omitnan' );
    curr_table.vox_activity = [];
    try
        joint_snc_strio_table = [joint_snc_strio_table; curr_table];
    catch
        continue
    end
end

rew_cluster_table = renamevars(rew_cluster_table, "participant", "subjectidnumber");
all_snc_strio_table_w_clusters = outerjoin(joint_snc_strio_table, rew_cluster_table, "MergeKeys", 1, "Keys", {'subjectidnumber'});


%%

rew_lvl_save_to = "C:\Users\lrako\OneDrive\Documents\mt_sinai\activity_v_lvls_" + string(date);
mkdir(rew_lvl_save_to)

plot_snc_strio_activity_v_rew(all_snc_strio_table, 5, "hotspot_activity", "rew_lvls", rew_lvl_save_to)
plot_snc_strio_activity_v_rew(all_snc_strio_table, 5, "left_strio_activity", "rew_lvls", rew_lvl_save_to)
plot_snc_strio_activity_v_rew(all_snc_strio_table, 5, "right_strio_activity", "rew_lvls", rew_lvl_save_to)


plot_snc_strio_activity_v_rew(all_snc_strio_table, 5, "hotspot_activity", "cost_lvls", rew_lvl_save_to)
plot_snc_strio_activity_v_rew(all_snc_strio_table, 5, "left_strio_activity", "cost_lvls", rew_lvl_save_to)
plot_snc_strio_activity_v_rew(all_snc_strio_table, 5, "right_strio_activity", "cost_lvls", rew_lvl_save_to)


%%
mt_sinai_w_clusters_n_stats = prep_mt_sinai_data_for_combining();
joint_snc_strio_table = renamevars(joint_snc_strio_table,"subjectidnumber", "K01_SUBID");

brain_snc_cluster_table_w_stats = outerjoin(joint_snc_strio_table, mt_sinai_w_clusters_n_stats, "MergeKeys", 1);

%%

all_brain_w_rew_lvls = outerjoin(joint_snc_strio_table, full_db_table, "MergeKeys", 1, "Keys", {'K01_SUBID','int_or_ext','onset_time_step','trial_number','trial_section'});

%% 
brs_of_interest = ["left_caudate_full_striosome_0_thresh"];
types = ["cost_lvls"];
num_bins = 5;
for j = 1:length(types)
    type = types(j);
    plot_brain_activity_per_feature(all_brain_w_rew_lvls, type, brs_of_interest, num_bins, save_to)
end

%%
brs_of_interest = ["Hb_mni_resamp_HEAD"];
types = ["cluster_idx"; "appr_category"; "ent_category"; "ghr_bin"];
num_bins = 4;
for j = 1:length(types)
    type = types(j);
    plot_brain_activity_per_feature(brain_cluster_table_w_stats, type, brs_of_interest, num_bins, save_to)
end

%%
brs_of_interest = ["hotspot_activity"];
types = ["cluster_idx"; "appr_category"; "ent_category"; "ghr_bin"];
num_bins = 4;
for j = 1:length(types)
    type = types(j);
    plot_brain_activity_per_feature(brain_snc_cluster_table_w_stats, type, brs_of_interest, num_bins, save_to)
end