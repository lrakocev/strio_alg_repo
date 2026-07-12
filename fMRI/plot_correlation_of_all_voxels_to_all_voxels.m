function plot_correlation_of_all_voxels_to_all_voxels( ...
    corrs,extremely_corrs,brain_region_names,subj_to_plot,br1_to_plot,...
    br2_to_plot,n_tsteps,n_region)

    r = linspace(-1,1,100);
    
    for s=length(subj_to_plot)
        subj = subj_to_plot(s);
        for br1i=1:length(br1_to_plot)
            br1 = br1_to_plot(br1i);
            for br2i=1:length(br2_to_plot)
                br2 = br2_to_plot(br2i);

                % plot the distribution of corrs between each region
                figure; hold on
                % distributions of correlation coefficients
                h=histogram(corrs{subj}{br1,br2}(:),'BinEdges',r);
                % expected distribution from random noise
                dist = (1-r.^2).^((n_tsteps-1)/2)/beta(1/2,(n_tsteps+1)/2);
                dist_scaled = dist/sum(dist)*sum(h.Values);
                plot(r, dist_scaled, 'r')
                hold off
                title(strcat(brain_region_names{subj}(br1), " <-> ", ...
                    brain_region_names{subj}(br2)))
                xlabel("Pearson's correlation")
                ylabel("voxel->voxel connections")

            end
        end
        
        titles = ["Extremely high correlation","Extremely low correlation"];
        figure
        tiledlayout(2,1);
        for i=1:2
            nexttile
            h(i) = imagesc(extremely_corrs{subj}{i});
            xticks(1:n_region(subj)); yticks(1:n_region(subj));
            xticklabels(brain_region_names{subj})
            yticklabels(brain_region_names{subj})
            set(h(i), 'AlphaData', ~isnan(extremely_corrs{subj}{i}))
            set(gca, 'Xdir','reverse', 'Ydir','normal', ...
                'CLim', [0 max([extremely_corrs{subj}{1}(:); ...
                extremely_corrs{subj}{2}(:)])]); 
            title(titles(i))
        end
        cbh = colorbar;
        cbh.Layout.Tile = 'east'; 
        title(cbh,'voxel->voxel connection proportion');
        
    end
end