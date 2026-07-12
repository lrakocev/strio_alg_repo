function subj_trial_table = define_trial_units_via_events(subj_trial_table)

trial_sections = subj_trial_table.trial_section;

trial_counter = 1;
new_trial_list = [1];
for j = 2:length(trial_sections)    
    curr_section = trial_sections(j);
    prev_section = trial_sections(j-1);

    if curr_section == "choice" && prev_section == "fix"
        trial_counter = trial_counter + 1;
    end
    
    new_trial_list = [new_trial_list; trial_counter];

end

subj_trial_table.trial_number = new_trial_list;

end