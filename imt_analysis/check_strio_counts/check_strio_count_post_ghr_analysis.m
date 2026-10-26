function strio_ghr_table = check_strio_count_post_ghr_analysis(brain_cluster_table_w_stats)

strio_ghr_table = [];
unique_subs = unique(brain_cluster_table_w_stats.K01_SUBID);
for j = 1:length(unique_subs)
    curr_id = string(unique_subs(j));
    sub_table = brain_cluster_table_w_stats(brain_cluster_table_w_stats.K01_SUBID == curr_id, :);

    if ~isempty(sub_table.onset_in_seconds(1))
        upstream_strio_act = mean((sub_table.left_caudate_upstream_striosome),'omitnan');
        downstream_strio_act = mean((sub_table.left_caudate_downstream_striosome),'omitnan');
        full_strio_act = mean((sub_table.left_caudate_downstream_striosome),'omitnan');
        ref_matrix_act = mean((sub_table.left_caudate_refined_matrix),'omitnan');

        ghr_lvl = mean(sub_table.aGHR,'omitnan');
    
        row.K01_SUBID = curr_id;
        row.upstream_strio_act = upstream_strio_act;
        row.downstream_strio_act = downstream_strio_act;        
        row.full_strio_act = full_strio_act;
        row.ref_matrix_act = ref_matrix_act;

        row.ghr_lvl = ghr_lvl;
    
        strio_ghr_table = [strio_ghr_table; row];
    else
        continue
    end

end

strio_ghr_table = struct2table(strio_ghr_table);
%writetable(strio_ghr_table, "strio_activity_per_ghr_lvl.xlsx")


end