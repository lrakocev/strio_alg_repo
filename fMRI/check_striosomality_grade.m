%% calc striosomality categories

striatum_thresholds = [4,1,1,1,4,4,4,4];%6*ones(1,8);

[maybe_strio, definite_strio, maybe_matrix, definite_matrix,...
    contaminated_strio, contaminated_matrix, contaminated_evenly] = ...
    calculate_striosomality(striatum_vox, striatum_thresholds, brain_region_names, strio_filename);
%{
task_striatum_thresholds = 6*ones(1,8);

[task_maybe_strio, task_definite_strio, task_maybe_matrix, task_definite_matrix,...
    task_contaminated_strio, task_contaminated_matrix, task_contaminated_evenly] = ...
    calculate_striosomality(task_striatum_vox, task_striatum_thresholds, task_brain_region_names, strio_filename);
%}
%% basic counting

num_maybe_strio = sum(maybe_strio);
num_definite_strio = sum(definite_strio);
num_maybe_matrix = sum(maybe_matrix);
num_definite_matrix = sum(definite_matrix);
num_contam_strio = sum(contaminated_strio);
num_contam_matrix = sum(contaminated_matrix);
num_contam_even = sum(contaminated_evenly);

definite_uncontaminated_strio = num_definite_strio - (num_contam_even + num_contam_strio);

%% viz em up

types = {maybe_strio};
    %maybe_strio, definite_strio, maybe_matrix, definite_matrix,...
    %contaminated_strio, contaminated_matrix, contaminated_evenly};
for i = 1:length(types)
    vox_type = types{i};
    [labeled_regions, voxel_striosomality] = viz_overlapping_strio_vox(all_subjects, brain_region_names, voxel_ref, vox_type);
    volumeViewer(voxel_striosomality{1,1},labeled_regions{1,1})
end

%%

all_subjects = ["545_imt"];
speedrun = true;
use_cross_corr = 1;
strio_filename = "striosome_projection_rankings_v1.xlsx";

[processed_activities, cross_corrs, strio_projecting_regions, matrix_projecting_regions, brain_region_names, voxel_ref] = ...
    process_input_data(all_subjects, use_cross_corr, strio_filename);


plot_avg_activity_of_brs(processed_activities, brain_region_names,...
    all_subjects,1) 


plot_avg_activity_of_brs(processed_activities, brain_region_names,...
    all_subjects,0) 

%%

all_subjects = ["545"];
speedrun = true;
use_cross_corr = 1;
strio_filename = "striosome_projection_rankings_v1.xlsx";
%{
[processed_activities, cross_corrs, strio_projecting_regions, matrix_projecting_regions, brain_region_names, voxel_ref] = ...
    process_input_data(all_subjects, use_cross_corr, strio_filename);
%}
plot_avg_activity_of_brs(processed_activities, brain_region_names,...
    all_subjects, 1, ["definite-strio";"maybe-strio"; "maybe-matrix";"definite_matrix"],{definite_strio; maybe_strio; maybe_matrix; definite_matrix})
