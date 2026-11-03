all_subjects = ["545_new_imt"];
speedrun = true;
use_cross_corr = 1;
strio_filename = "striosome_projection_rankings_v1.xlsx";

[processed_activities, cross_corrs, strio_projecting_regions, matrix_projecting_regions, brain_region_names, voxel_ref,rankings] = ...
    process_input_data(all_subjects, use_cross_corr, strio_filename);

% getting thresholds
%valid_combos = find_entropy_thresholds(all_subjects, brain_region_names, cross_corrs, voxel_ref, strio_filename);

%% 

names = brain_region_names{1,1};
thresholds = [1.5, 1.75, 2, 2.5, 2.7, 3, 3.2, 3.5];
for i = 1:length(names)
    base_roi_name = names(i);
    for j = 1:length(thresholds)
        std_threshold = thresholds(j);
        [cross_labeled, cross_striosomality, special_vox] = get_strio_vox(all_subjects, cross_corrs, voxel_ref, base_roi_name, brain_region_names, 1, std_threshold);
        
        all_labels{i,j} = cross_labeled;
        all_striosomalities{i,j} = cross_striosomality;
        hi_projecting_vox{i,j} = special_vox{1};
        striatum_vox{i,j} = special_vox{2};
    end
end

%% def striosomality vs matrisomes

threshold_order = ["Amygdala-LB.Bl","Area-3a","Area-4p",...
    "Hb_mni","Hippocampus-CA1","Thalamus-MD","left-caudate"]; %,"final_SN"];
striatum_thresholds =[3,1,1,1,1,3,3,3]; %  [7,5,5,5,7,7,7,7]; %  %[4,1,1,1,4,4,4,4];
threshold_dict = dictionary(threshold_order, striatum_thresholds);

[maybe_strio, definite_strio, maybe_matrix, definite_matrix,...
    contaminated_strio, contaminated_matrix, contaminated_evenly] = ...
    calculate_striosomality(striatum_vox, threshold_dict, brain_region_names, strio_filename);

%% viz of striosomes/matrisomes in the striatum

types = {definite_strio, definite_matrix};
    %maybe_strio, definite_strio, maybe_matrix, definite_matrix,...
    %contaminated_strio, contaminated_matrix, contaminated_evenly};
for i = 1:length(types)
    vox_type = types{i};
    [labeled_regions, voxel_striosomality] = viz_overlapping_strio_vox(all_subjects, brain_region_names, voxel_ref, vox_type);
    volumeViewer(voxel_striosomality{1,1},labeled_regions{1,1})
end

%% viz of the activity

plot_avg_activity_of_brs(processed_activities, brain_region_names,...
    all_subjects, ["definite-strio";"maybe-strio"; "maybe-matrix";"definite_matrix"],{definite_strio; maybe_strio; maybe_matrix; definite_matrix})
