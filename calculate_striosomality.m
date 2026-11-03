function [maybe_strio, definite_strio, maybe_matrix, definite_matrix,...
    contaminated_strio, contaminated_matrix, contaminated_evenly] =...
    calculate_striosomality(striatum_vox, striatum_thresholds, brain_region_names, strio_filename)

[~, strio_projecting_regions, matrix_projecting_regions,~,...
    ~] = load_striosome_projecting_rankings(strio_filename, brain_region_names);

br_names = brain_region_names{1,1};

is_mem_strio = ismember(br_names,  string(strio_projecting_regions));
strio_ids = find(is_mem_strio);

is_mem_matrix = ismember(br_names,  string(matrix_projecting_regions));
matrix_ids = find(is_mem_matrix);

strio_overlap = calc_overlap(strio_ids, striatum_thresholds, br_names, striatum_vox);
matrix_overlap = calc_overlap(matrix_ids, striatum_thresholds, br_names, striatum_vox);

maybe_strio = strio_overlap == 1;
definite_strio = strio_overlap == 1 & matrix_overlap == 0; % strio_overlap >= 2

maybe_matrix = matrix_overlap == 1;
definite_matrix = matrix_overlap == 1 & strio_overlap == 0;

contaminated_strio = (definite_strio + maybe_matrix) == 2;
contaminated_matrix = (definite_matrix + maybe_strio) == 2;
contaminated_evenly = (definite_strio + definite_matrix) == 2;

end

function output_overlap = calc_overlap(ids, striatum_thresholds, br_names, striatum_vox)

output_overlap = zeros(1,length(striatum_vox{1,1}));
for i = 1:length(ids)
    id = ids(i);
    name = br_names(id);
    thresh = striatum_thresholds(name);
    strio_vox = striatum_vox{id,thresh};
    if ~isempty(strio_vox)
        output_overlap = output_overlap + strio_vox;
    end
end

end
