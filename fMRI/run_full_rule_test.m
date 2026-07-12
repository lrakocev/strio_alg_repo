function [striosomalities, combined_strio_list] = run_full_rule_test(sub_id)

id_list =split(sub_id, "_");
stripped_subid = id_list(1);

concat_txt_files(sub_id+"/"+stripped_subid+"_Area-p24ab.p24a_lh_MNI152_voxels.txt",...
    sub_id+"/"+stripped_subid+"_Area-p32_lh_MNI152_voxels.txt",sub_id+"/"+stripped_subid+"_a24_a32_lh_voxels")
concat_txt_files(sub_id+"/"+stripped_subid+"_Area-p24ab.p24a_rh_MNI152_voxels.txt",...
    sub_id+"/"+stripped_subid+"_Area-p32_rh_MNI152_voxels.txt",sub_id+"/"+stripped_subid+"_a24_a32_rh_voxels")

save_to = "results/" + sub_id + "/";
mkdir(save_to)
all_regions = ["a24_a32_lh"; "final_SN"; "Hb_mni" ; "a24_a32_rh"; "Thalamus-MD_rh152"]; 

all_subjects = [sub_id];
dms_name="left-caudate";
use_cross_corr = 1;
strio_filename = "striosome_projection_rankings_v1.xlsx";

[processed_activities, cross_corrs, strio_projecting_regions, matrix_projecting_regions, brain_region_names, voxel_ref, rankings] = ...
    process_input_data(all_subjects, use_cross_corr, dms_name, strio_filename);

dms_index = find(brain_region_names{1,1} == dms_name);
dms_voxel_ref = voxel_ref{1,1}{1,dms_index};

% first level of fuzzy logic on all regions
regions_to_hotspot = ["Hb_mni" ; "a24_a32_lh"; "a24_a32_rh"];
[striosomalities] = apply_fuzzy_logic(cross_corrs, voxel_ref, "left-caudate", brain_region_names, all_regions, regions_to_hotspot, rankings);
 save("results/" + string(sub_id) + "/striosomalities_newfis.mat","striosomalities")

% viz for first level
for i = 1:length(all_regions)
    region_name = all_regions{i};
    striosomality = striosomalities(i,:);
    striosomality_bool = (striosomality > 0);
    viz_striosomal_vox_scatter(dms_voxel_ref, striosomality_bool, region_name, sub_id)
end

% second level of fuzzy logic on input regions
combined_strio_list = combine_rois_fuzzy_logic(striosomalities, all_regions, dms_name, rankings);
save("results/" + sub_id + "/combined_list_newfis.mat","combined_strio_list")


% combining input + output regions 
lh_index = find(all_regions=="Hb_mni");
sn_index = find(all_regions=="final_SN");
lh_striosomality = striosomalities(lh_index, :);
sn_striosomality = striosomalities(sn_index, :);
downstream_striosomalities = [lh_striosomality; sn_striosomality];

[upstream_list, downstream_list, both_list] = combine_upstream_downstream_fuzzy_logic(combined_strio_list, downstream_striosomalities); 
head_vox = get_caudate_head(brain_region_names, voxel_ref{1,1});

% end results - the actual activities
smooth_factor = 10;
upstream_dms = upstream_list.* head_vox;
downstream_dms = downstream_list.* head_vox;
both_dms = both_list.* head_vox';
matrix  = ((upstream_list == 0) & (downstream_list == 0) & (both_list == 0)) .* head_vox;

viz_striosomal_vox_scatter(dms_voxel_ref, upstream_dms, "upstream", sub_id)
viz_striosomal_vox_scatter(dms_voxel_ref, downstream_dms, "downstream", sub_id)
viz_striosomal_vox_scatter(dms_voxel_ref, both_dms, "both", sub_id)

regions_to_plot = [all_regions; dms_name];
try
[mean_activities, transients] = plot_avg_activity_of_brs(processed_activities, cross_corrs, voxel_ref, dms_name, ...
    brain_region_names, regions_to_plot, regions_to_hotspot, all_subjects, save_to, smooth_factor, ...
    ["input only strio"; "output only strio"; "input + output strio"; "matrix"],{upstream_dms;  downstream_dms; both_dms; matrix});
catch
    warning("brain activities did not plot :(")
end

% exporting strio / striatum mask

strio_voxels = double(both_dms == 1);

strio_mask_name = 'strio_mask.nii';
strio_nii = make_nii(strio_voxels);

save_nii(strio_nii,strio_mask_name);


end