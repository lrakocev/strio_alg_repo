%% picking the voxels with multiple high connections

names = brain_region_names{1,1};
thresholds = [2.5, 2.7, 3, 3.2];
for i = 1:length(names)
    base_roi_name = names(i);
    for j = 1:length(thresholds)
        std_threshold = thresholds(j);
        [cross_labeled, cross_striosomality, special_vox] = get_strio_vox(all_subjects, cross_corrs, voxel_ref, base_roi_name, brain_region_names, 1, std_threshold);
        
        all_labels{i,j} = cross_labeled;
        all_striosomalities{i,j} = cross_striosomality;
        hi_projecting_vox{i,j} = special_vox{1};
        striatum_vox{i,j} = special_vox{2};
    end
end

%% overlapping multiple regions

% 1 = amyg thresh = 3 
% 3 = lh thresh = 2.5;
% 4 = thal md thresh = 2.7 / 3
% 6 = ofc v2 thresh = 2.7
overlap_striatum = zeros(1,723);
brs_striatum_vox = [];
roi_ids = [1, 3, 4, 6];
thresh_ids = [3, 1, 2, 2];
for k = 1:length(roi_ids)
    i = roi_ids(k);
    j = thresh_ids(k);
    overlap_striatum = overlap_striatum + double(striatum_vox{i,j});
    brs_striatum_vox = [brs_striatum_vox; striatum_vox{i,j}];
end

sum(overlap_striatum == 4)

%% 

br_names = brain_region_names{1,1};
compare_rois = ["Amygdala-LB.Bl", "Hb_mni","Thalamus-MD","pOFC_v2", "Area-3a", "Area-4p"];
is_mem = ismember(br_names, compare_rois);
br_ids = find(is_mem);
all_pairs = nchoosek(br_ids,2);
all_trips = nchoosek(br_ids,2);

% need a better way to manage thresholds but for now 
thresh_ids = [3, 3, 3, 0, 1, 2, 0, 2];

for i = 1:length(all_pairs)
    pair = all_pairs(i,:);
    id1 = pair(1);
    id2 = pair(2);
    thresh1 = thresh_ids(id1);
    thresh2 = thresh_ids(id2);
    pair_overlap{id1, id2} = double(striatum_vox{id1, thresh1}) + double(striatum_vox{id2,thresh2});
    num_overlap{id1,id2} = sum(pair_overlap{id1, id2} == 2);
end

%% now to actually see which voxels those are...

for i = 1:length(all_pairs)
    pair = all_pairs(i,:);
    strio_vox = pair_overlap{pair(1), pair(2)};
    [labeled_regions, voxel_striosomality] = viz_overlapping_strio_vox(all_subjects, brain_region_names, voxel_ref, strio_vox);
    volumeViewer(voxel_striosomality{1,1},labeled_regions{1,1})
end

%% correlation clusters - "hotspots"

corr_matrix = cross_corrs{1,1};
dms_index = find(brain_region_names{1,1}=='left-caudate');
a32_index = find(brain_region_names{1,1}=='Area-p32');

corr_per_dms_vox = [];
br_names = [];

thresh_ids = [4,4,4,4,4,4,4,4];
%thresh_ids = [3, 0, 1, 2, 0, 2];
for i = 1:length(corr_matrix)
    if i ~= dms_index && i~=a32_index
        br_names = [br_names; brain_region_names{1,1}(i)];
        dms_corr_matrix = corr_matrix{dms_index, i};
        thresh_id = thresh_ids(i);
        curr_hi_projecting_vox = hi_projecting_vox{i, thresh_ids};
        hi_projecting_dms_corr_matrix = dms_corr_matrix(:, curr_hi_projecting_vox);
        avg_corrs = mean(hi_projecting_dms_corr_matrix,2,'omitnan');
        corr_per_dms_vox = [corr_per_dms_vox avg_corrs];
    end
end

corr_per_dms_vox_table = array2table(corr_per_dms_vox,'VariableNames',br_names);
corr_per_dms_vox_table.index = [1:height(corr_per_dms_vox_table)]';

strio_vox_per_br = br_names + "_strio_vox";
striatum_vox_per_br = array2table(brs_striatum_vox','VariableNames',strio_vox_per_br);
striatum_vox_per_br.index = [1:height(striatum_vox_per_br)]';

corr_per_strio_vox = outerjoin(corr_per_dms_vox_table, striatum_vox_per_br,'Key','index');

%% viz

br_names = brain_region_names{1,1};
compare_rois = ["Amygdala-LB.Bl", "Hb_mni","Thalamus-MD","pOFC_v2","Area-3a","Area-4p"];
is_mem = ismember(br_names, compare_rois);
br_ids = find(is_mem);
all_pairs = nchoosek(br_ids,2);

for i = 1:length(all_pairs)
    pair = all_pairs(i,:);
    r1 = br_names(pair(1));
    r2 = br_names(pair(2));

    in_strio = corr_per_strio_vox(corr_per_strio_vox.(r1 + "_strio_vox") ...
    & corr_per_strio_vox.(r2 + "_strio_vox"),:); % & corr_per_strio_vox.(r3 + "_strio_vox"),:);
    
    % just in strio
    figure
    scatter(in_strio.(r1), in_strio.(r2))
    xlabel(r1)
    ylabel(r2)
end
