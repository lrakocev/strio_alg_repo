function strio_ghr_table = check_strio_count_post_ghr_analysis(brain_cluster_table_w_stats, input_cols)

strio_ghr_table = [];
unique_subs = unique(brain_cluster_table_w_stats.K01_SUBID);
for j = 1:length(unique_subs)
    curr_id = string(unique_subs(j));
    sub_table = brain_cluster_table_w_stats(brain_cluster_table_w_stats.K01_SUBID == curr_id, :);

    if ~isempty(sub_table.onset_in_seconds(1))

        for k = 1:length(input_cols)
            col_name = input_cols(k);
            col_activity = mean(sub_table.(col_name),'omitnan');
            row.(col_name + "_act") = col_activity;
        end
       
        ghr_lvl = mean(sub_table.aGHR,'omitnan');
    
        row.K01_SUBID = curr_id;
        row.ghr_lvl = ghr_lvl;
    
        strio_ghr_table = [strio_ghr_table; row];
    else
        continue
    end

end

strio_ghr_table = struct2table(strio_ghr_table);
%writetable(strio_ghr_table, "strio_activity_per_ghr_lvl.xlsx")


end