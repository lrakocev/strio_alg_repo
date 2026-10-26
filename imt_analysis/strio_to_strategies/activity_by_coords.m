function br_lox_table =  activity_by_coords(br_activity, br_coords, br_name, num_clusters)

zero_activity_rows = [sum(br_activity, 2) == 0];

br_activity = br_activity(~zero_activity_rows, :);
br_coords = br_coords(~zero_activity_rows, :);

br_table = array2table(br_coords, "VariableNames", {'x_coord','y_coord','z_coords'});
br_table.vox_activity = br_activity;

opt = fcmOptions(NumClusters = num_clusters);
[~,U,~,info] = fcm(br_coords,opt);

mpc = calculate_mpc(U);
maxU = max(U);

colors = distinguishable_colors(num_clusters);

figure;
scatters = [];
br_lox_table = [];
for j=1:num_clusters
    current_color = colors(j,:);
    indexes = find(U(j,:)==maxU);

    idx_rows = br_table(indexes, :);
    idx_rows.cluster_idx = repelem(j,height(idx_rows),1);
    br_lox_table = [br_lox_table; idx_rows];

    scatter_object = scatter3(br_coords(indexes, 1) ,br_coords(indexes, 2), br_coords(indexes, :), [], current_color);
    hold on
    scatters = [scatters ; scatter_object];

end

legend(scatters(:,1), string(1:num_clusters)); 
xlabel("x coord");
ylabel("y coord");
zlabel("z coord");
title("location of " + br_name);

% avg correlation within each location-based cluster

overall_min = min(br_activity,[],"all");
overall_max = max(br_activity,[],"all");

avg_per_region = [];
stds_per_region = [];
for j = 1:num_clusters
    location_based_cluster_activity = br_lox_table(br_lox_table.cluster_idx == j, :);
    curr_br_activity = location_based_cluster_activity.vox_activity;
    figure
    imagesc(curr_br_activity)
    title(br_name + " activity in location-based cluster " + j)
    xlabel("time")
    ylabel(br_name + " neurons")
    colorbar
    clim([overall_min overall_max])
    
    avg_per_region = [avg_per_region; mean(curr_br_activity,"all")];
    curr_std = std(curr_br_activity(:)) / sqrt(height(location_based_cluster_activity));
    stds_per_region = [stds_per_region; curr_std];
end

figure
bar(1:num_clusters, avg_per_region)
hold on
errorbar(1:num_clusters, avg_per_region, stds_per_region)
title("avg activity per location-based cluster")
ylabel("avg " + br_name + " activity in location")
xlabel("location number")

end
