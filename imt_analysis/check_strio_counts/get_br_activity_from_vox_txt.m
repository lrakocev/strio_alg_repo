function row = get_br_activity_from_vox_txt(subj_id, home_vox_dir, dms_name, regions_to_load)

voxel_dir = home_vox_dir + "/" + subj_id + "/";

all_subjects = [subj_id];
use_cross_corr = 0;
strio_filename = "striosome_projection_rankings_v1.xlsx";

regions_to_load =  dms_name + "_" + regions_to_load;
regions_to_load = [regions_to_load; dms_name + "_resamp"];

[processed_activities, cross_corrs, strio_projecting_regions, matrix_projecting_regions, brain_region_names, voxel_ref, rankings] = ...
    process_input_data(voxel_dir, all_subjects, use_cross_corr, dms_name, strio_filename, regions_to_load);


row.K01_SUBID = subj_id;
br_names = brain_region_names{1,1};
for j = 1:length(br_names)
    curr_br = br_names{j};

    curr_br = replace(curr_br, "-", "_");
    curr_br = replace(curr_br, "+orig", "");

    curr_activity = processed_activities{1,1}{1,j};
    row_sum = sum(curr_activity,2);
    curr_activity = curr_activity(row_sum ~= 0, :);
    row.(curr_br) = mean(curr_activity, "all", 'omitnan');
    row.(curr_br + "_num_vox") = size(curr_activity,1);
end

row = struct2table(row);

col_names = string(row.Properties.VariableNames);

regions_to_load_replaced = replace(regions_to_load, "-", "_");
if ~all(ismember(regions_to_load_replaced,col_names))
    missing_cols = setdiff(regions_to_load_replaced, col_names);
    for k = 1:length(missing_cols)
        missing_col = missing_cols{k};
        row.(missing_col) = NaN;
        row.(missing_col + "_num_vox") = NaN;

    end

end

desired_cols = ["K01_SUBID"];
for d = 1:length(regions_to_load_replaced)
    desired_cols = [desired_cols; regions_to_load_replaced(d) ; regions_to_load_replaced(d) + "_num_vox"];
end

row = row(:, desired_cols);
end