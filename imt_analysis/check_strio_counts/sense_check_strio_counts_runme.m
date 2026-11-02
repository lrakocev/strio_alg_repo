dms_name = "left-caudate";

%% strio summary using the txt voxel files

home_vox_dir = "C:/Users/lrako/OneDrive/Documents/mt_sinai/data_from_minerva/copy_strio_vox_1022";

regions_to_load = ["downstream_striosome"; "upstream_striosome";...
    "full_matrix"; "refined_matrix"; "lh_striosome"; "snc_striosome";...
    "full_striosome"; "ups_lh_striosome_10_idx"; "ups_snc_striosome_10_idx"];

strio_summary_from_txt_table = apply_func_to_all_subject_data(@get_br_activity_from_vox_txt,...
    home_vox_dir, dms_name, regions_to_load);

%% strio summary using the striosomality scoring per roi

home_striosomalities_dir = 'C:\Users\lrako\OneDrive\Documents\mt_sinai\subject_viz_mat_091026\mat_copy_to_local_091026';

strio_summary_from_scores_table = apply_func_to_all_subject_data(@get_strio_summary_via_strio_scores, home_striosomalities_dir, ...
    dms_name);

strio_summary_from_scores_table = get_percent_strio_of_sttm_table(strio_summary_from_scores_table);

%% post ghr analysis strio check

want_cols = "left_caudate_" + ["downstream_striosome_0_thresh"; "upstream_striosome_0_thresh";...
    "full_striosome_0_thresh"];
strio_ghr_table = check_strio_count_post_ghr_analysis(brain_cluster_table_w_stats, want_cols);

%% check distributions of outputs

mt_sinai_w_clusters_n_stats = prep_mt_sinai_data_for_combining();
plot_col = "left_caudate_downstream_striosome";
[histogram_output_table] = plot_distributions_before_stats(mt_sinai_w_clusters_n_stats, brain_cluster_table_w_stats, plot_col);

check_strio_table = outerjoin(histogram_output_table, strio_summary_from_scores_table, 'MergeKeys', 1, "Key", {'subj_id'});
