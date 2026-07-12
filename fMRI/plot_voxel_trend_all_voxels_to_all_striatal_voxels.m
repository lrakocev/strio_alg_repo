function [] = plot_voxel_trend_all_voxels_to_all_striatal_voxels( ...
    brain_region_names,extreme_corrs,n_subject,strio_projecting_regions,...
    matrix_projecting_regions,control_regions,DMS_regions,subject_name)

cmap = jet;
cmap(end:end+100,:) = repmat(cmap(end,:),101,1);

titles = ["strio-projecting","matrix-projecting","non-projecting"];

for subj=1:n_subject
    DMS_names = brain_region_names{subj}(ismember([brain_region_names{subj}],string(DMS_regions)));
    striatum_idxs = find(ismember(brain_region_names{subj}, DMS_names));
    for i=1:length(striatum_idxs)
        striatum_idx = striatum_idxs(i);
        strio_proj_idx = ismember(brain_region_names{subj}, strio_projecting_regions);
        matrix_proj_idx = ismember(brain_region_names{subj}, matrix_projecting_regions);
        control_idx = ismember(brain_region_names{subj}, control_regions);
        idxs = {strio_proj_idx,matrix_proj_idx,control_idx};

        f = figure;
        t = tiledlayout(3,2);
        title(t,strcat("Subj ",num2str(subj), ...
            ": prop. of significantly connected voxels, ",DMS_names(i)))

        for j=1:3
            idx = idxs{j};
            [~,order] = sort(mean(extreme_corrs{subj}{striatum_idx}(idx,:), ...
                'omitnan'));
    
            nexttile
            imagesc(extreme_corrs{subj}{striatum_idx}(idx,order))
            c=colorbar;
            colormap(cmap)
            clim([0 max(extreme_corrs{subj}{striatum_idx},[],'all')])
            title(c,"prop. highly connected to DMS")
            title(titles(j))
            xlabel("DMS neuron #")
            yticks(1:sum(idx))
            yticklabels(brain_region_names{subj}(idx))
    
            nexttile
            plot(movmean(extreme_corrs{subj}{striatum_idx}(idx,order)',100))
            xlabel("neuron #")
            ylabel("av. prop. significantly correlated voxels")
            ylim([0 max(extreme_corrs{subj}{striatum_idx},[],'all')])
        end
       % saveas(f,strcat("subj"+num2str(subject_name)+"_voxeltrend_" + num2str(i)))
end

end