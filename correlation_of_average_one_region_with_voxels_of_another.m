%% correlation of average of one region to all voxels of another

for subj=1:n_subject
    for br1=1:n_region(subj)
        [pcs,~] = eig(cov(processed_activities{subj}{br1}'*processed_activities{subj}{br1}));
        pc1 = pcs(:,1);
        for br2=1:n_region(subj)
            pc_corrs{subj}{br1,br2} = corr(pc1,processed_activities{subj}{br2}');
            av_corrs{subj}{br1,br2} = corr(mean(processed_activities{subj}{br1})',processed_activities{subj}{br2}');
        end
    end
end

% Which regions to plot?
avd_regions = brain_region_names{1};
voxel_regions = "left-caudate";

% PC1 isn't currently returning large enough correlations, should be
% re-examined if used
plot_correlation_of_av_activity_to_all_voxels( ...
    pc_corrs, brain_region_names,subject_names,n_region, ...
    avd_regions, voxel_regions,n_tsteps,"PC1")

plot_correlation_of_av_activity_to_all_voxels( ...
    av_corrs, brain_region_names,subject_names,n_region,...
    avd_regions, voxel_regions,n_tsteps,"average")