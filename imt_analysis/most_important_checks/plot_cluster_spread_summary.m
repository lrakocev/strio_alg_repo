function plot_cluster_spread_summary(brain_cluster_table)

    subs_per_clust = [];
    hs = [];
    num_clusters = 4;
    colors = distinguishable_colors(num_clusters);
    for m = 1:num_clusters
        hormone_lvl_table = brain_cluster_table(brain_cluster_table.cluster_idx == m, :);
        num_unique_subs = length(unique(hormone_lvl_table.K01_SUBID));
        subs_per_clust = [subs_per_clust; num_unique_subs];
       
        h = scatter3(hormone_lvl_table.x_coord, hormone_lvl_table.y_coord, hormone_lvl_table.z_coord, 20, ...
            colors(m, :));
        hold on
        hs = [hs; h];
    end
    legend(hs)
    xlabel("max")
    ylabel("shift")
    zlabel("slope")
    hold off
    figure
    bar(1:length(subs_per_clust), subs_per_clust)
    title("number of subjects per cluster")
    xlabel("cluster number")
    ylabel("num subjects")

end