%% at rest

all_subjects = ["545"];
speedrun = true;
use_cross_corr = 1;
strio_filename = "striosome_projection_rankings_v1.xlsx";

[processed_activities, cross_corrs, strio_projecting_regions, matrix_projecting_regions, brain_region_names, voxel_ref] = ...
    process_input_data(all_subjects, use_cross_corr, strio_filename);

[corrs_to_whole_br] = each_striatal_vox_to_br(processed_activities,brain_region_names,all_subjects);

%% histograms showing vox data at rest

quick_corr_histogram(cross_corrs, brain_region_names, "hist")
quick_corr_histogram(corrs_to_whole_br, brain_region_names, "hist")

%% second algorithm attempt

threshold_alg_v2(all_subjects, brain_region_names, cross_corrs, strio_filename,0);
threshold_alg_v2(all_subjects, brain_region_names, corrs_to_whole_br, strio_filename, 1);

%% getting + applying thresholds
valid_combos = find_entropy_thresholds(all_subjects, brain_region_names, cross_corrs, voxel_ref, strio_filename);

[thresh_table, best_combo, sorted_combos] = get_best_threshold_from_table...
    (brain_region_names, voxel_ref, valid_combos, strio_filename);
% group striatal vox based on thresholds 

[all_labels, all_striosomalities, hi_projecting_vox, striatum_vox, overlapped_vox] = ...
     threshold_strio_vox(all_subjects, cross_corrs, thresh_table, brain_region_names, voxel_ref, strio_filename);

% viz of overlap

[labeled_regions, voxel_striosomality] = viz_overlapping_strio_vox(all_subjects, brain_region_names, voxel_ref, overlapped_vox);
volumeViewer(voxel_striosomality{1,1},labeled_regions{1,1})

%%
% volume viewer - at rest

br_names = brain_region_names{1,1};
compare_rois = ["Amygdala-LB.Bl", "Hb_mni", "Thalamus-MD", "pOFC_v2"];
is_mem = ismember(br_names, compare_rois);
br_ids = find(is_mem);

for i = 2:length(br_ids)
    id = br_ids(i);
    base_roi_name = br_names(id);
    base_roi_name
    if ~isempty(all_striosomalities{id})
        volumeViewer(all_striosomalities{id}{1,1},all_labels{id}{1,1})
    end
end
