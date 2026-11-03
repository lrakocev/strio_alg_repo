function plot_correlation_of_mean_activities(av_activity_corrs, ...
    brain_region_names,subject_names)

    for subj = 1:length(subject_names)
        figure
        h=imagesc(av_activity_corrs{subj});
        xticks(1:height(av_activity_corrs{subj}));
        yticks(1:width(av_activity_corrs{subj}));
        xticklabels(brain_region_names{subj})
        yticklabels(brain_region_names{subj})
        set(h, 'AlphaData', ~isnan(av_activity_corrs{subj}))
        set(gca, 'Xdir','reverse', 'Ydir','normal'); 
        cbh = colorbar;
        title(cbh, "Pearson's corr.")
        title("Subject " + num2str(subject_names(subj)) + ...
            ": mean activity->mean activity correlation");
        colormap(whitejet())
    end
end