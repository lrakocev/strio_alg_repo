function [processed_activities,cross_corrs, strio_projecting_regions, matrix_projecting_regions, brain_region_names, voxel_ref,rankings] = ...
    process_input_data(data_dir, all_subjects, use_cross_corr, dms_name, strio_filename,rois_to_read)

speedrun = true; 
for s = 1:length(all_subjects)
    subject_names = [all_subjects(s)];
    

    [processed_activities,brain_region_names,...
        n_region,voxel_ref,n_subject,n_tsteps] = load_data(data_dir,subject_names,'all',rois_to_read);

    
    [rankings, strio_projecting_regions, matrix_projecting_regions,control_regions,...
        DMS_regions] = load_striosome_projecting_rankings(strio_filename, brain_region_names);
end

if use_cross_corr == 0
    cross_corrs = [];
else
    cross_corrs = get_corrs_btwn_regions(processed_activities,brain_region_names,dms_name,all_subjects,use_cross_corr);
end
end