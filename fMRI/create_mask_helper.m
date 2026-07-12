function create_mask_helper(all_subjects, brain_region_names, voxel_ref, voxel_list, mask_name)

[labeled_regions, ~] = viz_overlapping_strio_vox(all_subjects, brain_region_names, voxel_ref, "left-caudate", voxel_list, 0);

mask_voxels = double(labeled_regions{1,1} == 99);

mask_nii = make_nii(mask_voxels);
save_nii(mask_nii,mask_name);


end