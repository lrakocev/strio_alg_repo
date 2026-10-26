function [healthies, mdds, ext_only_behavior_and_brain] = join_behavior_to_brain_table(full_db_table, all_clean_behavior)

brain_activity_db = renamevars(full_db_table, "K01_SUBID", "participant");
brain_activity_db = renamevars(brain_activity_db, "int_or_ext", "condition");

trial_nums = brain_activity_db.trial_number;
brain_activity_db.trial_number = trial_nums - 1;
all_clean_behavior = renamevars(all_clean_behavior, "trials_3_thisN", "trial_number");

all_clean_behavior.condition = string(all_clean_behavior.condition);
all_clean_behavior.participant = string(all_clean_behavior.participant);
brain_activity_db.condition = brain_activity_db.condition + "ernal";

behavior_and_brain = outerjoin(brain_activity_db, all_clean_behavior,"MergeKeys", 1, ...
    "Keys", {'participant','condition','trial_number'});

behavior_and_brain = renamevars(behavior_and_brain, "participant", "subjectidnumber");

behavior_and_brain = behavior_and_brain(~isnan(behavior_and_brain.money), :);
behavior_and_brain = behavior_and_brain(~isnan(behavior_and_brain.rew_lvls) | ~isnan(behavior_and_brain.cost_lvls) , :);

ext_only_behavior_and_brain = behavior_and_brain(behavior_and_brain.condition == "external", :);

ext_healthies = ext_only_behavior_and_brain(str2double(ext_only_behavior_and_brain.subjectidnumber) >= 500, :);
ext_mdds = ext_only_behavior_and_brain(str2double(ext_only_behavior_and_brain.subjectidnumber) < 500, :);

healthies = behavior_and_brain(str2double(behavior_and_brain.subjectidnumber) >= 500, :);
mdds = behavior_and_brain(str2double(behavior_and_brain.subjectidnumber) < 500, :);


end