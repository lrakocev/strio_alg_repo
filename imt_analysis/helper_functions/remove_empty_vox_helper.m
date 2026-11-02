function [no_zero_activity, no_zero_coords] = remove_empty_vox_helper(all_activity, all_coords)

[remove_repeat_coords, unique_rows] = unique(all_coords, "rows", "stable");

remove_repeat_activity = all_activity(unique_rows, :);

no_zero_activity = remove_repeat_activity(sum(remove_repeat_activity,2) ~= 0, :);
no_zero_idx = find(sum(remove_repeat_activity,2) ~= 0);

no_zero_coords = remove_repeat_coords(no_zero_idx, :);

end