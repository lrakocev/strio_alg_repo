%% cross corr 

names = brain_region_names{1,1};
thresholds = [2.5, 2.7, 3, 3.2];
for i = 1:length(names)
    base_roi_name = names(i);
    for j = 1:length(thresholds)
        for k = 0:1
            std_threshold = thresholds(j);
                        
            if k == 1
                [stat_labeled, stat_striosomality, special_vox] = get_strio_vox(all_subjects, cross_corrs, voxel_ref, base_roi_name, brain_region_names, k, std_threshold);
                cross_labels{i,j} = stat_labeled;
                cross_striosomalities{i,j} = stat_striosomality;
                cross_hi_projecting_vox{i,j} = special_vox{1};
                cross_striatum_vox{i,j} = special_vox{2};
            else
                [stat_labeled, stat_striosomality, special_vox] = get_strio_vox(all_subjects, granger_corrs, voxel_ref, base_roi_name, brain_region_names, k, std_threshold);
                granger_labels{i,j} = stat_labeled;
                granger_striosomalities{i,j} = stat_striosomality;
                granger_hi_projecting_vox{i,j} = special_vox{1};
                granger_striatum_vox{i,j} = special_vox{2};
            end
        end
    end
end


%% overlapping the two types

for i = 1:length(names)
    base_roi_name = names(i);
    for j = 1:length(thresholds)
        try
            num_granger_strio{i,j} = sum(granger_striatum_vox{i,j},'all');
            num_corr_strio{i,j} = sum(strio_striatum_vox{i,j},'all');
        
            both_strio{i,j} = granger_striatum_vox{i,j} + strio_striatum_vox{i,j};
            num_stat_overlaps{i,j} = sum(both_strio{i,j} == 2,'all');
        catch
            continue
        end
    end
end

%volumeViewer(both_striosomality{i,j}{1,1}, both_labeled{i,j}{1,1})
