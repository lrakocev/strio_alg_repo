function chosen_vox_activity = get_subset_activity(activities, brain_region_names, chosen_vox, initial_br)

br_index = find(brain_region_names{1,1} == initial_br);
whole_br_activity = activities{1,1}{1,br_index};

find_idx_of_chosen_vox = find(chosen_vox == 1);
chosen_vox_activity = whole_br_activity(find_idx_of_chosen_vox, :);

end