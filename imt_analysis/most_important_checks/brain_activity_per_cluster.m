%% prelim analysis of mt sinai brain activity per cluster

%load("all_vox_activity_10222026.mat")

types = ["full_striosome_0_thresh"; "upstream_striosome_0_thresh"; "downstream_striosome_0_thresh"; "resamp"];

want_cols =["left_caudate_" + types; "right_caudate_" + types; "Hb_mni_resamp_HEAD"; "final_SN_resamp_HEAD"];
full_db_table = combine_indiv_brain_activities_into_full_table(full_db, want_cols);


%%
mt_sinai_w_clusters_n_stats = prep_mt_sinai_data_for_combining();
brain_cluster_table_w_stats = outerjoin(full_db_table, mt_sinai_w_clusters_n_stats, "MergeKeys", 1);

%% summary stats about clusters

 plot_cluster_spread_summary(brain_cluster_table_w_stats)

%% hormones per cluster

plot_hormone_vs_cluster(mt_sinai_w_clusters_n_stats)

%% post ghr analysis strio check

brs_of_interest =  ["full_striosome_0_thresh"; "upstream_striosome_0_thresh"; "downstream_striosome_0_thresh"; "resamp"]; % "resamp"];
want_cols = ["left_caudate_" + brs_of_interest; "right_caudate_" + brs_of_interest; "both_hemisphere_full_striosome_0_thresh"]; 
strio_ghr_table = check_strio_count_post_ghr_analysis(brain_cluster_table_w_stats, want_cols);

strio_ghr_table_only_ghr = strio_ghr_table(~isnan(strio_ghr_table.ghr_lvl), :);

subs_w_strio_and_ghr = strio_ghr_table_only_ghr(~isnan(strio_ghr_table_only_ghr.left_caudate_full_striosome_0_thresh_act), :).K01_SUBID;
subs_w_strio = strio_ghr_table(~isnan(strio_ghr_table.left_caudate_full_striosome_0_thresh_act), :).K01_SUBID;


%% brain activity per cluster

save_to = "C:\Users\lrako\OneDrive\Documents\mt_sinai\brain_activity_output";
mkdir(save_to)
num_bins = 4;
want_cols = ["left_caudate_" + brs_of_interest]; % "right_caudate_" + brs_of_interest; "both_hemisphere_full_striosome_0_thresh"]; 

type = "cluster_idx"; % "appr_category" % "ent_category";

%%this is saved for STRIOSOMAL ANALYSIS
brain_cluster_table_w_no_nan_strio = brain_cluster_table_w_stats(ismember(brain_cluster_table_w_stats.K01_SUBID, subs_w_strio), :);
brain_cluster_table_w_no_nan_ghr = brain_cluster_table_w_stats(ismember(brain_cluster_table_w_stats.K01_SUBID, subs_w_strio_and_ghr), :);
%plot_brain_activity_per_feature(brain_cluster_table_w_stats, type, want_cols, num_bins, save_to)
plot_brain_activity_v_hormone(brain_cluster_table_w_no_nan_strio, want_cols, num_bins, save_to)
