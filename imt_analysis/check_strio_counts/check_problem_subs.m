%% looking at corrs in subs where the alg works vs not

all_sub = dir('C:\Users\lrako\OneDrive\Documents\mt_sinai\subject_viz\copy_to_local');
all_subs = string({all_sub.name});

dms_name = "left-caudate";
regions_to_load = [dms_name;  "Thalamus-MD_rh_MNI152"];

strio_filename = "striosome_projection_rankings_v1.xlsx";
want_plot = 0;

expanded_subs_table = [];
for j = 1:20 %length(all_subs)
    subj = all_subs(j);

    subj_dir ="C:/Users/lrako/OneDrive/Documents/mt_sinai/subject_viz/copy_to_local/" + subj;
    voxel_dir = subj_dir + "/voxel_dir/voxel_dir";

    try
        [processed_activities, cross_corrs, strio_projecting_regions, matrix_projecting_regions, brain_region_names, voxel_ref, rankings] = ...
            process_input_data(voxel_dir, [subj], 1, dms_name, strio_filename, regions_to_load);
    
        subj_table = quick_corr_histogram(subj, cross_corrs, voxel_ref, brain_region_names, "hist", want_plot);
    
        expanded_subs_table = [expanded_subs_table; subj_table];
    catch
        continue
    end

end


expanded_subs_table = struct2table(expanded_subs_table);

%%

zero_strio_subs = string([443, 514, 503, 549, 409, 435, 508, 413, 528, 524, 506, 525, 445, 519, 447, 529, 415]);
many_strio_subs = string([507, 438, 537, 543, 431, 418]);

good_ex_subs = setdiff(setdiff(all_subs,zero_strio_subs), many_strio_subs);

sub_tits = {"all"}; %"normal strio";"many strio";"zero strio"};
sub_types = {string([416;418])}; %all_subs)}; %good_ex_subs;many_strio_subs;zero_strio_subs};

plot_regions = ["Thalamus"] ;

feature_names = ["raw";"num_hi_cnx"; "top_ten_cnx_per_vox_mean"]; %["corrs_mean", "corrs_std", "corrs_skew"];


num_bins = 10;
for f = 1:length(feature_names)
    feat = feature_names(f);
    for p = 1:length(plot_regions)
        reg = plot_regions(p);
        %figure
        for s = 1:length(sub_types)
            sub_list = sub_types{s};
            for j = 1:size(sub_list,1)
                curr_sub = sub_list(j);

                sub_table = expanded_subs_table(expanded_subs_table.subj_id == curr_sub, :);

                if isempty(sub_table)
                    continue
                else
                    figure
                    
                    plot_histogram_for_subjs_and_br(expanded_subs_table, string(curr_sub), reg, feat, num_bins)
    
                    %hold on
                    legend(sub_tits{s})
                end
            end
        end

        %legend(sub_tits)
        %hold off
    end
end
