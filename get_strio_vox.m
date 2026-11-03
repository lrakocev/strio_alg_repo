function [labeled_regions, voxel_striosomality, special_vox, corr_threshold] = ...
    get_strio_vox(all_subjects, corrs, voxel_ref, base_roi_name, brain_region_names, ...
    use_cross_corr, std_threshold)

base_index = find(brain_region_names{1,1}==base_roi_name);
dms_index = find(brain_region_names{1,1}=='left-caudate');

n_subj = length(all_subjects);

for subj=1:n_subj
    corr_matrix = corrs{1,subj}{base_index, dms_index};
    if base_roi_name=="Hb_mni"
        corr_matrix = -1*corr_matrix;
    end
    
    mean_corr_dms_to_base = mean(corr_matrix, 'all','omitnan');
    sd_corr_dms_to_base = std(corr_matrix,0,'all','omitnan');
    
    % if i'm passing in a std deviation threshold vs a correlation
    % threshold
    if std_threshold > 1
        corr_threshold =  mean_corr_dms_to_base + std_threshold*sd_corr_dms_to_base;
    else
        corr_threshold = std_threshold; 
    end

    hi_corr_vox = (corr_matrix > corr_threshold);
    
    base_thresh = 3;
    dms_thresh = 0;

    num_hi_cnx_base = sum(hi_corr_vox, 2);
    hi_base_idx = find(num_hi_cnx_base > base_thresh);

    % connections between striatal voxels only to those high likelihood LH vox
    dms_to_high_base = hi_corr_vox(hi_base_idx,:);
    num_hi_cnx_dms = sum(dms_to_high_base, 1);

    % get the actual voxels
    special_vox{1} = num_hi_cnx_base > base_thresh;
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
            if ~isempty(special_vox_br)
                if special_vox_br(vox) == 1
                    if ind == dms_index % within the striatum
                        labeled_regions{subj}(new_vox_idx(1),new_vox_idx(2),new_vox_idx(3)) = 99;
                        voxel_striosomality{subj}(new_vox_idx(1),new_vox_idx(2),new_vox_idx(3)) = 1;
                    else
                        labeled_regions{subj}(new_vox_idx(1),new_vox_idx(2),new_vox_idx(3)) = 100;
                        voxel_striosomality{subj}(new_vox_idx(1),new_vox_idx(2),new_vox_idx(3)) = 1;
                    end
                else
                    labeled_regions{subj}(new_vox_idx(1),new_vox_idx(2),new_vox_idx(3)) = br;
                    voxel_striosomality{subj}(new_vox_idx(1),new_vox_idx(2),new_vox_idx(3)) = 0;
                end
            
            else
                labeled_regions = [];
                voxel_striosomality = [];
                return
            end
        end
    end
end

end
