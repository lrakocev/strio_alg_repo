function [snc_hotspot_vox, hotspot_activity] = get_high_corr_snc_vox(strio_activity_table, snc_activity_table, corr_thresh)

[corr_grid] = corr_btwn_strio_snc_clusters(strio_activity_table, snc_activity_table, 0);

[strio_idx, snc_hotspot_idx] = find(abs(corr_grid) > corr_thresh);
snc_hotspot_vox = unique(snc_hotspot_idx);

activity = snc_activity_table.vox_activity; 
hotspot_activity = activity(snc_hotspot_vox, :);

end