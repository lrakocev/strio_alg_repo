function [labeled_regions, voxel_striosomality, special_vox] = get_strio_vox(all_subjects, corrs, voxel_ref, base_roi_name, brain_region_names, use_cross_corr)

base_index = find(brain_region_names{1,1}==base_roi_name);
dms_index = find(brain_region_names{1,1}=='left-caudate');

n_subj = length(all_subjects);

for subj=1:n_subj
    corr_matrix = corrs{1,subj}{base_index, dms_index};
    if use_cross_corr
        corr_matrix = corr_matrix*-1;
    end
    
    mean_corr_dms_to_base = mean(corr_matrix, 'all');
    sd_corr_dms_to_base = std(corr_matrix,0,'all');
    
    if use_cross_corr
        num_std_devs_dms = 2;
        num_std_devs_base = 3;
    else
        num_std_devs_dms = 3;
        num_std_devs_base = 6; 
    end
    
    hi_corr_vox = (corr_matrix > mean_corr_dms_to_base + num_std_devs_dms*sd_corr_dms_to_base);
    extra_hi_corr_vox = (corr_matrix > mean_corr_dms_to_base + num_std_devs_base*sd_corr_dms_to_base);
    
    num_xtra_hi_cnx_base = sum(extra_hi_corr_vox, 2);
    
    hi_base_idx = find(num_xtra_hi_cnx_base > 3);
    
    % connections between striatal voxels only to those high likelihood LH vox
    dms_to_high_base = hi_corr_vox(hi_base_idx,:);
    dms_to_xtra_high_lh = extra_hi_corr_vox(hi_base_idx, :);
    
    num_hi_cnx_dms = sum(dms_to_high_base, 1);
    num_xtra_hi_cnx_dms = sum(dms_to_xtra_high_lh, 1);
    
    % get the actual voxels
    
    base_thresh = 3;
    all_base_vox = voxel_ref{1,subj}{1,base_index};
    base_vox_coords = all_base_vox(num_xtra_hi_cnx_base > base_thresh,: );
    
    dms_thresh = 0;
    all_dms_vox = voxel_ref{1,subj}{1,dms_index};
    dms_vox_coords = all_dms_vox(num_hi_cnx_dms > dms_thresh,:);
    
    special_vox{1} = num_xtra_hi_cnx_base > base_thresh;
    special_vox{2} = num_hi_cnx_dms > dms_thresh;

    min_coords{subj} = [nan nan nan];
    for br=1:length(voxel_ref{subj})
        min_coords{subj} = min(min_coords{subj}, min(voxel_ref{subj}{br}));
    end

    % store the data in voxel grids
    curr_rois = [base_index, dms_index];
    for br = 1:length(curr_rois)
        ind = curr_rois(br);
        for vox=1:size(voxel_ref{subj}{ind},1)
            % note the coordinate change: index 1 is used for the min. voxel id
            new_vox_idx = voxel_ref{subj}{ind}(vox,:)-min_coords{subj}+1;
    
            special_vox_br = special_vox{br};
            % basically, if vox in the right vox list, mark that labeled_region
            % and voxel_striosomality correctly
            if length(special_vox_br)==length(voxel_ref{subj}{ind},1)
                if special_vox_br(vox) == 1
                    labeled_regions{subj}(new_vox_idx(1),new_vox_idx(2),new_vox_idx(3)) = 99;
                    voxel_striosomality{subj}(new_vox_idx(1),new_vox_idx(2),new_vox_idx(3)) = 1;
                else
                    labeled_regions{subj}(new_vox_idx(1),new_vox_idx(2),new_vox_idx(3)) = br;
                    voxel_striosomality{subj}(new_vox_idx(1),new_vox_idx(2),new_vox_idx(3)) = 0;
                end
            end
        end
    end
end

end
