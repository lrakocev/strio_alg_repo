function plot_brain_activity_v_hormone(br_activity_table, brs_of_interest, num_bins, save_to)

hormone_bin_names = ["ghr_bin"; "testos_bin"; "estr_bin"];
for h = 1:length(hormone_bin_names)
    hormone_bin_name = hormone_bin_names(h);
    plot_brain_activity_per_feature(br_activity_table, hormone_bin_name, brs_of_interest, num_bins, save_to)

end