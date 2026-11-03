%% create db of the brain activity per trial event

full_db = {};
failed_imt = [];
count = 1;
for i = 402:550
    subjectid = string(i);
    base_dir = "/sc/arion/projects/K01_VTA/users/rakocl01/";
    data_dir = base_dir + subjectid + "/imt_test/strio_voxel_dir_oct29";
    timing_base_dir = base_dir + "subj_list";
    
    timing_dir = timing_base_dir + "/" + subjectid + "/timing_files_nopmod";
    
    try
        [timing_table, output_activity_table] = apply_time_series_breakdown_per_subject([subjectid], data_dir, timing_base_dir);

        full_db{count} = {timing_table, output_activity_table};
        count = count + 1;
    catch
        failed_imt = [failed_imt; subjectid];
    end
end

save("all_vox_activity_10212026.mat")
