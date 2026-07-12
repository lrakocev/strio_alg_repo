function [smoothed_activities, smoothed_cross_corrs] = corrs_of_smoothed_activities(activities,brain_region_names,dms_name,all_subjects,use_cross_corr,smooth_factor)

activities = activities{1,1};

smoothed_activities = {};
for j = 1:length(activities)
    curr_activity = activities{1,j};
    curr_smoothed = movmean(curr_activity, smooth_factor, 2);
    smoothed_activities{j} = curr_smoothed;
end

smoothed_cross_corrs = get_corrs_btwn_regions({smoothed_activities},brain_region_names,dms_name,all_subjects,use_cross_corr);
    
end