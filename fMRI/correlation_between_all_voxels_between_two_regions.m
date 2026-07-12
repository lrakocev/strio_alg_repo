all_subjects = ["545"];
speedrun = true;

for s = 1:length(all_subjects)

subject_names = [all_subjects(s)];
close all
clear processed_activities brain_region_names n_region voxel_ref n_subject n_tsteps


[processed_activities,brain_region_names,...
    n_region,voxel_ref,n_subject,n_tsteps] = load_data(subject_names,'all');

strio_filename = "striosome_projection_rankings_v1.xlsx";
[~, strio_projecting_regions, matrix_projecting_regions,control_regions,...
    DMS_regions] = load_striosome_projecting_rankings(strio_filename, brain_region_names);

% correlation between all voxels of one region and all voxels of another

reload = true;

if (exist('corrs', 'var') && reload) || ~exist('corrs', 'var')

    for subj = 1:n_subject
        for br2=2:n_region(subj)
            for br1=1:br2-1
               disp("calculating correlations for subject "+num2str(all_subjects(s))+...
                   ", brain region "+num2str(br1)+"<->"+num2str(br2))

               % change from corr( ) to gctest( )
               corrs_iter = corr(processed_activities{subj}{br1}',...
                    processed_activities{subj}{br2}');
               corrs{subj}{br1,br2} = corrs_iter;
               corrs{subj}{br2,br1} = corrs_iter';
            end
        end
    end

end

end
% find putative striosomes based on correlation with strio-proj regions

% find voxel coordinates for the plotted (1,1,1) index in the following section.
for subj=1:n_subject
    min_coords{subj} = [nan nan nan];
    for br=1:length(voxel_ref{subj})
        min_coords{subj} = min(min_coords{subj}, min(voxel_ref{subj}{br}));
    end
end

% how many highly correlated voxels are there?
corr_sig_threshold = .99; % percentile, compared to random chance
voxel_striosomality_threshold = .7;

for subj=1:n_subject
    % calculate the average # of very correlated voxels between regions
    corr_sig_cutoff = corr_dist_percentile(corr_sig_threshold,n_tsteps(subj));
    strio_proj_idx{subj} = ismember(brain_region_names{subj}, strio_projecting_regions);
    labeled_regions{subj} = uint8.empty;
    voxel_striosomality{subj} = nan(min_coords{subj}+1);
    for br1=1:length(brain_region_names{subj})
        extreme_corrs{subj}{br1} = nan(n_region(subj),height(processed_activities{subj}{br1}));
        for br2=1:length(brain_region_names{subj})
            if br1~=br2
                extremely_high_corrs = mean(corrs{subj}{br1,br2} > ...
                    corr_sig_cutoff,2);
                extremely_low_corrs = mean(corrs{subj}{br1,br2} < ...
                    -corr_sig_cutoff,2);
                extreme_corrs{subj}{br1}(br2,:) = extremely_high_corrs + extremely_low_corrs;
            end
        end
        strio_proj_extreme_corrs{subj}{br1} = ...
            mean(extreme_corrs{subj}{br1}(strio_proj_idx{subj},:),"omitnan");
    
        % store the data in voxel grids
        for vox=1:size(voxel_ref{subj}{br1},1)
            % note the coordinate change: index 1 is used for the min. voxel id
            
            new_vox_idx = voxel_ref{subj}{br1}(vox,:)-min_coords{subj}+1;
            
            % voxel_striosomality is on a 0-1 scale of least to most
            % striosomal
            % label either as the brain region name or striosome (99)
            if strio_proj_extreme_corrs{subj}{br1}(vox) > voxel_striosomality_threshold && ...
                    ismember(brain_region_names{subj}(br1),string(DMS_regions))
                labeled_regions{subj}(new_vox_idx(1),new_vox_idx(2),new_vox_idx(3)) = 99;
                voxel_striosomality{subj}(new_vox_idx(1),new_vox_idx(2),new_vox_idx(3)) = ...
                    strio_proj_extreme_corrs{subj}{br1}(vox);
            else
                labeled_regions{subj}(new_vox_idx(1),new_vox_idx(2),new_vox_idx(3)) = br1;
                voxel_striosomality{subj}(new_vox_idx(1),new_vox_idx(2),new_vox_idx(3)) = 0;
            end
        end
    end
end

subj_to_plot = 1;
br1_to_plot = 1;
br2_to_plot = [2,3,4];
plot_voxel_trend_all_voxels_to_all_striatal_voxels( ...
    brain_region_names,extreme_corrs,n_subject,strio_projecting_regions,...
    matrix_projecting_regions,control_regions,DMS_regions,all_subjects(s))

high_corr_cutoff = .1;
for subj=1:n_subject
    upsetplot(extreme_corrs{subj}{1}'>high_corr_cutoff, ...
        brain_region_names{subj},strio_projecting_regions,...
        matrix_projecting_regions,control_regions,all_subjects(s));
end

%%
for subj=1:n_subject
    volumeViewer(voxel_striosomality{subj,1},labeled_regions{subj,1})
end

% To get transparent 3D plot of DMS striosomes:
% 1) unlick "Show Labels" for everything except the last label and the DMS
% labels
% 2) Uncheck "Embed Labels in Volume"
% 3) reduce opacity of DMS labels

% Note on coordinate to atlas mapping:
% (0,0,0) in the indices = (96, 132, -78) in xyz coordinates and then
% each unit in the index is actually 1.5 in xyz

%% volume of strio voxels compared to striatum

labeled_data = labeled_regions{1,1};
strio_voxels = double(labeled_data == 99);
striatum_voxels = double(labeled_data == 13);

%% exporting strio / striatum mask

strio_mask_name = 'strio_mask.nii';
strio_nii = make_nii(strio_voxels);

save_nii(strio_nii,strio_mask_name);

striatum_mask = 'striatum_mask.nii';
striatum_nii = make_nii(striatum_voxels);

save_nii(striatum_nii,striatum_mask);
