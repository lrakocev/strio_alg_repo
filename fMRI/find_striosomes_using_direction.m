%% concat a24 + a32

sub = "442";
concat_txt_files(sub+"_Area-p24ab.p24a_lh_MNI152_voxels.txt", sub+"_Area-p32_lh_MNI152_voxels.txt",sub+"_a24_a32_lh_voxels")
concat_txt_files(sub+"_Area-p24ab.p24a_rh_MNI152_voxels.txt", sub+"_Area-p32_rh_MNI152_voxels.txt",sub+"_a24_a32_rh_voxels")

%%

all_subjects = ["431"];
speedrun = true;
use_cross_corr = 1;
strio_filename = "striosome_projection_rankings_v1.xlsx";
dms_name = "left-caudate";

[processed_activities, cross_corrs, strio_projecting_regions, matrix_projecting_regions, brain_region_names, voxel_ref, rankings] = ...
    process_input_data(all_subjects, use_cross_corr, dms_name, strio_filename);

%% initial calc of striosomalities for rois

high_corr_thresh = 0.3;
all_regions = ["a24_a32_lh"; "final_SN"; "Hb_mni" ; "a24_a32_rh"; "Amygdala-LB.Bl_rh152"]; 
regions_to_hotspot = ["Hb_mni" ; "a24_a32_lh"; "a24_a32_rh"];
[striosomalities] = apply_fuzzy_logic(cross_corrs, voxel_ref, "left-caudate", brain_region_names, all_regions, regions_to_hotspot, rankings, high_corr_thresh);

%% viewer for individual rois

[labeled_regions, voxel_striosomality] = viz_overlapping_strio_vox(all_subjects, brain_region_names, voxel_ref, "left-caudate", striosomalities(4,:), 0);
volumeViewer(voxel_striosomality{1,1},labeled_regions{1,1})

%% combining roi striosomalities

roi_list = ["a24_a32_lh"; "final_SN"; "Hb_mni" ; "a24_a32_rh"; "Amygdala-LB.Bl_rh152"]; 
dms_name = "left-caudate"; 
combined_strio_list = combine_rois_fuzzy_logic(striosomalities, roi_list, dms_name, rankings);


%% combining upstream + downstream striosomalities + get caudate head

downstream_striosomalities = striosomalities(2:3,:);
[upstream_list, downstream_list, both_list ] = combine_upstream_downstream_fuzzy_logic(combined_strio_list, downstream_striosomalities); 
head_vox = get_caudate_head(brain_region_names, voxel_ref);

%%

smooth_factor = 10;
save_to = "results/" + all_subjects(1) + "/";
mkdir(save_to);
upstream_dms = upstream_list.* head_vox;
downstream_dms = downstream_list.* head_vox;
both_dms = both_list; %.* head_vox';
matrix  = ((upstream_list == 0) & (downstream_list == 0) & (both_list == 0)) .* head_vox;

regions_to_plot =  ["Hb_mni" ; "final_SN"; "a24_a32_lh"; "a24_a32_rh"; "Amygdala-LB.Bl_rh152"; "left-caudate"];
regions_to_hotspot = ["Hb_mni"; "a24_a32_lh"; "a24_a32_rh";];
[mean_activities, transients] = plot_avg_activity_of_brs(processed_activities, cross_corrs, voxel_ref, dms_name, ...
    brain_region_names, regions_to_plot, regions_to_hotspot, all_subjects, save_to, smooth_factor, ...
    ["input only strio"; "output only strio"; "input + output strio"; "matrix"],{upstream_dms;  downstream_dms; both_dms; matrix});

%% checking hotspots

region_name = "Area-p32_rh152";
dms_name = "left-caudate";
[voxel_rows_w_high_connectivity, max_avg] = isolate_lh(cross_corrs, voxel_ref, region_name, dms_name, brain_region_names);

dms_idx = find(brain_region_names{1,1}==dms_name);
region_idx = find(brain_region_names{1,1}==region_name);

hotspot_vox = zeros(1,size(cross_corrs{1,1}{region_idx, dms_idx},1));
hotspot_vox(voxel_rows_w_high_connectivity) = 1;
[hotspot_labels, hotspot_voxels_in_roi] =  viz_overlapping_strio_vox(all_subjects, brain_region_names, voxel_ref, region_name, hotspot_vox);

volumeViewer(hotspot_voxels_in_roi{1,1},hotspot_labels{1,1})
 
%% viewing 
strio_thresh = 0;
[labeled_regions, voxel_striosomality] = viz_overlapping_strio_vox(all_subjects, brain_region_names, voxel_ref, "left-caudate", downstream_list, strio_thresh);
volumeViewer(voxel_striosomality{1,1},labeled_regions{1,1})

%% plot with scatter plot
dms_index = find(brain_region_names{1,1} == "left-caudate");
dms_voxel_ref = voxel_ref{1,1}{1,dms_index};
dms_voxels = dms_voxel_ref(downstream_list == 1,:);

scatter3(dms_voxels(:,1),dms_voxels(:,2),dms_voxels(:,3))
title("number of striosomally-enriched voxels = " + length(dms_voxels) + "/" + length(dms_voxel_ref))
