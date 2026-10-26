function plot_snc_strio_activity_v_rew(all_sub_snc_activity, num_lvls, col_name, rew_or_cost, save_to)

activity_per_lvl = cell(1, num_lvls);

for l = 1:num_lvls
    for j = 1:length(all_sub_snc_activity)
        curr_sub_activity = all_sub_snc_activity{j};

        if ~isempty(curr_sub_activity)
            subj_lvl_table = curr_sub_activity(curr_sub_activity.(rew_or_cost) == l, :);
            subj_lvl_activity = subj_lvl_table.(col_name);

            normed_per_vox_subj_lvl_activity = zscore(subj_lvl_activity);

            mean_activity_at_lvl = mean(normed_per_vox_subj_lvl_activity, 'all', 'omitnan');

            activity_per_lvl{l} = [activity_per_lvl{l}; mean_activity_at_lvl];

        end
        
    end
end
    

bar_plot_helper(activity_per_lvl, "z_scored " + col_name + "_across_" + rew_or_cost, col_name, rew_or_cost + " lvls", save_to)

end