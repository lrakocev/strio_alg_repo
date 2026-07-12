function get_strio_mask_on_server(subj_id)

subj_dir = "/sc/arion/projects/K01_VTA/users/rakocl01/" + subj_id + "/test";
voxel_dir = subj_dir + "/voxel_dir";

concat_txt_files(voxel_dir+"/"+subj_id+"_Area-p24ab.p24a_lh_MNI152_voxels.txt",...
    voxel_dir+"/"+subj_id+"_Area-p32_lh_MNI152_voxels.txt",voxel_dir+"/"+subj_id+"_a24_a32_lh_voxels")
concat_txt_files(voxel_dir+"/"+subj_id+"_Area-p24ab.p24a_rh_MNI152_voxels.txt",...
    voxel_dir+"/"+stripped_subid+"_Area-p32_rh_MNI152_voxels.txt",voxel_dir+"/"+subj_id+"_a24_a32_rh_voxels")

save_to = subj_dir + "results/";
mkdir(save_to)
all_regions = ["a24_a32_lh"; "final_SN"; "Hb_mni" ; "a24_a32_rh"; "Thalamus-MD_rh152"]; 

all_subjects = [subj_id];
dms_name="left-caudate";
use_cross_corr = 1;
strio_filename = "striosome_projection_rankings_v1.xlsx";

[processed_activities, cross_corrs, strio_projecting_regions, matrix_projecting_regions, brain_region_names, voxel_ref, rankings] = ...
    process_input_data(voxel_dir, all_subjects, use_cross_corr, dms_name, strio_filename);

% first level of fuzzy logic on all regions
regions_to_hotspot = ["Hb_mni" ; "a24_a32_lh"; "a24_a32_rh"];
[striosomalities] = apply_fuzzy_logic(cross_corrs, voxel_ref, "left-caudate", brain_region_names, all_regions, regions_to_hotspot, rankings);
save(save_to + "/striosomalities_newfis.mat","striosomalities")

% second level of fuzzy logic on input regions
combined_strio_list = combine_rois_fuzzy_logic(striosomalities, all_regions, dms_name, rankings);
save(save_to + "/combined_list_newfis.mat","combined_strio_list")

% combining input + output regions 
lh_index = find(all_regions=="Hb_mni");
sn_index = find(all_regions=="final_SN");
lh_striosomality = striosomalities(lh_index, :);
sn_striosomality = striosomalities(sn_index, :);
downstream_striosomalities = [lh_striosomality; sn_striosomality];

[upstream_list, downstream_list, both_list] = combine_upstream_downstream_fuzzy_logic(combined_strio_list, downstream_striosomalities); 
matrix  = ((downstream_list == 0) & (both_list == 0));

% exporting strio / striatum mask
create_mask_helper(all_subjects, brain_region_names, voxel_ref, upstream_list, char(voxel_dir + "/upstream_striosome.nii"))
create_mask_helper(all_subjects, brain_region_names, voxel_ref, downstream_list, char(voxel_dir + "/downstream_striosome.nii"))
create_mask_helper(all_subjects, brain_region_names, voxel_ref, both_listt,  char(voxel_dir + "/full_striosome.nii"))
create_mask_helper(all_subjects, brain_region_names, voxel_ref, matrix, char(voxel_dir + "/full_matrix.nii"))

end