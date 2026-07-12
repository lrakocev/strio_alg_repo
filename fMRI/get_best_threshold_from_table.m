function [thresh_table, best_combo, sorted_combos] = get_best_threshold_from_table(brain_region_names, voxel_ref, valid_combos, strio_filename)

br_names = brain_region_names{1,1};
dms_index = find(br_names=='left-caudate');

[~, strio_projecting_regions, matrix_projecting_regions,~,...
    ~] = load_striosome_projecting_rankings(strio_filename, brain_region_names);

is_mem_strio = ismember(br_names,  string(strio_projecting_regions));
strio_ids = find(is_mem_strio);

is_mem_matrix = ismember(br_names,  string(matrix_projecting_regions));
matrix_ids = find(is_mem_matrix);
br_ids = [strio_ids; matrix_ids];

subj = 1;
striatum_voxels = voxel_ref{1,subj}{1,dms_index};
num_strio = length(striatum_voxels);

valid_combos = valid_combos(valid_combos.num_vox ~= 0, :);
max_obj_sum = max(valid_combos.obj_sum);
max_entropy = max(valid_combos.entropy);

valid_combos.optimize = valid_combos.num_vox / num_strio + valid_combos.entropy / max_entropy + ...
   valid_combos.obj_sum / max_obj_sum;

%valid_combos = valid_combos(valid_combos.num_vox < num_strio*0.25, :);

sorted_combos = sortrows(valid_combos, "optimize", "descend");
best_combo = head(sorted_combos, 1);

thresh_table.br = br_ids;
thresh_table.thresh = [best_combo.br1_thresh; best_combo.br2_thresh; ...
    best_combo.br3_thresh; best_combo.br4_thresh; best_combo.br5_thresh];

thresh_table = struct2table(thresh_table);

end