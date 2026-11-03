function  [timing_table, output_activity_table] = apply_time_series_breakdown_per_subject(subjectid, data_dir, timing_base_dir)

dms_name="left-caudate";
use_cross_corr = 0;
smooth_factor = 1;

regions_to_hotspot = ["Hb_mni" ; "a24_a32_lh"; "a24_a32_rh"; "final_SN"];

sub_id = subjectid(1);

try
    concat_txt_files(data_dir+"/"+sub_id+"_Area-p24ab.p24a_lh_MNI152_voxels.txt",...
        data_dir+"/"+sub_id+"_Area-p32_lh_MNI152_voxels.txt",data_dir+"/"+sub_id+"_a24_a32_lh_voxels")
    concat_txt_files(data_dir+"/"+sub_id+"_Area-p24ab.p24a_rh_MNI152_voxels.txt",...
        data_dir+"/"+sub_id+"_Area-p32_rh_MNI152_voxels.txt",data_dir+"/"+sub_id+"_a24_a32_rh_voxels")
catch
end

rois_in_dir = dir(data_dir);
files = rois_in_dir(~[rois_in_dir.isdir]);
only_rois = {files.name};

clean_roi_names = @(x) x(5:end-11);
rois_to_read = cellfun(clean_roi_names, only_rois, 'UniformOutput',false);


%{
rois_to_read = ["left-caudate";"right-caudate";"left-caudate_refined_matrix.nii";...    
    "left-caudate_upstream_striosome.nii";"left-caudate_downstream_striosome.nii"; "left-caudate_full_matrix.nii";...
    "a24_a32_lh"; "final_SN"; "Hb_mni" ; "a24_a32_rh"; "Thalamus-MD_rh"; ...
    "Area-3a_rh"; "Area-3a_lh"; "Area-4p_rh"; "Area-4p_lh"; "left-putamen"; ...
    "Area-p24ab.p24a_lh152"; "Area-p24ab.p24a_rh152"; "Area-p32_rh152"; "Area-p32_lh152"; ...
    "Amygdala-LB.Bl_rh152"; "Amygdala-LB.Bl_lh152"]; 
%}

strio_filename = "striosome_projection_rankings_v1.xlsx";

[processed_activities, cross_corrs, strio_projecting_regions, matrix_projecting_regions, brain_region_names, voxel_ref, rankings] = ...
    process_input_data(data_dir, subjectid, use_cross_corr, dms_name, strio_filename, rois_to_read);

% plotting activities on the whole

dirs = data_dir + "/results";
mkdir(dirs)

regions_to_plot = [rois_to_read];

[mean_activities, transients, variances, output_activity_table] = plot_avg_activity_of_brs(processed_activities, cross_corrs, voxel_ref, dms_name, ...
        brain_region_names, regions_to_plot, regions_to_hotspot, subjectid, dirs, smooth_factor);

saveas(gcf, dirs+ "/activities.fig")

% split by task + everything
close all

timing_dir = timing_base_dir + "/" + subjectid + "/timing_files_nopmod";
timing_table = ordering_timing_files(timing_dir);
timing_table.paricipant = repelem(subjectid, height(timing_table), 1);

output_activity_table = struct2table(output_activity_table);
%activity_at_action = outerjoin(timing_table, output_activity_table,"MergeKeys",1, "Keys", {'onset_time_step'});
%activity_filled = fillmissing(activity_at_action, 'previous');
%activity_filled.subjectidnumber = repelem(subjectid, height(activity_filled), 1);

end