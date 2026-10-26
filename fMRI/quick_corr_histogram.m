function result_table = quick_corr_histogram(subj_id, corrs_to_use, voxel_ref, brain_region_names, type, want_plot)

brs = brain_region_names{1,1};
dms_index = find(brs=='left-caudate');

result_table = [];
if type == "hist"
    for i = 1:length(corrs_to_use{1,1})
       try
           curr_br_corr = corrs_to_use{1,1}{i,dms_index};

           output_med = 0;
            br_name = brs(i);
            if br_name == "Hb_mni" || br_name == "a24_a32_lh"
                [output_voxels, output_avg, output_std, output_med] = isolate_lh(corrs_to_use, voxel_ref, br_name, "left-caudate", brain_region_names);
                curr_br_corr = curr_br_corr(output_voxels, :);
                output_thresh = output_med + output_std;

            end

           
           overall_mean = mean(curr_br_corr, 'all','omitnan');
           overall_med = median(curr_br_corr, 'all','omitnan');
           corrs_std = mean(std(curr_br_corr, [], "omitmissing"),'all','omitnan');

           if br_name ~= "Hb_mni" || br_name ~= "a24_a32_lh"
                output_thresh = overall_med + corrs_std;
           end

           top_ten_mean = mean(maxk(curr_br_corr, 10, 1), 1, "omitnan");
           num_hi_cnx = sum(curr_br_corr > output_thresh, 1, "omitnan");

           if want_plot
               figure
               histogram(curr_br_corr)
               title("brain region: " + brs(i) + " for subj: " + subj_id)
           end
           
           row.br_name = brs(i);
           row.subj_id = subj_id;
           row.mean_num_hi_cnx = mean(num_hi_cnx, 'omitnan');
           row.mean_top_ten_corr = mean(top_ten_mean, 'omitnan');

           row.raw = curr_br_corr;
           row.corrs_mean = overall_mean;
           row.corrs_skew = skewness(curr_br_corr);
           row.corrs_std = corrs_std; 
           row.overall_med = overall_med;
           row.top_ten_cnx_per_vox_mean = {top_ten_mean};
           row.num_hi_cnx = {num_hi_cnx};
           row.output_thresh = output_thresh;
           row.output_med = output_med;
           row.output_std = output_std;


           result_table = [result_table; row];

       catch
           continue
       end
    end
else
    for i = 1:length(corrs_to_use{1,1})
    
    
        mean_val = mean(corrs_to_use{1,1}{i,dms_index}, 'all', 'omitnan');
        max_val = max(corrs_to_use{1,1}{i,dms_index},[],'all');
        if ~isempty(max_val)
            threshes = linspace(mean_val, max_val, 100);
            above_thresh = [];
            for t = 1:length(threshes)
                thresh = threshes(t);
            
                num_above_thresh = sum(corrs_to_use{1,1}{i,dms_index} >= thresh, 'all');
                above_thresh = [above_thresh ; num_above_thresh];
            
            end
        
            figure
            plot(threshes, above_thresh)
            title('brain region: ' + brs(i) + " for subj: " + subj_id)
        end
    end
end

end