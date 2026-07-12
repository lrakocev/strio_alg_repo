function viz_striosomal_vox_scatter(dms_voxel_ref, strio_list, type, sub_id)

dms_voxels = dms_voxel_ref(strio_list == 1,:);

scatter3(dms_voxels(:,1),dms_voxels(:,2),dms_voxels(:,3))
title(type + " number of striosomally-enriched voxels = " + length(dms_voxels) + "/" + length(dms_voxel_ref))
savefig("results/" + sub_id + "/" + "strio_viz_" + type + ".fig")
end