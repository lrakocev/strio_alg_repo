
%% correlation of average activities

% get correlations

for subj=1:n_subject
    av_activity_corrs{subj} = nan(n_region(subj),n_region(subj));
    for br2=1:n_region(subj)
        av_activity_2 = mean(processed_activities{subj}{br2});
        for br1=1:br2-1
            av_activity_1 = mean(processed_activities{subj}{br1});
            av_activity_corrs{subj}(br1,br2) = corr(av_activity_1',av_activity_2');
        end
    end
end

plot_correlation_of_mean_activities(av_activity_corrs,...
    brain_region_names,subject_names)




