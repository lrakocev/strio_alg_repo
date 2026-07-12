function corrs = each_striatal_vox_to_br(processed_activities,brain_region_names,all_subjects)

reload = true;

n_subject = length(all_subjects);

if (exist('corrs', 'var') && reload) || ~exist('corrs', 'var')
    for subj = 1:n_subject
        n_region = length(processed_activities{1,subj});
        
        br_indices = 1:n_region;
        br_dms = find(brain_region_names{1,subj}=='left-caudate');
        
        other_brs = setdiff(br_indices,br_dms);

        for br2=other_brs
           disp("calculating correlations for subject "+num2str(all_subjects(subj))+...
               ", brain region "+num2str(br_dms)+"<->"+num2str(br2))

            activities_br_dms = processed_activities{subj}{br_dms}';
            activities_br2 = processed_activities{subj}{br2}';

            corrs_iter = double.empty;

            for v = 1:length(activities_br_dms)
                vox_activity = activities_br_dms(:,v);
                vox_corrs = corr(vox_activity, activities_br2);
                corrs_iter(v) = mean(vox_corrs,'omitnan');
            end
           corrs{subj}{br_dms,br2} = corrs_iter;
           corrs{subj}{br2,br_dms} = corrs_iter';
        end
    end
    
end
end
