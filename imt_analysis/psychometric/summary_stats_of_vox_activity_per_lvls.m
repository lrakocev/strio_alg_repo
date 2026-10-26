function summary_stats_of_vox_activity_per_lvls(input_table, rew_or_cost, trial_event, hotspot_vox)

event_table = input_table(input_table.trial_section == trial_event, :);

num_lvls = unique(event_table.(rew_or_cost));

entropies = [];
means = [];
stds = [];
for j = 1:length(num_lvls)
    curr_lvl = num_lvls(j);

    lvl_table = event_table(event_table.(rew_or_cost) == curr_lvl, :);

   
    lvl_activity = lvl_table.vox_activity;

    if ~isempty(hotspot_vox)
        lvl_activity = lvl_activity(:,hotspot_vox);
    end

    no_nan_activity = lvl_activity(~isnan(lvl_activity));

    lvl_ent = -sum(no_nan_activity .* log2(no_nan_activity), 'omitnan');

    lvl_mean = mean(lvl_activity, "all", "omitnan");
    lvl_std = mean(std(lvl_activity, [], 'omitmissing')) / sqrt(height(lvl_table));

    entropies = [entropies; lvl_ent];
    means = [means; lvl_mean];
    stds = [stds; lvl_std];


end

if isempty(hotspot_vox)
    which_vox = join(string(hotspot_vox), ", ");
else
    which_vox = "hotspot";
end

figure
bar(1:length(num_lvls), entropies)
xlabel(rew_or_cost)
ylabel("entropy of " + which_vox + " vox activity for period " + trial_event)
title("entropy of " + which_vox + " voxel activity per " + rew_or_cost + " during " + trial_event)

figure 
%bar(1:length(num_lvls), means)
hold on
errorbar(1:length(num_lvls), means, stds)
xlabel(rew_or_cost)
ylabel("mean activity of " + which_vox + " vox for period " + trial_event)
title("mean of " + which_vox + " vox activity per " + rew_or_cost + " during " + trial_event)
 

end