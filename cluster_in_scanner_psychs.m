function [rew_cluster_table, cost_cluster_table] = cluster_in_scanner_psychs(in_scanner_table, num_clusters_rew, num_clusters_cost, save_to)

psych_table = in_scanner_table(:, ["rew_a", "rew_b", "rew_c", "cost_a","cost_b","cost_c"]);
psych_table = unique(psych_table, "rows");

rew_rawXvsYvsZ = [psych_table.rew_a,psych_table.rew_b,psych_table.rew_c];
cost_rawXvsYvsZ = [psych_table.cost_a,psych_table.cost_b,psych_table.cost_c];

log_abs_rew = log(abs(rew_rawXvsYvsZ));
log_abs_cost = log(abs(cost_rawXvsYvsZ));

rew_cluster_table = helper_clustering_func(psych_table, log_abs_rew, num_clusters_rew, "rew", save_to);
cost_cluster_table = helper_clustering_func(psych_table, log_abs_cost, num_clusters_cost, "cost", save_to);

end

function in_scanner_cluster_table = helper_clustering_func(in_scanner_table, coords, num_clusters, rew_or_cost, save_to)

 
    opt = fcmOptions(NumClusters = num_clusters);
    [~,U,~,info] = fcm(coords,opt);
    
    mpc = calculate_mpc(U);
    maxU = max(U);
    
    colors = distinguishable_colors(num_clusters);
    
    figure;
    scatters = [];
    in_scanner_cluster_table = [];
    for j=1:num_clusters
        current_color = colors(j,:);
        indexes = find(U(j,:)==maxU);
    
        idx_rows = in_scanner_table(indexes, :);
        idx_rows.cluster_idx = repelem(j,height(idx_rows),1);
        in_scanner_cluster_table = [in_scanner_cluster_table; idx_rows];
        scatter_object = scatter3(coords(indexes, 1) ,coords(indexes, 2), coords(indexes, :), [], current_color);
        hold on
        scatters = [scatters ; scatter_object];
    
    end
    
    legend(scatters(:,1), string(1:num_clusters)); 
    xlabel("x coord");
    ylabel("y coord");
    zlabel("z coord")
    title("clustering for mt sinai in scanner data across " + rew_or_cost + ...
        " mpc = " + string(mpc) + ", num clusters = " + string(num_clusters))
    savefig(save_to + "\mt_sinai_in_scanner_clusters_" + rew_or_cost + ".fig")

end

