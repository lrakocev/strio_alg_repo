function activity_table = compare_activity_across_clusters(cluster_table_file, sub_names, activities, voxel_ref, brain_region_names,regions_to_hotspot,regions_to_plot,dms_name,smooth_factor)

cluster_table = readtable(cluster_table_file);

activity_table = [];

num_brs = cellfun(@length,brain_region_names) ;
[max_br_names, max_br_list_indx] = max(num_brs);

region_order_in_striosomalities = ["a24_a32_lh"; "final_SN"; "Hb_mni" ; "a24_a32_rh"; "Thalamus-MD_rh152"]; 
derived_types = ["Matrix", "Strio"];
full_br_list = brain_region_names{1,max_br_list_indx};
for j = 1:length(sub_names)
    subid = sub_names(j);
    activity = activities{1,j};
    br_names = brain_region_names{1,j};

    load("results/" + subid + "/striosomalities_newfis.mat")
    load("results/" + subid + "/combined_list_newfis.mat")

    for i = 1:length(regions_to_plot)
        name = regions_to_plot(i);

        if contains(name, derived_types)

            dms_index = find(brain_region_names{1,1} == dms_name);
            br_activity = activity{1,dms_index};

            lh_index = find(region_order_in_striosomalities=="Hb_mni");
            sn_index = find(region_order_in_striosomalities=="final_SN");
            lh_striosomality = striosomalities(lh_index, :);
            sn_striosomality = striosomalities(sn_index, :);
            downstream_striosomalities = [lh_striosomality; sn_striosomality];
            
            [upstream_list, downstream_list, both_list] = combine_upstream_downstream_fuzzy_logic(combined_strio_list, downstream_striosomalities); 
            head_vox = get_caudate_head(brain_region_names, voxel_ref{1,j});

            both_dms = both_list.* head_vox;
            matrix  = ((upstream_list == 0) & (downstream_list == 0) & (both_list == 0)) .* head_vox;

            if name == "Matrix"
                br_activity = br_activity(matrix == 1, :);
            else
                br_activity = br_activity(both_dms == 1, :);
            end
        else
            br_index = find(brain_region_names{1,1} == name);
            br_activity = activity{1,br_index};
        end

        %{
        if contains(regions_to_hotspot, name)
            [voxel_rows_w_high_connectivity, ~] = isolate_lh(cross_corrs, voxel_ref, name, dms_name, brain_region_names);
            activity = br_activity(voxel_rows_w_high_connectivity,:);
        end
        %}
        std_of_each_vox = std(br_activity,[],2);
        mean_of_each_vox = mean(br_activity,2);
        
        norm_of_each_vox = (br_activity - mean_of_each_vox) ./ std_of_each_vox;

        norm_activity  = mean(norm_of_each_vox,'omitnan');
        raw_activity = mean(br_activity, 'omitnan');
        smoothed_activity = movmean(raw_activity, smooth_factor);
        

        try
            transients = calc_transients(smoothed_activity);
        catch
            transients = 0;
        end

        name = replace(name, "-", "_");
        name = replace(name, ".", "_");

        row.(name + "_mean") = mean(smoothed_activity,'omitnan');
        row.(name + "_transients") = transients;
        row.(name + "_var") = var(smoothed_activity, 'omitnan');

    end

    if length(br_names) < max_br_names
        missing_brs = setdiff(full_br_list, br_names);

        for k = 1:length(missing_brs)
            missing_name = missing_brs(k);
            missing_name = replace(missing_name, "-", "_");
            missing_name = replace(missing_name, ".", "_");

            row.(missing_name + "_mean") = NaN;
            row.(missing_name + "_transients") = NaN;
            row.(missing_name + "_var") = NaN;

        end
    end

    row.subjectidnumber = subid;

    clusteridx = cluster_table(cluster_table.id == "K" + subid, :).cluster_idx;

    if isempty(clusteridx)
        clusteridx = NaN;
    end
    row.clusteridx = clusteridx;

    activity_table = [activity_table; row];
    clear striosomalities combined_strio_list

end

activity_table = struct2table(activity_table);
activity_table = activity_table(~isnan(activity_table.clusteridx),:);
unique_clsters = unique(activity_table.clusteridx);
num_clusters = length(unique_clsters);
for l = 1:length(regions_to_plot)
    curr_br = regions_to_plot(l);

    curr_br = replace(curr_br, "-", "_");
    curr_br = replace(curr_br, ".", "_");

    mean_means_in_cluster = [];
    mean_transients_in_cluster = [];
    mean_vars_in_cluster = [];
    for m = 1:num_clusters
        cluster_idx = unique_clsters(m);
        cluster_table = activity_table(activity_table.clusteridx == cluster_idx, :);
   
        mean_activity = mean(cluster_table.(curr_br +"_mean"), 'omitnan');
        mean_transients = mean(cluster_table.(curr_br +"_transients"), 'omitnan');
        mean_var = mean(cluster_table.(curr_br +"_var"), 'omitnan');

        mean_vars_in_cluster = [mean_vars_in_cluster; mean_var];
        mean_means_in_cluster = [mean_means_in_cluster; mean_activity];
        mean_transients_in_cluster = [mean_transients_in_cluster; mean_transients];
    end

    figure

    nexttile
    bar(1:num_clusters, mean_means_in_cluster)
    title("means")
    xlabel("cluster idx")
    ylabel(curr_br + " mean activity in roi")

    nexttile
    bar(1:num_clusters, mean_transients_in_cluster)
    title("transients")
    xlabel("cluster idx")
    ylabel(curr_br + " mean num transients")

    nexttile
    bar(1:num_clusters, mean_vars_in_cluster)
    title("var in roi")
    xlabel("cluster idx")
    ylabel(curr_br + " mean var in roi")

    sgtitle("mean activity + transients + var across clusters for " + curr_br)



end