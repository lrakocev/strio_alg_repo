function shuffled_activity = shuffle_time_series(all_subjects, activities, brain_region_names)

n_subj = length(all_subjects);
brs = (brain_region_names{1,1});


for subj=1:n_subj
    for br = 1:length(brs)
        br_activity = activities{1,subj}{1, br};
        
        [M,N] = size(br_activity);
        rowIndex = repmat((1:M)',[1 N]);
        [~,randomizedColIndex] = sort(rand(M,N),2);
        newLinearIndex = sub2ind([M,N],rowIndex,randomizedColIndex);

        new_activity = br_activity(newLinearIndex);

        shuffled_activity{subj, br} = new_activity;
        
    end
end

end