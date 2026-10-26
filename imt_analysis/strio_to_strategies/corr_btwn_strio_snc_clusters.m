function [corr_grid] = corr_btwn_strio_snc_clusters(strio_table, snc_table, want_plot)

num_strio_clusters = length(unique(strio_table.cluster_idx));
num_snc_clusters = length(unique(snc_table.cluster_idx));


corr_grid = zeros(num_strio_clusters, num_snc_clusters);
for strio_cluster = 1:num_strio_clusters
    curr_strio_cluster_table = strio_table(strio_table.cluster_idx == strio_cluster, :);
    curr_strio_activities = curr_strio_cluster_table.vox_activity;

    for snc_cluster = 1:num_snc_clusters
        curr_snc_cluster_table = snc_table(snc_table.cluster_idx == snc_cluster, :);
        curr_snc_activities = curr_snc_cluster_table.vox_activity;

        corrs_curr_snc_to_strio_cluster = corr(curr_strio_activities', curr_snc_activities');
        %for j = 1:size(curr_strio_activities,1)
        %    for k = 1:size(curr_snc_activities,1)
        %        curr_pairwise_corr = corr(curr_strio_activities(j, :), curr_snc_activities(k, :));
        %        corrs_curr_snc_to_strio_cluster = [corrs_curr_snc_to_strio_cluster; curr_pairwise_corr];
        %    end
        %end
        avg_corr_curr_snc_to_strio_cluster = mean(corrs_curr_snc_to_strio_cluster,'all', 'omitnan');
    
        corr_grid(strio_cluster, snc_cluster) = avg_corr_curr_snc_to_strio_cluster;

    end
end

if want_plot
figure
imagesc(corr_grid)
xlabel("snc clusters")
ylabel("strio clusters")
colorbar
clim([min(corr_grid,[],"all") max(corr_grid,[],"all")])
title("avg corr btwn vox in strio region vs snc region")
end

end