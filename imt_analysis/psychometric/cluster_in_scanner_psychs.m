function cluster_table = cluster_in_scanner_psychs(psych_table, var_1, var_2, num_clusters, rew_or_cost, save_to)


rawXvsYvsZ = [psych_table.(var_1),psych_table.(var_2)]; %psych_table.rew_a
rawXvsYvsZ = rawXvsYvsZ(~isnan(sum(rawXvsYvsZ, 2)), :);

log_abs = log(abs(rawXvsYvsZ));

cluster_table = helper_clustering_func(psych_table, log_abs, num_clusters, rew_or_cost, save_to);

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
        scatter_object = scatter(coords(indexes, 2), coords(indexes, :), [], current_color); %coords(indexes, 1) ,
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

