function all_sub_snc_activity = strio_snc_v_rew_cost_runme(full_db, all_clean_behavior, save_to)

if isempty(full_db)
    load("all_vox_activity_all_subjects.mat")
end

if isempty(all_clean_behavior)
    [all_clean_behavior, ~] = get_clean_behavior();
end


counter = 1;
all_sub_snc_activity = {};
for j = 1:length(full_db)
    curr_subj_data = full_db{1,j};

    subj_event_table = curr_subj_data{1,1};
    subj_vox_table = curr_subj_data{1,2};

    subjectidnumber = str2double(subj_event_table.paricipant(1));

    try
        [left_strio_activity_w_trial_lvls, right_strio_activity_w_trial_lvls, snc_activity_w_trial_lvls, left_strio_snc_hotspots,...
            right_strio_snc_hotspots, left_strio_activity_ext_only, right_strio_activity_ext_only] = ...
        da_hotspot_activity_per_subject(subj_event_table, subj_vox_table, all_clean_behavior);
    
        all_snc_activity = snc_activity_w_trial_lvls.vox_activity;
    
        left_and_right_snc_hotspot_vox = unique([left_strio_snc_hotspots; right_strio_snc_hotspots]);
        hotspot_activity = all_snc_activity(:, left_and_right_snc_hotspot_vox);
    
        snc_activity_w_trial_lvls.hotspot_activity = hotspot_activity;
        snc_activity_w_trial_lvls.left_strio_activity = left_strio_activity_w_trial_lvls.vox_activity;
        snc_activity_w_trial_lvls.right_strio_activity = right_strio_activity_w_trial_lvls.vox_activity;

        all_sub_snc_activity{counter} = snc_activity_w_trial_lvls;
        counter = counter + 1;
    catch
        continue
    end

end

end