%% prelim analysis of mt sinai brain activity per cluster

load("all_vox_activity_10222026.mat")

full_db_table = combine_indiv_brain_activities_into_full_table(full_db);
mt_sinai_w_clusters_n_stats = prep_mt_sinai_data_for_combining();
brain_cluster_table_w_stats = outerjoin(full_db_table, mt_sinai_w_clusters_n_stats, "MergeKeys", 1);

%% summary stats about clusters

 plot_cluster_spread_summary(brain_cluster_table_w_stats)

%% hormones per cluster

plot_hormone_vs_cluster(mt_sinai_w_clusters_n_stats)

%% brain activity per cluster

save_to = "C:\Users\lrako\OneDrive\Documents\mt_sinai\brain_activity_output";
num_bins = 4;
brs_of_interest = ["left_caudate_full_striosome";"left_caudate_refined_matrix"];
type = "cluster_idx"; % "appr_category" % "ent_category";
plot_brain_activity_per_feature(brain_cluster_table_w_stats, type, brs_of_interest, num_bins, save_to)
plot_brain_activity_v_hormone(brain_cluster_table_w_stats, brs_of_interest, num_bins, save_to)