function run_all_bar_plots(left_hotspot_cluster_activity,right_hotspot_cluster_activity, ...
    left_hotspot_cluster_num_cnx, right_hotspot_cluster_num_cnx, ...
    left_hotspot_cluster_num_strio, right_hotspot_cluster_num_strio, ...
    left_strio_cluster_activity, right_strio_cluster_activity, ...
    left_hotspot_cost_cluster_activity, right_hotspot_cost_cluster_activity, ...
    left_hotspot_cost_cluster_num_cnx, right_hotspot_cost_cluster_num_cnx, ...
    left_hotspot_cost_cluster_num_strio, right_hotspot_cost_cluster_num_strio, ...
    left_strio_cost_cluster_activity, right_strio_cost_cluster_activity, save_to)


mkdir(save_to)

bar_plot_helper(left_hotspot_cluster_activity, "left striosomes-connected SNC hotspot activity v REW clusters", "hotspot activity", "cluster number",  save_to)

bar_plot_helper(right_hotspot_cluster_activity, "right striosomes-connected SNC hotspot activity v REW clusters","hotspot activity",  "cluster number",  save_to)

bar_plot_helper(left_hotspot_cluster_num_cnx, "num high left strio-snc connections v REW clusters", "num strio-snc cnx", "cluster number",  save_to)

bar_plot_helper(right_hotspot_cluster_num_cnx, "num high right strio-snc connections v REW clusters", "num strio-snc cnx", "cluster number",  save_to)

bar_plot_helper(left_hotspot_cluster_num_strio, "num left striosomes v REW clusters","num striosomes", "cluster number",  save_to)

bar_plot_helper(right_hotspot_cluster_num_strio, "num right striosomes v REW clusters","num striosomes",  "cluster number", save_to)

bar_plot_helper(left_strio_cluster_activity, "left strio activity v REW clusters", "strio activity", "cluster number",  save_to)

bar_plot_helper(right_strio_cluster_activity, "right strio activity v REW clusters", "strio activity",  "cluster number", save_to)

bar_plot_helper(left_hotspot_cost_cluster_activity, "left striosomes-connected SNC hotspot activity v COST clusters","hotspot activity",  "cluster number", save_to)

bar_plot_helper(right_hotspot_cost_cluster_activity, "right striosomes-connected SNC hotspot activity v COST clusters","hotspot activity",  "cluster number", save_to)

bar_plot_helper(left_hotspot_cost_cluster_num_cnx, "num high left strio-snc connections v COST clusters","num strio-snc cnx",  "cluster number",  save_to)

bar_plot_helper(right_hotspot_cost_cluster_num_cnx, "num high right strio-snc connections v COST clusters","num strio-snc cnx",  "cluster number",  save_to)

bar_plot_helper(left_hotspot_cost_cluster_num_strio, "num left striosomes v COST clusters", "num striosomes",  "cluster number", save_to)

bar_plot_helper(right_hotspot_cost_cluster_num_strio, "num right striosomes v COST clusters","num striosomes", "cluster number",  save_to)

bar_plot_helper(left_strio_cost_cluster_activity, "left strio activity v COST clusters", "strio activity", "cluster number",  save_to)

bar_plot_helper(right_strio_cost_cluster_activity, "right strio activity v COST clusters", "strio activity", "cluster number",  save_to)

end
