%% brain activity dbs

%load("all_vox_activity_1022026.mat")
load("all_clean_behavior.mat")

full_db_table = combine_indiv_brain_activities_into_full_table(full_db);
[healthies, mdds, ext_only_behavior_and_brain] = join_behavior_to_brain_table(full_db_table, all_clean_behavior);

%% brain maps

rois = ["upstream_striosome_nii", "downstream_striosome_nii", "left_caudate", "final_SN"];
get_brain_maps(ext_only_behavior_and_brain, "old_overall", rois);
get_brain_maps(ext_healthies, "old_healthies", rois)
get_brain_maps(ext_mdds, "old_mdds", rois)

get_brain_maps(behavior_and_brain, "overall", rois);
get_brain_maps(healthies, "healthies", rois)
get_brain_maps(mdds, "mdds", rois)

%% reward/cost lvls

save_to = "C:\Users\lrako\OneDrive\Documents\mt_sinai\rew_cost_anova_" + string(date) + "\";
mkdir(save_to)
roi = "left_caudate_downstream_striosome_nii";

[num_subs, subject_lvl_rs_downstream] = comparison_btwn_rew_lvls(ext_only_behavior_and_brain, ...
    [], [], roi, "rew_lvls", save_to, "behavior_and_brain_no_down_zeros");
comparison_btwn_rew_lvls(ext_only_behavior_and_brain, ...
    [], [], roi, "cost_lvls", save_to, "behavior_and_brain_no_down_zeros")

%% DISCRIMINATION IE D'

num_lvls = 5;
rois = ["left_caudate_upstream_striosome_nii", "left_caudate_downstream_striosome_nii"];
plot_discrimination_v_activity(ext_only_behavior_and_brain, rois, num_lvls)


%% bar plots of complexities

rois = ["left_caudate_upstream_striosome_nii", "left_caudate_downstream_striosome_nii", "left_caudate"];
get_bar_complexities(ext_only_behavior_and_brain, "overall", rois)

get_bar_complexities(healthies, "healthies", rois)
get_bar_complexities(mdds, "mdds", rois)


%% clustering in scanner data

save_to = pwd + "\in_scanner_cluster\";
mkdir(save_to)

[rew_cluster_table, cost_cluster_table] = cluster_in_scanner_psychs(mdds, 8, 6, save_to);
