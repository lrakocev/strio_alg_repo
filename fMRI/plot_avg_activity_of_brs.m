function [mean_means, transients, variances, output_activity_table] = plot_avg_activity_of_brs(processed_activities, cross_corrs, voxel_ref, dms_name, brain_region_names,regions_to_plot, regions_to_hotspot, all_subjects, save_to_dirs, smooth_factor, varargin)

br_names = brain_region_names{1,1};
reload = true;

colors = distinguishable_colors(50);
n_subject = length(all_subjects);
counter = 1;
mean_means = [];
transients = [];
variances = [];
for subj = 1:n_subject
    id = all_subjects(subj);
    save_to = save_to_dirs(subj);
    
    n_region = length(br_names);
        
    figure
    for br = 1:n_region
        name = br_names(br);

        if ~contains(regions_to_plot, name)
            continue
        else
        
        activity = processed_activities{subj}{br};

        if contains(regions_to_hotspot, name)
            
            [voxel_rows_w_high_connectivity, ~] = isolate_lh(cross_corrs, voxel_ref, name, dms_name, brain_region_names);
            
            activity = activity(voxel_rows_w_high_connectivity,:);
        end

        std_of_each_vox = std(activity,[],2);
        mean_of_each_vox = mean(activity,2);
        
        if size(activity, 1) > 1

            norm_of_each_vox = (activity - mean_of_each_vox) ./ std_of_each_vox;

            norm_activity  = mean(norm_of_each_vox,'omitnan');
            raw_activity = mean(activity, 'omitnan');
        else 
            raw_activity = activity;
        end
        smoothed_activity = movmean(raw_activity, smooth_factor);

        if name == dms_name
            mean_caudate_activity = mean_of_each_vox;
            std_caudate_activity = std_of_each_vox;
            left_caudate_activity = movmean(norm_activity,smooth_factor); 
        end
        
        nexttile
        plot(1:length(smoothed_activity), smoothed_activity, 'Color', colors(counter,:))
        hold on
        plot(1:length(smoothed_activity), repelem(mean(smoothed_activity,'omitnan'),1,length(smoothed_activity)), 'Color','black')
        hold on
        %errorbar(avg_activity, std_dev_activity)
        title("raw avg: " + name)
        counter = counter + 1;

        name = replace(name, "-", "_");
        name = replace(name, ".", "_");

        output_activity_table.(name) = smoothed_activity';

        mean_means = [mean_means; mean(smoothed_activity,'omitnan')];
        try
            transients = [transients; calc_transients(smoothed_activity)];
        catch
            transients= [transients; 0];
        end
        variances = [variances; var(smoothed_activity)];
        end
    end
end
     
output_activity_table.onset_time_step = [1:length(smoothed_activity)]';


%output_activity_table = struct2table(output_activity_table);
   
if isempty(varargin)
    sgtitle("avg activities for each brain region in subj " + id)
    legend([brain_region_names{1,1}])

    return
else
   derived_types = varargin{1};
   derived_vox = varargin{2};

   num_vox_in_derived_type = cellfun(@sum,derived_vox) ;
   num_vox_in_derived_type(num_vox_in_derived_type == 0) = nan;
   [min_num_vox, min_vox_idx] = min(num_vox_in_derived_type,[], "omitnan");
 
   for i = 1:length(derived_types)
        type = derived_types(i);
        vox_for_type = derived_vox{i};

        chosen_vox_activity = get_subset_activity(processed_activities, brain_region_names, vox_for_type, "left-caudate");
        
        if i ~= min_vox_idx
            rand_idx = randi(size(chosen_vox_activity,1), 1, min_num_vox)';
            random_chosen_activity = chosen_vox_activity(rand_idx, :);
            chosen_vox_activity = random_chosen_activity;
        end
        
        raw_mean_vox_activity = mean(chosen_vox_activity, 'omitnan');
        smoothed_activity = movmean(raw_mean_vox_activity, smooth_factor);

        output_activity_table.(type) = smoothed_activity;

        mean_means = [mean_means; mean(smoothed_activity,'omitnan')];
        try
            transients = [transients; calc_transients(smoothed_activity)];
        catch
             transients = [transients; 0];
        end
        variances = [variances; var(smoothed_activity)];

        norm_of_each_vox = (chosen_vox_activity - mean(mean_caudate_activity)) / mean(std_caudate_activity);
        norm_chosen_activity  = mean(norm_of_each_vox,'omitnan');

        smoothed_norm = movmean(norm_chosen_activity, smooth_factor);

        nexttile
        plot(1:length(smoothed_activity), smoothed_activity, 'Color', colors(counter,:))
        hold on
        plot(1:length(smoothed_activity), repelem(mean(smoothed_activity,'omitnan'),1,length(smoothed_activity)), 'Color', 'black')
        hold on
        title("raw avg: " + type)

        nexttile
        plot(1:length(smoothed_norm), smoothed_norm, 'Color', colors(counter,:))
        hold on
        plot(1:length(smoothed_norm), repelem(mean(smoothed_norm,'omitnan'),1,length(smoothed_norm)), 'Color', 'black')
        hold on
        title("normed avg (using sttm mean,std): " + type)

        nexttile
        chosen_minus_striatum = smoothed_norm - left_caudate_activity;
        
        plot(1:length(chosen_minus_striatum), chosen_minus_striatum, 'Color', colors(counter,:))
        hold on
        plot(1:length(chosen_minus_striatum), repelem(mean(chosen_minus_striatum,'omitnan'),1,length(chosen_minus_striatum)), 'Color', 'black')
        hold on
        title("normed avg " + type + " - avg striatum")
  
        counter = counter + 1;
   end
end

output_activity_table = struct2table(output_activity_table);
   
sgtitle("avg activities for each brain region in subj " + id)

savefig(save_to + "_activities.fig")


all_rois = [regions_to_plot; derived_types];

figure
bar(1:length(all_rois), mean_means)
xticklabels(all_rois)
xlabel("rois")
title("mean of activity of all rois")

savefig(save_to + "_means.fig")


figure
bar(1:length(all_rois), transients)
xticklabels(all_rois)
xlabel("rois")
title("num transients in activity of all rois")

savefig(save_to + "_transients.fig")

figure
bar(1:length(all_rois), variances)
xticklabels(all_rois)
xlabel("rois")
title("var in activity of all rois")

savefig(save_to + "_variances.fig")



end