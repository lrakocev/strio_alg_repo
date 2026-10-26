num_hormone_bins = 4;
br_names= ["both_strio_together";"left_caudate_downstream_striosome_nii";"left_caudate_upstream_striosome_nii"]; 

hormone_type = "ghr_bin"; 

for i = 1:length(br_names)
    br_name = br_names(i);

    figure
    br_bars = [];
    br_errs = [];
    labels = [];
    for j = 1:4
        for k = 1:4
            hormone_cluster_table = brain_cluster_table(brain_cluster_table.(hormone_type) == k & brain_cluster_table.cluster_idx == j, :);
            
            try
                act_list = hormone_cluster_table.(br_name);
                act_list = act_list(act_list ~= 0, :);
                avg_br_act = mean(act_list, "omitnan");
            catch
                % some of the rows are strings - just including the mean in this block
                % so it flags as an error
                act_list = str2double(hormone_cluster_table.(br_name));
                act_list = act_list(act_list ~= 0, :);
                avg_br_act = mean(act_list, "omitnan");
            end
        labels = [labels; "cluster: " + j + ", ghr bin: " + k];
        serr_br_act = std(act_list, "omitnan") / sqrt(num_unique_subs);
        br_bars = [br_bars; avg_br_act];
        br_errs = [br_errs; serr_br_act];
        end

    end
    
    try
        errorbar(1:length(labels), br_bars, br_errs)
        title("activity of " + br_name + " across whole trial for combo of ghr level and cluster idx" )
        xlabel("ghr + cluster combo")
        xticks(1:length(br_bars))
        xticklabels(labels)
        ylabel(curr_br + " avg activity lvl")
    catch
        continue
    end
end

