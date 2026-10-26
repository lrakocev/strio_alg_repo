function create_mask_helper(all_subjects, brain_region_names, voxel_ref, voxel_list, mask_name, dms_name, dms_mask_filename)

[labeled_regions, voxel_striosomality] = viz_overlapping_strio_vox(all_subjects, brain_region_names, voxel_ref,dms_name, voxel_list, 0);


%volumeViewer(voxel_striosomality{1,1},labeled_regions{1,1})

[r, c, p] = ind2sub(size(voxel_striosomality{1,1}), find(voxel_striosomality{1,1} == 1));


%mask_nii = make_nii(mask_voxels);
%save_nii(mask_nii,mask_name);

info = niftiinfo(dms_mask_filename);
maskData = niftiread(info);

% Create an empty array with the same size
newMaskData = zeros(size(maskData), 'like', maskData);

% Convert coordinates to linear indices and set to 1
linearIndices = sub2ind(size(maskData), r, c, p);
newMaskData(linearIndices) = 1;

% Update metadata and write the new NIfTI file
info.Filename = mask_name;
niftiwrite(newMaskData, mask_name, info);


end