function get_bar_complexities(desired_table, brain_subdir, rois)

save_to = pwd + "\complexity_bars\" + brain_subdir;
mkdir(save_to)


desired_table.complexity_bins = discretize(abs(desired_table.complexity), 4);

complexity_vals = unique(desired_table.complexity_bins);
for r = 1:length(rois)
    br_act = rois(r);


    if isa(desired_table.(br_act),'string')
        non_string_version = str2double(desired_table.(br_act));
        desired_table.(br_act) = non_string_version;
    end


    mean_acts = [];
    std_acts = [];
    for j = 1:length(complexity_vals)
        curr_complexity = complexity_vals(j);
        curr_complexity_table = desired_table(desired_table.complexity_bins == curr_complexity, :);
    
        unique_subjects = length(unique(curr_complexity_table.participant));
    
        activity = curr_complexity_table.(br_act);
        avg_val = mean(activity, 'omitnan');
        std_val = std(activity,'omitnan') / sqrt(sum(~isnan(unique_subjects)));

        mean_acts = [mean_acts; avg_val];
        std_acts = [std_acts; std_val];
    
    end

    figure
    errorbar(1:length(complexity_vals), mean_acts, std_acts)
    title(br_act + " across [basic] lvls of complexity")
    xlabel("complexity")
    ylabel(br_act + " activity")
    saveas(gcf,strcat(save_to, "\", br_act, "_across_complexity.fig"))
    close all
   

end

end
