function [striosomality_from_all_rois] = apply_fuzzy_logic(cross_corrs, voxel_ref, dms_name, brain_region_names, all_regions, regions_to_hotspot, rankings, h, thresh)

dms_index = find(brain_region_names{1,1}==dms_name);

%{
upstream_regions = rankings(rankings.upstream == 1, :).ROI_keyword;
downstream_regions = rankings(rankings.upstream == 0, :).ROI_keyword;
all_regions = [upstream_regions; downstream_regions];
%}

striosomality_from_all_rois = [];
for r = 1:length(all_regions)

   % try
    region = all_regions(r);
    roi_index = find(brain_region_names{1,1}==region);
    
    corr_matrix = cross_corrs{1,1}{roi_index, dms_index};
    output_thresh = median(corr_matrix, 'all','omitnan') + thresh*std(corr_matrix,[],'all','omitnan');

    if ismember(region, regions_to_hotspot)
       [output_voxels, output_avg, output_std, output_med] = isolate_lh(cross_corrs, voxel_ref, region, dms_name, brain_region_names);
       corr_matrix = corr_matrix(output_voxels, :);
       output_thresh = output_med + thresh*output_std;
    end

   
    striosomality = [];
    for j = 1:size(corr_matrix, 2)
    
        roi_distr_to_striatal_vox = corr_matrix(:, j);


        top_n_for_cnctivity = h ; %10; %round(size(corr_matrix,1)*0.01);
        
        corr_strength = mean(maxk(roi_distr_to_striatal_vox, top_n_for_cnctivity), 'omitnan');

        if region == "Hb_mni"
            num_hi_cnx = sum(abs(roi_distr_to_striatal_vox) > output_thresh, 'omitnan');
        else
            num_hi_cnx = sum(roi_distr_to_striatal_vox > output_thresh, 'omitnan');
        end

        conn_strength = connectivity_strength_fis(corr_strength,num_hi_cnx);
    
        striosomality = [striosomality conn_strength];
    end


    striosomality_from_all_rois = [striosomality_from_all_rois; striosomality];
   %{
    catch
        nanlist = repelem(NaN, 1,size(corr_matrix,2));
        striosomality_from_all_rois = [striosomality_from_all_rois; nanlist];
        warning(region + " failed")
        continue
    end 
   %}
   
end