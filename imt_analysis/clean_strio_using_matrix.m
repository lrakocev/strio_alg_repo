function [clean_down_strio_activity, clean_up_strio_activity] = clean_strio_using_matrix(activity_table, dms_name)

matrix_coord_col = dms_name + "_refined_matrix_coords";
down_strio_coord_col = dms_name + "_downstream_striosome_0_thresh_coords";
up_strio_coord_col = dms_name + "_upstream_striosome_0_thresh_coords";

down_strio_activity_col = dms_name + "_downstream_striosome_0_thresh_vox";
up_strio_activity_col = dms_name + "_upstream_striosome_0_thresh_vox";

try
    matrix_coords = activity_table.(matrix_coord_col){1,1};

    down_strio_coords = activity_table.(down_strio_coord_col){1,1};
    down_strio_activity = activity_table.(down_strio_activity_col){1,1};
    [clean_down_strio_activity, avg_clean_down] = remove_bad_coords(matrix_coords, down_strio_coords, down_strio_activity);
catch
    clean_down_strio_activity = [];
end

try
    up_strio_coords = activity_table.(up_strio_coord_col){1,1};
    up_strio_activity = activity_table.(up_strio_activity_col){1,1};
    [clean_up_strio_activity, avg_clean_up] = remove_bad_coords(matrix_coords, up_strio_coords, up_strio_activity);
catch
    clean_up_strio_activity = [];
end

end

function [clean_activity, avg_clean] = remove_bad_coords(bad_coords, coords_to_clean, activity)

bad_in_good = intersect(coords_to_clean, bad_coords, 'rows');

idx_good = find(~ismember(coords_to_clean, bad_in_good, 'rows'));
clean_activity = activity(idx_good, :);

avg_clean = mean(clean_activity,'all', 'omitnan');
end