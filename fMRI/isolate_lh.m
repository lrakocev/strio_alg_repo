function [voxel_rows_w_high_connectivity, max_avg, max_std, max_med] = isolate_lh(corrs, voxel_ref, region_name, dms_name, brain_region_names)

    dms_index = find(brain_region_names{1,1}==dms_name);

    roi_index = find(brain_region_names{1,1}==region_name);
    corr_matrix = corrs{1,1}{roi_index, dms_index};

    corr_matrix = abs(corr_matrix);

    max_corrs_base_vox = maxk(corr_matrix, 10, 2);
    mean_corr_each_base_vox = mean(max_corrs_base_vox, 2,'omitnan');

    voxels = voxel_ref{1,1}{1,roi_index};
    voxel_coords = voxels - min(voxels) + [1,1,1];

    x_coords = voxel_coords(:,1);
    y_coords = voxel_coords(:,2);
    z_coords = voxel_coords(:,3);

    height_x = length(unique(x_coords));
    height_y = length(unique(y_coords));
    height_z = length(unique(z_coords));

    matrix_3d = NaN(height_x, height_y, height_z);

    for pt = 1:length(voxel_coords)
        matrix_3d(x_coords(pt), y_coords(pt), z_coords(pt)) = mean_corr_each_base_vox(pt);
    end

    box_size = 4;
    try
        [highest_avg, best_coords, start_x, start_y, start_z, max_avg, max_std, max_med] = find_highest_avg_subsection(matrix_3d, [box_size box_size box_size]);
    catch
        [highest_avg, best_coords, start_x, start_y, start_z, max_avg, max_std, max_med] = find_highest_avg_subsection(matrix_3d, [box_size-1 box_size-1 box_size-1]);
    end
    highest_connectivity_coords = table2array(best_coords);

    voxel_rows_w_high_connectivity = find(ismember(voxel_coords, highest_connectivity_coords, 'rows'));

end