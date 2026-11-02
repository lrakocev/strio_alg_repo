function [activity_w_trial_lvls_ext, activity_w_trial_lvls, activity_for_corr] = merge_activity_w_trials(all_clean_behavior, subj_event_table, input_activity)

activity_table.vox_activity = input_activity';
activity_table.onset_time_step = [1:size(input_activity,2)]';
activity_table = struct2table(activity_table);

activity_at_action = outerjoin(subj_event_table, activity_table, "MergeKeys",1, "Keys", {'onset_time_step'});
activity_filled = fillmissing(activity_at_action, 'previous');

activity_filled = renamevars(activity_filled, ["paricipant"],["subjectidnumber"]);
activity_filled = define_trial_units_via_events(activity_filled);

all_clean_behavior = renamevars(all_clean_behavior, "trials_3_thisN", "trial_number");

all_clean_behavior.condition = string(all_clean_behavior.condition);
all_clean_behavior.participant = string(all_clean_behavior.participant);

all_clean_behavior = renamevars(all_clean_behavior, ["participant"],["subjectidnumber"]);

all_clean_behavior_sub = all_clean_behavior(:, {'subjectidnumber','trial_number','rew_lvls','cost_lvls','response_ext','line_pos_int'});

activity_w_trial_lvls = outerjoin(all_clean_behavior_sub, activity_filled, "MergeKeys", 1, "Keys",{'subjectidnumber','trial_number'});

activity_w_trial_lvls = activity_w_trial_lvls(~isnan(activity_w_trial_lvls.onset_time_step) & ...
    ~isnan(activity_w_trial_lvls.rew_lvls), :);

activity_w_trial_lvls_ext = activity_w_trial_lvls(activity_w_trial_lvls.int_or_ext == "ext", :);


% separately for the correlations (needs to be oriented per voxel not
% timestep)
activity_for_corr.vox_activity = input_activity;
activity_for_corr.cluster_idx = [1:size(input_activity,1)]';
activity_for_corr = struct2table(activity_for_corr);

end