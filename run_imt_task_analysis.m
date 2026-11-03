subject_list = [ "547_imt", "548_imt","544_imt",]; %,"545_new_imt"]; % "420_imt","431_imt"", "545_new_imt"

data_dir = "C:/Users/lrako/OneDrive/Documents/mt_sinai/mt_sinai_fmri_raw_data";
for k = 1:length(subject_list)
    all_subjects = subject_list(k);
    mkdir(data_dir + "/" + all_subjects)
    
    dirs = "results/" + all_subjects;
    
    dms_name="left-caudate";
    use_cross_corr = 1;
    smooth_factor = 1;
    
    regions_to_hotspot = ["Hb_mni" ; "a24_a32_lh"; "a24_a32_rh"; "final_SN"];
    
    strio_filename = "striosome_projection_rankings_v1.xlsx";
    
    [processed_activities, cross_corrs, strio_projecting_regions, matrix_projecting_regions, brain_region_names, voxel_ref, rankings] = ...
        process_input_data(data_dir, all_subjects, use_cross_corr, dms_name, strio_filename);
    
    % plotting activities on the whole
   
    regions_to_plot = ["downstream_striosome.nii"; "full_matrix.nii"; "a24_a32_lh"; "final_SN"; "Hb_mni" ; "a24_a32_rh"; "Thalamus-MD_rh152"]; 
    [mean_activities, transients, variances, output_activity_table] = plot_avg_activity_of_brs(processed_activities, cross_corrs, voxel_ref, dms_name, ...
            brain_region_names, regions_to_plot, regions_to_hotspot, all_subjects, dirs, smooth_factor);
    
    saveas(gcf, data_dir + "/" + dirs + "/activities.fig")
    % split by task + everything
    close all

    timing_dir = data_dir + "/" + all_subjects + "/timing_files_nopmod";
    timing_table = ordering_timing_files(timing_dir);
    
    output_activity_table = struct2table(output_activity_table);
    activity_at_action = outerjoin(timing_table, output_activity_table,"MergeKeys",1, "Keys", {'onset_time_step'});
    activity_filled = fillmissing(activity_at_action, 'previous');
    
    % bar charts of things!
    
    regions_to_plot = ["downstream_striosome_nii"; "full_matrix_nii"; "final_SN"; "Hb_mni" ; "Thalamus_MD_rh152"; "a24_a32_lh";  "a24_a32_rh"]; 
    events = ["fix", "choice", "square", "response"];
  
    figure
    
     for k = 1:length(regions_to_plot)
            region = regions_to_plot(k);
            br_activities = [];
    
            mean_for_region = mean(activity_filled.(region),'omitnan');
            std_for_region = std(activity_filled.(region),'omitnan');
            for j = 1:length(events)
                event = events(j);
                event_table = activity_filled(activity_filled.trial_section == event, :);
                activity = (mean(event_table.(region),'omitnan') - mean_for_region) / std_for_region;
                br_activities = [br_activities; activity];
            end
        
    
        nexttile
        bar(1:length(br_activities), br_activities)
        if event == "choice"
            event = "reward cue";
        elseif event == "square"
            event = "cost cue";
        end
    
        title(region) 
        xticklabels(["fix", "reward", "cost", "response"])
        ylabel("z scores")
        hold on

     end
     saveas(gcf, data_dir + "/" + dirs + "/avg_activity_at_event")
     close all


end