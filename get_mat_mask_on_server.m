function get_mat_mask_on_server(subj_id, dms_name, dms_mask_filename, h, thresh)

subj_dir = "/sc/arion/projects/K01_VTA/users/rakocl01/" + subj_id + "/test";
voxel_dir = subj_dir + "/voxel_dir";
mask_dir = subj_dir + "/ROIs/native";

save_to = subj_dir + "results/";
mkdir(save_to)
all_regions = ["Area-3a_rh_MNI152"; "Area-3a_lh_MNI152"; "Area-4p_rh_MNI152"; "Area-4p_lh_MNI152"; ...
    "Thalamus-Pf_rh_MNI152";"Thalamus-Pf_lh_MNI152"];

all_subjects = [subj_id];
use_cross_corr = 1;
strio_filename = "striosome_projection_rankings_v1.xlsx";
regions_to_load = [all_regions; dms_name];

[processed_activities, cross_corrs, strio_projecting_regions, matrix_projecting_regions, brain_region_names, voxel_ref, rankings] = ...
    process_input_data(voxel_dir, all_subjects, use_cross_corr, dms_name, strio_filename, regions_to_load);

% first level of fuzzy logic on all regions
all_regions = brain_region_names{1,1};
regions_to_hotspot = [""];
%[matrisomalities] = apply_fuzzy_logic(cross_corrs, voxel_ref, dms_name, brain_region_names, all_regions,...
%    regions_to_hotspot, rankings, h, thresh);
%save(save_to + "/" + dms_name + "_matrisomalities_" + thresh + "_thresh.mat","matrisomalities")
load(save_to + "/" + dms_name + "_matrisomalities_newfis.mat")

% second level of fuzzy logic on input regions
%combined_mat_list = combine_matrix_rois_fuzzy_logic(matrisomalities, all_regions, dms_name, rankings);
%save(save_to + "/" + dms_name + "_combined_mat_list_" + thresh + "_.mat","combined_mat_list")
load(save_to + "/" + dms_name + "_combined_mat_list_newfis.mat")

% exporting strio / striatum mask
%create_mask_helper(all_subjects, brain_region_names, voxel_ref, combined_mat_list, char(mask_dir + "/" + dms_name + "_refined_matrix_" + thresh + "_thresh.nii"), dms_name, dms_mask_filename)
create_mask_helper(all_subjects, brain_region_names, voxel_ref, combined_mat_list, char(mask_dir + "/" + dms_name + "_refined_matrix_sept_fis.nii"), dms_name, dms_mask_filename)




end