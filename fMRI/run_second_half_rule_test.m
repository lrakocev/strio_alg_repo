function [striosomalities, combined_strio_list] = run_second_half_rule_test(sub_id, striosomalities, combined_strio_list, want_viz)

save_to = "results/" + sub_id + "/";
mkdir(save_to)
all_regions = ["a24_a32_lh"; "final_SN"; "Hb_mni" ; "a24_a32_rh"; "Amygdala-LB.Bl_rh152"; "Thalamus-MD_rh152";]; 

all_subjects = [sub_id];
dms_name="left-caudate";
use_cross_corr = 1;
strio_filename = "striosome_projection_rankings_v1.xlsx";

[processed_activities, cross_corrs, strio_projecting_regions, matrix_projecting_regions, brain_region_names, voxel_ref, rankings] = ...
    process_input_data(all_subjects, use_cross_corr, dms_name, strio_filename);

dms_index = find(brain_region_names{1,1} == dms_name);
dms_voxel_ref = voxel_ref{1,1}{1,dms_index};

regions_to_hotspot = ["Hb_mni" ; "a24_a32_lh"; "a24_a32_rh"];


% combining input + output regions 
lh_index = find(all_regions=="Hb_mni");
sn_index = find(all_regions=="final_SN");
lh_striosomality = striosomalities(lh_index, :);
sn_striosomality = striosomalities(sn_index, :);
downstream_striosomalities = [lh_striosomality; sn_striosomality];

[upstream_list, downstream_list, both_list] = combine_upstream_downstream_fuzzy_logic(combined_strio_list, downstream_striosomalities); 
%head_vox = get_caudate_head(brain_region_names, voxel_ref{1,1});

% end results - the actual activities
smooth_factor = 10;
upstream_dms = upstream_list;
downstream_dms = downstream_list;
both_dms = both_list;

all_matrix = (downstream_list == 0);
matrix  = all_matrix;

if want_viz
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
end

create_mask_helper(all_subjects, brain_region_names, voxel_ref, upstream_dms, char(save_to + "upstream_striosome.nii"))
create_mask_helper(all_subjects, brain_region_names, voxel_ref, downstream_dms, char(save_to + "downstream_striosome.nii"))
create_mask_helper(all_subjects, brain_region_names, voxel_ref, both_dms,  char(save_to + 'full_striosome.nii'))
create_mask_helper(all_subjects, brain_region_names, voxel_ref, matrix, char(save_to +"full_matrix.nii"))

end