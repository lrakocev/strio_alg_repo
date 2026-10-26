function full_db_table = combine_indiv_brain_activities_into_full_table(full_db)

want_cols = "left_caudate_" + ["downstream_striosome"; "upstream_striosome";...
    "full_matrix"; "refined_matrix"; "lh_striosome"; "full_striosome"; ...
    "snc_striosome_15_idx"; "ups_lh_striosome_5_idx"; "ups_snc_striosome_5_idx"];
want_cols = [want_cols; "onset_time_step"];


full_db_table = [];
for j = 1:length(full_db)
    sub_db = full_db{1,j}{1,1}; 

    sub_activity = full_db{1,j}{1,2};
    unpacked_table = unpack_activity_table(sub_activity, "left_caudate");
    unpacked_table.onset_time_step = [1:height(unpacked_table)]';
    curr_cols = string(unpacked_table.Properties.VariableNames);

   
    if all(ismember(want_cols,curr_cols))
        unpacked_table = unpacked_table(:, want_cols);
    else
        missing_cols = setdiff(want_cols, curr_cols);
        for k = 1:length(missing_cols)
            missing_col = missing_cols{k};
            unpacked_table.(missing_col) = repelem(NaN, height(unpacked_table), 1);
        end

        unpacked_table = unpacked_table(:, want_cols);

    end

    activity_at_action = outerjoin(sub_db, unpacked_table,"MergeKeys",1, "Keys", {'onset_time_step'});
    activity_filled = fillmissing(activity_at_action, 'previous');

    sub_db = define_trial_units_via_events(activity_filled);

    try
        full_db_table = [full_db_table; sub_db];
    catch
        continue
    end
    
        
end

full_db_table = renamevars(full_db_table, "paricipant", "K01_SUBID");

end