function strio_activity_table = get_percent_strio_of_sttm_table(strio_activity_table)

strio_types = strio_activity_table.Properties.VariableNames;
strio_vox_counts = strio_types(contains(strio_types, "num_vox"));

figure
for j = 1:length(strio_vox_counts)
    col_name = strio_vox_counts{j};

    pct_col_name = col_name + "_percent";
    strio_activity_table.(pct_col_name) = strio_activity_table.(col_name) ./ strio_activity_table.left_caudate_resamp_num_vox;

    to_plot = strio_activity_table.(pct_col_name)(strio_activity_table.(pct_col_name)  <= 1, :);
    nexttile
    histogram(to_plot,10)
    xlim([0 1])
    xlabel(pct_col_name)
    ylabel("number of subjects")
    hold on
    
end

end