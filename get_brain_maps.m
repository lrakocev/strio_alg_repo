function output_grid = get_brain_maps(desired_table, brain_subdir, rois)

save_to = pwd + "\brain_maps\" + brain_subdir;
mkdir(save_to)

output_grid = {};
for j = 1:length(rois)
    roi = rois(j);
    roi_output_grid = plot_dec_making_map_mt_sinai(desired_table, save_to, roi);
    output_grid{j} = roi_output_grid;
end
plot_dec_making_map_mt_sinai(desired_table, save_to, "response_ext")

end