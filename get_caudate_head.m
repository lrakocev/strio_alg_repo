function [head_vox] = get_caudate_head(brain_region_names, voxel_ref)

dms_index = find(brain_region_names{1,1} == "left-caudate");
voxels = voxel_ref{1,dms_index};

x_range = unique(voxels(:,1));
y_range = unique(voxels(:,2));
z_range = unique(voxels(:,3));

last_third_y = y_range(2*round(length(y_range)/3):end);

first_half_x = x_range(1:round(length(x_range)/2));

head_vox = ismember(voxels(:,2),last_third_y);

other_head = ismember(voxels(:,1),first_half_x);

head_of_head = head_vox & other_head;

%[labeled_regions, voxel_striosomality] = viz_overlapping_strio_vox(["431"], brain_region_names, {voxel_ref}, "left-caudate", head_of_head, 0);
%volumeViewer(voxel_striosomality{1,1},labeled_regions{1,1})


end