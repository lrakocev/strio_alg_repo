function threshold_alg_v2(subj,brain_region_names, cross_corrs, strio_filename, use_whole_br)

[~, strio_projecting_regions, matrix_projecting_regions,~,...
    ~] = load_striosome_projecting_rankings(strio_filename, brain_region_names);

br_names = brain_region_names{1,1};

is_mem_strio = ismember(br_names,  string(strio_projecting_regions));
strio_ids = find(is_mem_strio);

is_mem_matrix = ismember(br_names,  string(matrix_projecting_regions));
matrix_ids = find(is_mem_matrix);

dms_index = find(br_names=='left-caudate');

if ~use_whole_br
    strio_br_corrs = [];
    for s = 1:length(strio_ids)
        strio_id = strio_ids(s);
        corr_matrix = cross_corrs{1,1}{strio_id, dms_index}; 
        max_corr = max(corr_matrix, [], 1);
    
        strio_br_corrs = [strio_br_corrs; max_corr];
    end
    
    matrix_br_corrs = [];
    for m = 1:length(matrix_ids)
        mat_id = matrix_ids(m);
        corr_matrix = cross_corrs{1,1}{mat_id, dms_index}; 
    
        max_corr = max(corr_matrix, [], 1);
    
        matrix_br_corrs = [matrix_br_corrs; max_corr];
    end
    
    max_strio = maxk(strio_br_corrs, 2, 1);
    mean_strio = mean(max_strio, 1);
    mean_mat = mean(matrix_br_corrs, 1);
else
    strio_br_corrs = [];
    for s = 1:length(strio_ids)
        strio_id = strio_ids(s);
        corr_matrix = cross_corrs{1,1}{strio_id, dms_index}; 
    
        strio_br_corrs = [strio_br_corrs corr_matrix];
    end
    
    matrix_br_corrs = [];
    for m = 1:length(matrix_ids)
        mat_id = matrix_ids(m);
        corr_matrix = cross_corrs{1,1}{mat_id, dms_index}; 
    
        matrix_br_corrs = [matrix_br_corrs corr_matrix];
    end
    
    max_strio = maxk(strio_br_corrs, 2, 2);
    mean_strio = (mean(max_strio, 2));
    mean_mat = (mean(matrix_br_corrs, 2));
end

mean_strio = abs(mean_strio);
mean_mat = abs(mean_mat);

striosomality = (mean_strio - mean_mat) ./ (mean_strio + mean_mat); 

histogram(striosomality, 100)
if use_whole_br
    type = "whole region corrs";
else
    type = "vox 2 vox corrs";
end
title("subject: " + subj(1) + " striosomality using " + type)
  
%{
striatum_voxels = voxel_ref{1,1}{1,dms_index};

for i = 1:length(br_ids)
    br = br_ids(i);
    
            n_thresh = 5;
            for t = 1:length(trip)
                curr_br = trip(t);
    
                corr_matrix = cross_corrs{1,subj}{curr_br, dms_index};
                [br_thresholds] = get_thresh_range(corr_matrix,n_thresh);
                corr_matrices{t} = corr_matrix;
                all_br_thresholds{t} = br_thresholds;
            end
        

        end
    end
end
%}
end