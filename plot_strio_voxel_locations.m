function [] = plot_strio_voxel_locations(...
    brain_region_names,mean_strio_proj_extreme_corrs,activities,n_subject,...
    voxel_ref)

    global_max = 0;
    for subj=1:n_subject
        global_max = max(global_max,max(mean_strio_proj_extreme_corrs{subj}, ...
            [],'all'));
    end

    cmap = jet;
    
    for subj=1:n_subject
        figure; hold on
        striatum_idx = find(brain_region_names{subj} == "DCaud");
        max_conn = max(mean_strio_proj_extreme_corrs{subj});
        for i=1:height(activities{subj}{striatum_idx})
            striosomeness = (mean_strio_proj_extreme_corrs{subj}(i))/max_conn;
            if striosomeness > .8
                alpha_ = .8;
            else
                alpha_ = 0;
            end
            col = cmap(round((height(cmap)-1)*striosomeness + 1),:);
            plotcube([1,1,1],voxel_ref{subj}{striatum_idx}(i,:),alpha_,col)
        end
        title("Voxel locations")
        c = colorbar;
        colormap(cmap)
        clim([0 global_max])
        title("Locations of putative striosomes")
        title(c,"av. proportion connection from strio-projecting regions")
        xlabel("voxel x-coord")
        ylabel("voxel y-coord")
        zlabel("voxel z-coord")
    end

end