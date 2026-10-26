function [left_strio_activity_w_trial_lvls, right_strio_activity_w_trial_lvls, snc_activity_w_trial_lvls, left_strio_snc_hotspots, ...
    right_strio_snc_hotspots, left_strio_vox_ext_only, right_strio_vox_ext_only, left_hotspot_activity, right_hotspot_activity] = ...
    da_hotspot_activity_per_subject(subj_event_table, subj_vox_table, all_clean_behavior)

% setup - getting relevant activity + coords
[left_downstream_strio_activity, left_downstream_strio_coords] = remove_empty_vox_helper(subj_vox_table.downstream_striosome_nii_vox{1,1}, ...
    subj_vox_table.downstream_striosome_nii_coords{1,1});

[right_downstream_strio_activity, right_downstream_strio_coords] = ...
    remove_empty_vox_helper(subj_vox_table.right_caudate_downstream_striosome_nii_vox{1,1},...
    subj_vox_table.right_caudate_downstream_striosome_nii_coords{1,1});

[snc_activity, snc_coords] = remove_empty_vox_helper(subj_vox_table.final_SN_vox{1,1}, ...
    subj_vox_table.final_SN_coords{1,1});

left_caudate_coords = subj_vox_table.left_caudate_coords{1,1};
right_caudate_coords = subj_vox_table.right_caudate_coords{1,1};

% merge behavior with trial data

[left_strio_activity_w_trial_lvls_ext, left_strio_activity_w_trial_lvls,  left_strio_table] = merge_activity_w_trials(all_clean_behavior, subj_event_table, left_downstream_strio_activity);
[right_strio_activity_w_trial_lvls_ext, right_strio_activity_w_trial_lvls, right_strio_table] = merge_activity_w_trials(all_clean_behavior, subj_event_table, right_downstream_strio_activity);
[snc_activity_w_trial_lvls_ext, snc_activity_w_trial_lvls, snc_table] = merge_activity_w_trials(all_clean_behavior, subj_event_table, snc_activity);


% get high corr vox + hotspot activity
corr_thresh = 0.15;
[left_strio_snc_hotspots, left_hotspot_activity] = get_high_corr_snc_vox(left_strio_table, ...
    snc_table, corr_thresh);
[right_strio_snc_hotspots, right_hotspot_activity] = get_high_corr_snc_vox(right_strio_table,...
    snc_table, corr_thresh);


left_strio_vox_ext_only = left_strio_activity_w_trial_lvls_ext.vox_activity;
right_strio_vox_ext_only = right_strio_activity_w_trial_lvls_ext.vox_activity;
end

