function corrs = get_corrs_btwn_regions(processed_activities,brain_region_names,dms_name,all_subjects,use_cross_corr)

reload = true;

n_subject = length(all_subjects);

if (exist('corrs', 'var') && reload) || ~exist('corrs', 'var')
    for subj = 1:n_subject
        n_region = length(processed_activities{1,subj});
        
        br_indices = 1:n_region;
        br_dms = find(brain_region_names{1,subj}==dms_name);
        
        other_brs = setdiff(br_indices,br_dms);

        for br2=other_brs
           disp("calculating correlations for subject "+num2str(all_subjects(subj))+...
               ", brain region "+num2str(br_dms)+"<->"+num2str(br2))

            activities_br_dms = processed_activities{subj}{br_dms}';
            activities_br2 = processed_activities{subj}{br2}';
            if use_cross_corr
                corrs_iter = corr(processed_activities{subj}{br_dms}',...
                processed_activities{subj}{br2}');
            else 
                corrs_iter = double.empty;
                for i = 1:size(activities_br_dms,2)
                    for j = 1:size(activities_br2,2)
                        try
                            p = 0;
                            stat = 4;
                            %[h,p,stat] = gctest(activities_br_dms(:,i), activities_br2(:,j));
                        catch
                            p = 1;
                        end
                        if p <= 0.05
                            corrs_iter(i,j) = stat;
                        else 
                            corrs_iter(i,j) = 0;
                        end
                    end
                end
            end
           corrs{subj}{br_dms,br2} = corrs_iter;
           corrs{subj}{br2,br_dms} = corrs_iter';
        end
    end
end
end