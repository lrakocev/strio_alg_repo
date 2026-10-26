function br_activity_vs_psych_parameters(in_scanner_brain_data, psych_table, tit_str)

psych_table = renamevars(psych_table, "participant", "subjectidnumber");
in_and_out_joined = outerjoin(in_scanner_brain_data, psych_table, "MergeKeys", 1, "Keys", {'subjectidnumber'});

in_and_out_joined = in_and_out_joined(~isnan(in_and_out_joined.cluster_idx), :);

cols_of_interest = ["left_hotspot_cluster_activity"; "right_hotspot_cluster_activity"; "left_strio_cost_cluster_activity"; ...
    "right_strio_cost_cluster_activity"; "left_hotspot_cluster_num_cnx"; "right_hotspot_cluster_num_cnx"; ...
    "left_hotspot_cost_cluster_num_strio"; "right_hotspot_cost_cluster_num_strio"];
params = ["rew_a", "rew_b", "rew_c", "cost_a", "cost_b", "cost_c"];

for j = 1:length(params)
    curr_param = params(j);

    for k = 1:length(cols_of_interest)
        curr_col = cols_of_interest(k);
        
        try
            col_data = in_and_out_joined.(curr_col);
            param_data = log(abs(in_and_out_joined.(curr_param))); % .* sign(in_and_out_joined.(curr_param));
            figure
    
            mdl = fitlm(param_data, col_data);

            r_sq = mdl.Rsquared.Ordinary;
            plot(mdl)
            hold on
    
            scatter(param_data, col_data)
            title(curr_param + " vs " + curr_col + " for " + tit_str + " with r-sq: " + r_sq)
            xlabel(curr_param)
            ylabel(curr_col)
        catch
            continue
        end

            
    end
end

end