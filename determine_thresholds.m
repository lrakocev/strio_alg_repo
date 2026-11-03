all_subjects = ["545"];
speedrun = true;
use_cross_corr = 0;

for s = 1:length(all_subjects)

subject_names = [all_subjects(s)];
close all
clear processed_activities brain_region_names n_region voxel_ref n_subject n_tsteps

[processed_activities,brain_region_names,...
    n_region,voxel_ref,n_subject,n_tsteps] = load_data(subject_names,'all');

strio_filename = "striosome_projection_rankings_v1.xlsx";
[~, strio_projecting_regions, matrix_projecting_regions,control_regions,...
    DMS_regions] = load_striosome_projecting_rankings(strio_filename, brain_region_names);
end

%% unshuffled corr

true_corrs = get_corrs_btwn_regions(processed_activities,brain_region_names,all_subjects,1);

%% shuffle time series + check avg correlation then

shuffled_activity = shuffle_time_series(all_subjects, processed_activities, brain_region_names);
shuffled_corrs = get_corrs_btwn_regions({shuffled_activity},brain_region_names,all_subjects,1);

%% unrelated regions

all_subjects = ["545/unrelated"];
for s = 1:length(all_subjects)

    subject_names = [all_subjects(s)];
    [unrelated_activities,unrelated_brain_region_names,...
    unrelated_n_region,unrelated_voxel_ref,unrelated_n_subject,unrelated_n_tsteps] = load_data(subject_names,'all');

end

unrelated_corrs = get_corrs_btwn_regions(unrelated_activities,unrelated_brain_region_names,all_subjects,1);

%% viz of corrs

% quick_corr_histogram(shuffled_corrs, brain_region_names, "shuffled")
quick_corr_histogram(true_corrs, brain_region_names, "true")
quick_corr_histogram(unrelated_corrs, unrelated_brain_region_names, "unrelated")


%% get thresholds per region

[thresholds] = find_thresholds(all_subjects, brain_region_names, ...
    unrelated_brain_region_names, true_corrs, shuffled_corrs, unrelated_corrs);

%% trying out new thresholds

names = brain_region_names{1,1};
for i = 1:length(names)-1
    base_roi_name = names(i);
    std_threshold = thresholds(i);
    [cross_labeled, cross_striosomality, special_vox] = get_strio_vox(all_subjects, true_corrs, voxel_ref, base_roi_name, brain_region_names, 1, std_threshold);
    
    all_labels{i} = cross_labeled;
    all_striosomalities{i} = cross_striosomality;
    hi_projecting_vox{i} = special_vox{1};
    striatum_vox{i} = special_vox{2};
end

%% viz of how the thresholds are working

names = brain_region_names{1,1};
for i = 1:length(names)
    base_roi_name = names(i);
    base_roi_name
    volumeViewer(all_striosomalities{i}{1,1},all_labels{i}{1,1})
end

%% trying my threshold thing

[all_combos] = find_entropy_thresholds(all_subjects, brain_region_names, cross_corrs, voxel_ref,strio_filename);

%% get max value for each pair

avg_thresholds = get_avg_threshold_from_table(brain_region_names, compare_rois, valid_combos);