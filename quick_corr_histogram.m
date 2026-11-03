function quick_corr_histogram(corrs_to_use, brain_region_names, type)

brs = brain_region_names{1,1};
dms_index = find(brs=='left-caudate');

if type == "hist"
    for i = 1:length(corrs_to_use{1,1})
       try
           figure
           histogram(corrs_to_use{1,1}{i,dms_index})
           title("brain region: " + brs(i))
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
            title('brain region: ' + brs(i))
        end
    end
end

end