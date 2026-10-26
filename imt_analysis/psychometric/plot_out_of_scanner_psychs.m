function  [left_hotspot_cluster_activity,right_hotspot_cluster_activity, ...
    left_hotspot_cluster_num_cnx, right_hotspot_cluster_num_cnx, ...
    left_hotspot_cluster_num_strio, right_hotspot_cluster_num_strio, ...
    left_strio_cluster_activity, right_strio_cluster_activity] = ...
    plot_out_of_scanner_psychs(in_scanner_table, out_of_scanner_clusters)

out_of_scanner_clusters = renamevars(out_of_scanner_clusters, "participant", "subjectidnumber");
in_and_out_joined = outerjoin(in_scanner_table, out_of_scanner_clusters, "MergeKeys", 1, "Keys", {'subjectidnumber'});

in_and_out_joined = in_and_out_joined(~isnan(in_and_out_joined.cluster_idx), :);

unique_outside_clusters = unique(in_and_out_joined.cluster_idx);
num_clusters = max(unique_outside_clusters);

left_hotspot_cluster_activity = cell(1, num_clusters);
right_hotspot_cluster_activity = cell(1, num_clusters);

left_strio_cluster_activity = cell(1, num_clusters);
right_strio_cluster_activity = cell(1, num_clusters);

left_hotspot_cluster_num_cnx = cell(1, num_clusters);
right_hotspot_cluster_num_cnx = cell(1, num_clusters);

left_hotspot_cluster_num_strio = cell(1, num_clusters);
right_hotspot_cluster_num_strio = cell(1, num_clusters);


for j = 1:num_clusters

    outside_cluster_table = in_and_out_joined(in_and_out_joined.cluster_idx == j, :);

    left_hotspot_cluster_activity{j} = outside_cluster_table.left_hotspot_cluster_activity;
    right_hotspot_cluster_activity{j} = outside_cluster_table.right_hotspot_cluster_activity;


    left_strio_cluster_activity{j} = outside_cluster_table.left_strio_cost_cluster_activity;
    right_strio_cluster_activity{j} = outside_cluster_table.right_strio_cost_cluster_activity;

    left_hotspot_cluster_num_cnx{j} = outside_cluster_table.left_hotspot_cluster_num_cnx;
    right_hotspot_cluster_num_cnx{j} = outside_cluster_table.right_hotspot_cluster_num_cnx;


    left_hotspot_cluster_num_strio{j} = outside_cluster_table.left_hotspot_cost_cluster_num_strio
    right_hotspot_cluster_num_strio{j} = outside_cluster_table.right_hotspot_cost_cluster_num_strio

end

end