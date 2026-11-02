function full_db_table = combine_indiv_brain_activities_into_full_table(full_db, want_cols)

want_cols = [want_cols; "onset_time_step"; "clean_down_strio"; "clean_up_strio"; "both_hemisphere_full_striosome_0_thresh"];

full_db_table = [];
for j = 1:length(full_db)
    sub_db = full_db{1,j}{1,1}; 

    sub_activity = full_db{1,j}{1,2};

    unpacked_table = unpack_activity_table(sub_activity, "left_caudate");
    unpacked_table.onset_time_step = [1:height(unpacked_table)]';
    curr_cols = string(unpacked_table.Properties.VariableNames);

    if all(ismember(["left_caudate_full_striosome_0_thresh","right_caudate_full_striosome_0_thresh"], curr_cols))
        unpacked_table.both_hemisphere_full_striosome_0_thresh = median([sub_activity.left_caudate_full_striosome_0_thresh_vox{1,1} ; ...
    sub_activity.right_caudate_full_striosome_0_thresh_vox{1,1}], 'omitnan')';
    elseif ismember("left_caudate_full_striosome_0_thresh", curr_cols)
        unpacked_table.both_hemisphere_full_striosome_0_thresh = unpacked_table.left_caudate_full_striosome_0_thresh;
    elseif ismember("right_caudate_full_striosome_0_thresh", curr_cols)
        unpacked_table.both_hemisphere_full_striosome_0_thresh = unpacked_table.right_caudate_full_striosome_0_thresh;
    end

    updated_curr_cols = string(unpacked_table.Properties.VariableNames);

    if all(ismember(want_cols,updated_curr_cols))
        unpacked_table = unpacked_table(:, want_cols);
    else
        missing_cols = setdiff(want_cols, updated_curr_cols);
        for k = 1:length(missing_cols)
            missing_col = missing_cols{k};
            unpacked_table.(missing_col) = repelem(NaN, height(unpacked_table), 1);
        end

        unpacked_table = unpacked_table(:, want_cols);

    end

    activity_at_action = outerjoin(sub_db, unpacked_table,"MergeKeys",1, "Keys", {'onset_time_step'});
    activity_filled = fillmissing(activity_at_action, 'previous');

    sub_db = define_trial_units_via_events(activity_filled);

    full_db_table = [full_db_table; sub_db];
end

full_db_table = renamevars(full_db_table, "paricipant", "K01_SUBID");

end