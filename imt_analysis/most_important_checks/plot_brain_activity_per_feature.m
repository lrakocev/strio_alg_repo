function plot_brain_activity_per_feature(br_activity_table, type, brs_of_interest, num_categories, save_to)
 
for i = 1:length(brs_of_interest)
    curr_br = brs_of_interest{i};

    figure
    br_bars = [];
    br_errs = [];
    for m = 1:num_categories
        measure_lvl_table = br_activity_table(br_activity_table.(type) == m, :);
        num_unique_subs = length(unique(measure_lvl_table.K01_SUBID));
        try
            act_list = measure_lvl_table.(curr_br);
            act_list = act_list(act_list ~= 0, :);
            avg_br_act = mean(act_list, "omitnan");
        catch
            % some of the rows are strings - just including the mean in this block
            % so it flags as an error
            act_list = str2double(measure_lvl_table.(curr_br));
            act_list = act_list(act_list ~= 0, :);
            avg_br_act = mean(act_list, "omitnan");
        end
        serr_br_act = std(act_list, "omitnan") / sqrt(num_unique_subs);
        br_bars = [br_bars; avg_br_act];
        br_errs = [br_errs; serr_br_act];
    end
    try
        errorbar(1:num_categories, br_bars, br_errs)
        xlabel("bins of " + type )
        ylabel(curr_br + " activity lvl")
        title("avg activity of " + curr_br + " vs " + type)
        subtitle("using plot_brain_activity_per_cluster.m")
        saveas(gcf, save_to + "/" + string(date) + "/" + curr_br + "_v_" + type, ".fig")
        saveas(gcf, save_to + "/" + string(date) + "/" + curr_br + "_v_" + type, ".svg")
    catch
        continue
    end
end