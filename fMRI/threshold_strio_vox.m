function [all_labels, all_striosomalities, hi_projecting_vox, striatum_vox, overlapped_vox] = ...
    threshold_strio_vox(all_subjects, corrs_to_use, threshold_table, br_names, voxel_ref, strio_filename)

names = br_names{1,1};
dms_index = find(names=='left-caudate');

[~, strio_projecting_regions, matrix_projecting_regions,~,~] =...
    load_striosome_projecting_rankings(strio_filename, br_names);

is_mem_strio = ismember(names,  string(strio_projecting_regions));
strio_ids = find(is_mem_strio);

is_mem_matrix = ismember(names,  string(matrix_projecting_regions));
matrix_ids = find(is_mem_matrix);

overlapped_vox = ones(1,length(voxel_ref{1,1}{1,dms_index}));
all_ids = [strio_ids; matrix_ids];
for i = 1:length(all_ids)
    id = all_ids(i);
    base_roi_name = names(id);

    corr_threshold = threshold_table(threshold_table.br == id, :).thresh;

    if ~isempty(corr_threshold)
        [cross_labeled, cross_striosomality, special_vox, corr_threshold] = ...
            get_strio_vox(all_subjects, corrs_to_use, voxel_ref, base_roi_name, br_names, 1, corr_threshold);
        
        all_labels{i} = cross_labeled;
        all_striosomalities{i} = cross_striosomality;
        hi_projecting_vox{i} = special_vox{1};
        striatum_vox{i} = special_vox{2};
        corr_thresholds{i} = corr_threshold;
         

        if ismember(id, matrix_ids)
            overlapped_vox = overlapped_vox & ~special_vox{2};
        else
            overlapped_vox = overlapped_vox & special_vox{2};
        end            
    end
    
end