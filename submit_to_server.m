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

% correlation between all voxels of one region and all voxels of another

granger_corrs = get_corrs_btwn_regions(processed_activities,brain_region_names,all_subjects,1);
save('granger_casuality_wkspc')