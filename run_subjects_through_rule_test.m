want_viz = 0;
subj_names = ["420"]; %"420","444","453","454","529","544","547","548"]; %545, 546

% "420";"431";"442";"444";"445";"453";"454";...
%    "519";"529";"544";"547";"548"
for j = 1:length(subj_names)
    sub_id = subj_names(j);
    clear striosomalities combined_strio_list
    close all

    load("results/" + sub_id + "/striosomalities_newfis.mat")
    load("results/" + sub_id + "/combined_list_newfis.mat")
    run_second_half_rule_test(sub_id, striosomalities, combined_strio_list,want_viz);
    %{
    try 
        clear striosomalities combined_strio_list
        close all
       [striosomalities, combined_strio_list] = run_full_rule_test(sub_id);
    catch
       continue
    end
    %}
end

%%

all_subjects = ["420";"431";"442";"444";"445";...
    "453";"454";"519";"529";"544";"545";"546";"547";"548"];

dms_name="left-caudate";
use_cross_corr = 0;
strio_filename = "striosome_projection_rankings_v1.xlsx";

[processed_activities,brain_region_names,...
    n_region,voxel_ref,n_subject,n_tsteps] = load_data(all_subjects,'all');

mt_sinai_cluster = "C:\Users\lrako\OneDrive\Documents\human_dm\dec_2025\mt_sinai_original\mt_sinai_clusters_original.xlsx";
activity_table = compare_activity_across_clusters(mt_sinai_cluster, all_subjects, ...
    processed_activities, voxel_ref, brain_region_names, regions_to_hotspot, regions_to_plot, dms_name, smooth_factor);
    
