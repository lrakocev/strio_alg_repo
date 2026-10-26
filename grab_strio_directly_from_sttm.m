function row = grab_strio_directly_from_sttm(subj_id, dms_name)

task_dir ="C:/Users/lrako/OneDrive/Documents/mt_sinai/copy_task_sttm/" + subj_id;
subj_dir = "C:/Users/lrako/OneDrive/Documents/mt_sinai/subject_viz/copy_to_local/" + subj_id;

fuzzy_logic_dir = subj_dir + "/testresults/testresults";

load(fuzzy_logic_dir + "/" + dms_name + "_striosomalities_fis.mat")
load(fuzzy_logic_dir + "/" + dms_name + "_combined_list_fis.mat")


% ordering of this list is important - do not change pls
strio_regions = ["a24_a32_lh"; "final_SN"; "Hb_mni" ; "a24_a32_rh"; "Thalamus-MD_rh152"];

all_subjects = [subj_id];
use_cross_corr = 0;
strio_filename = "striosome_projection_rankings_v1.xlsx";
regions_to_load = [dms_name];

[processed_activities, cross_corrs, strio_projecting_regions, matrix_projecting_regions, brain_region_names, voxel_ref, rankings] = ...
    process_input_data(task_dir, all_subjects, use_cross_corr, dms_name, strio_filename, regions_to_load);

dms_idx = find(brain_region_names{1,1} == dms_name);
dms_voxel_ref = voxel_ref{1,1}{1,dms_idx};
dms_activities = processed_activities{1,1}{1,dms_idx};

lh_index = find(strio_regions=="Hb_mni");
sn_index = find(strio_regions=="final_SN");
lh_striosomality = striosomalities(lh_index, :);
sn_striosomality = striosomalities(sn_index, :);

lh_strio_activity = dms_activities(lh_striosomality > 0, :); 
sn_strio_activity = dms_activities(sn_striosomality > 0, :);
upstream_strio_activity = dms_activities(combined_strio_list > 0, :);

row.subj_id = subj_id; 
row.lh_strio_activity = {lh_strio_activity};
row.sn_strio_activity = {sn_strio_activity};
row.upstream_strio_activity = {upstream_strio_activity};
row.left_caudate_activity = {dms_activities};

end