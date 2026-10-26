function plot_discrimination_v_activity(ext_only_behavior_and_brain, rois, num_lvls)

ext_only_behavior_and_brain.discrete_rew_r2 = discretize(ext_only_behavior_and_brain.rew_r2, 5);
ext_only_behavior_and_brain.discrete_cost_r2 = discretize(ext_only_behavior_and_brain.cost_r2,5);

plot_table = ext_only_behavior_and_brain(ext_only_behavior_and_brain.rew_r2 > 0, :);

cost_disc = [];
rew_disc = [];

for r = 1:length(rois)
    roi = rois(r);

    rew_disc = [];
    cost_disc = [];
    for j = 1:num_lvls
        rew_disc_table = plot_table(plot_table.discrete_rew_r2 == j, :);
        cost_disc_table = plot_table(plot_table.discrete_cost_r2 == j, :);
    
        rew_data = rew_disc_table.(roi);
        cost_data = cost_disc_table.(roi);

        if isstring(rew_data)
            rew_data = str2double(rew_data);
        end

        if isstring(cost_data)
            cost_data = str2double(cost_data);
        end

        mean_r_d = mean(rew_data, 'omitnan'); 
        mean_c_d = mean(cost_data, 'omitnan'); 
    
        cost_disc = [cost_disc; mean_c_d];
        rew_disc = [rew_disc; mean_r_d];
    
    end

    figure
    bar(1:num_lvls, rew_disc)
    title(roi + " across rew r2 on " + string(date) + " using behavioral_in_scanner_data")
    xlabel("r2 in rew psych")
    ylabel(roi + " activity")
    
    figure
    bar(1:num_lvls, cost_disc)
    title(roi + " across cost r2 on " + string(date) + " using behavioral_in_scanner_data")
    xlabel("r2 in cost psych")
    ylabel(roi + " activity")
end
