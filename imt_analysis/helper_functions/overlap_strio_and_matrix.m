function row = overlap_strio_and_matrix(subj_id, mat_input_dir, dms_name, want_plot)

subj_dir ="C:/Users/lrako/OneDrive/Documents/mt_sinai/subject_viz/copy_to_local/" + subj_id;
mat_dir = mat_input_dir + "/" + subj_id;

fuzzy_logic_strio_dir = subj_dir + "/testresults/testresults";
fuzzy_logic_mat_dir = mat_dir + "/testresults/testresults";

voxel_dir = subj_dir + "/voxel_dir/voxel_dir";
mask_dir = subj_dir + "/output_masks";
mkdir(mask_dir)

load(fuzzy_logic_strio_dir + "/" + dms_name + "_striosomalities_fis.mat")
load(fuzzy_logic_mat_dir + "/" + dms_name + "_matrisomalities_newfis.mat")

all_regions = ["a24_a32_lh"; "final_SN"; "Hb_mni" ; "a24_a32_rh"; "Thalamus-MD_rh152"; "Area-p24ab.p24a_rh"; "Area-p32_rh"]; 

% ordering of this list is important - do not change pls
strio_regions = ["a24_a32_lh"; "final_SN"; "Hb_mni" ; "a24_a32_rh"; "Thalamus-MD_rh152"];

all_subjects = [subj_id];
use_cross_corr = 1;
strio_filename = "striosome_projection_rankings_v1.xlsx";
regions_to_load = [dms_name];

if want_plot
    [processed_activities, cross_corrs, strio_projecting_regions, matrix_projecting_regions, brain_region_names, voxel_ref, rankings] = ...
    process_input_data(voxel_dir, all_subjects, use_cross_corr, dms_name, strio_filename, regions_to_load);

    dms_idx = find(brain_region_names{1,1} == dms_name);
    dms_voxel_ref = voxel_ref{1,1}{1,dms_idx};
end

save_to = "C:\Users\lrako\OneDrive\Documents\mt_sinai\subject_viz_ex\" + subj_id;
mkdir(save_to)


load(fuzzy_logic_strio_dir + "/" + dms_name + "_combined_list_fis.mat")
load(fuzzy_logic_mat_dir + "/" + dms_name + "_combined_mat_list_newfis.mat")

lh_index = find(strio_regions=="Hb_mni");
sn_index = find(strio_regions=="final_SN");
lh_striosomality = striosomalities(lh_index, :);
sn_striosomality = striosomalities(sn_index, :);
downstream_striosomalities = [lh_striosomality; sn_striosomality];

[upstream_list, downstream_list, both_list, actual_matrix] = combine_upstream_downstream_matrix(combined_strio_list, downstream_striosomalities, combined_mat_list); 

row.subj_id = subj_id;
row.upstream_list = combined_strio_list;
row.lh_list = lh_striosomality;
row.snc_list = sn_striosomality;
row.actual_matrix = combined_mat_list;

row.tot_sttm = length(combined_mat_list);
row.tot_mat = sum(combined_mat_list > 0);

s_m_ratio_lh = lh_striosomality - combined_mat_list ./ (lh_striosomality + combined_mat_list);
s_m_ratio_snc = sn_striosomality - combined_mat_list ./ (sn_striosomality + combined_mat_list);
s_m_ratio_upstream = combined_strio_list - combined_mat_list ./ (combined_strio_list + combined_mat_list);

row.s_m_ratio_lh = s_m_ratio_lh;
row.s_m_ratio_snc = s_m_ratio_snc;
row.s_m_ratio_upstream = s_m_ratio_upstream;


axis_combos = [1 2; 1 3; 2 3];

strio_lists = [combined_mat_list];
strio_types = ["matrix detected"];

if want_plot
    %for k = 1:length(axis_combos)
    %    axis_combo = axis_combos(k,:);
    %    axis_1 = axis_combo(1);
    %    axis_2 = axis_combo(2);
   
    axis_1 = 2; axis_2 = 3; 
    figure
    plot_2d_outline_of_br(brain_region_names, axis_1, axis_2, voxel_ref, dms_name, 'b');

    colors = distinguishable_colors(length(strio_regions));
    hs = [];
    for roi_idx = 1:size(strio_lists,1)
        strio_type = strio_types(roi_idx);
          
        % plot striosomomes defined by ROI
        hold on
        h = scatter_striosomes(dms_voxel_ref, strio_lists, roi_idx, axis_1, axis_2, colors(roi_idx, :));
        hs = [hs; h];  
    end

    legend(hs, strio_types)
    title("subj id: " + subj_id + " S-M/S+M diff versions with axis combo " + axis_1 + ", " + axis_2)
    set(gcf,'renderer','Painters')
    saveas(gcf, save_to + "\matrix.fig")
    saveas(gcf, save_to + "\matrix.svg")
    close all

    
   % end
end
end
