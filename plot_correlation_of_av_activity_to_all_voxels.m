function plot_correlation_of_av_activity_to_all_voxels( ...
    corrs, brain_region_names,subject_names,n_region,...
    avd_regions,voxel_regions,n_tsteps,av_type)

    max_val = max(cellfun(@(x)max(x(:)),cellfun(@(x)[x{:}],corrs,'UniformOutput',false)));
    min_val = min(cellfun(@(x)min(x(:)),cellfun(@(x)[x{:}],corrs,'UniformOutput',false)));
    r = linspace(min_val,max_val,100);
    dist = (1-r.^2).^((n_tsteps-1)/2)/beta(1/2,(n_tsteps+1)/2);
    
    for subj=1:length(subject_names)
        for br2=1:n_region(subj)
            if ismember(brain_region_names{subj}(br2),voxel_regions)
                figure; hold on
                t=tiledlayout(ceil(length(avd_regions)/4),4);
                for br1=1:n_region(subj)
                    if ismember(brain_region_names{subj}(br1),avd_regions)
                        nexttile; hold on
                        % distributions of correlation coefficients
                        h=histogram(corrs{subj}{br2,br1}(:)); %,'BinEdges',r
                        title(strcat(av_type, " ",...
                            brain_region_names{subj}(br1), " <-> ", ...
                            brain_region_names{subj}(br2)," voxels"))
                        % expected distribution from random noise
                        dist_scaled = dist/sum(dist)*sum(h.Values);
                        plot(r, dist_scaled, 'r')
                        hold off
                        xlabel("Pearson's correlation")
                        ylabel("observed count")
                    end
                    title(t,"Subject " + str2double(subject_names(subj)) + ...
                        ", " + av_type)
                end
            end
        end
    end
end