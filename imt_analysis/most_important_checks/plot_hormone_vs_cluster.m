function plot_hormone_vs_cluster(mt_sinai_w_clusters_n_stats)

num_clusters = 4;
hormones = ["aGHR", "TotalTestos_ng_dL_", "Estradiol_pg_mL_"];
for h = 1:3
    hormone = hormones(h);
    hormone_means = [];
    hormone_stds = [];
    figure
    for m = 1:num_clusters
        shift_cluster = mt_sinai_w_clusters_n_stats(mt_sinai_w_clusters_n_stats.cluster_idx == m, :);
        hormone_lvl = shift_cluster.(hormone);
        hormone_mean = mean(hormone_lvl, 'omitnan');
        hormone_std = std(hormone_lvl, 'omitnan') / sqrt(height(shift_cluster));
    
        hormone_means = [hormone_means; hormone_mean];
        hormone_stds = [hormone_stds; hormone_std];
    end
    errorbar(1:num_clusters, hormone_means, hormone_stds)
    title(hormone)
    xlabel("shift cluster number")
    ylabel(hormone + " level") 

end