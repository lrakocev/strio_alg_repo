function [thresholds] = find_thresholds(all_subjects, brain_region_names, unrelated_brain_region_names, corrs, shuffled_corrs, unrelated_corrs )

br_names = brain_region_names{1,1};
dms_index = find(br_names=='left-caudate');

un_br_names = unrelated_brain_region_names{1,1};
un_dms_index = find(un_br_names=='left-caudate');

n_subj = length(all_subjects);

for subj=1:n_subj

    unrelated_activities = [];
    for k = 1:length(un_br_names)
        if k ~= un_dms_index
            corr_matrix = unrelated_corrs{1,subj}{k, un_dms_index};
            unrelated_activities = [unrelated_activities; corr_matrix];
        end
    end
    avg_unrelated_corr = mean(unrelated_activities, 'all', 'omitnan');
    std_unrelated_corr = std(unrelated_activities, 0, 'all', 'omitnan');

    thresholds = [];
    for j = 1:length(br_names)
        
        corr_matrix = corrs{1,subj}{j, dms_index};
        shuffled_corr_matrix = shuffled_corrs{1,subj}{j, dms_index};
       
        avg_shuffled_corr = mean(shuffled_corr_matrix, 'all','omitnan');
        std_shuffled_corr = std(shuffled_corr_matrix, 0, 'all','omitnan');

        avg_real_corr = mean(corr_matrix, 'all', 'omitnan');
        std_real_corr = std(corr_matrix, 0, 'all','omitnan');
        
        thresh = max(avg_unrelated_corr, avg_real_corr) + 2.5*max(std_unrelated_corr,std_real_corr);
        thresholds = [thresholds; thresh];       
    end
    

end


end