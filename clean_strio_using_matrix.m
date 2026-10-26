function [clean_down_strio_activity, clean_up_strio_activity] = clean_strio_using_matrix(activity_table, dms_name)

matrix_coord_col = dms_name + "_refined_matrix_coords";
down_strio_coord_col = dms_name + "_downstream_striosome_coords";
up_strio_coord_col = dms_name + "_upstream_dstriosome_coords";

down_strio_activity_col = dms_name + "_downstream_striosome_vox";
up_strio_activity_col = dms_name + "_upstream_dstriosome_vox";

matrix_coords = activity_table.(matrix_coord_col){1,1};
down_strio_coords = activity_table.(down_strio_coord_col){1,1};
down_strio_activity = activity_table.(down_strio_activity_col){1,1};
[clean_down_strio_activity, ~] = remove_bad_coords(matrix_coords, down_strio_coords, down_strio_activity);

try
    up_strio_coords = activity_table.(up_strio_coord_col){1,1};
    up_strio_activity = activity_table.(up_strio_activity_col){1,1};
    [clean_up_strio_activity, ~] = remove_bad_coords(matrix_coords, up_strio_coords, up_strio_activity);
catch
    clean_up_strio_activity = [];
    return
end

end

function [clean_activity, avg_clean] = remove_bad_coords(bad_coords, coords_to_clean, activity)

bad_in_good = intersect(coords_to_clean, bad_coords, 'rows');

idx_good = find(~ismember(coords_to_clean, bad_in_good, 'rows'));
clean_activity = activity(idx_good, :);

avg_clean = mean(clean_activity, 'omitnan');
end