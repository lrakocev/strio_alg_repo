%% behavioral in scanner data
want_plot = 0;
var_name = "response_ext";
in_scanner_folder = "C:\Users\lrako\OneDrive\Documents\mt_sinai\in_scanner_data";
items_in_scanner_dir = dir(in_scanner_folder);

psych_dir_name = "C:\Users\lrako\OneDrive\Documents\mt_sinai\psych_dir";
mkdir(psych_dir_name)

map_dir_name = "C:\Users\lrako\OneDrive\Documents\mt_sinai\map_dir";
mkdir(map_dir_name)

% example subject w correct size table
ex_subj_table = readtable("C:\Users\lrako\OneDrive\Documents\" + ...
    "mt_sinai\in_scanner_data\406_effort-test_2020_Oct_29_1403.csv");
ex_table_props = string(ex_subj_table.Properties.VariableNames);


f = 1;
s = 1;
all_clean_behavior = [];
failed_tables = {};
short_tables = {};
for j = 3:length(items_in_scanner_dir)
    subj_line = items_in_scanner_dir(j,:);
    subj_file_name = string(subj_line.folder) + "\" + string(subj_line.name);
    subject_table = readtable(subj_file_name);

    table_props = string(subject_table.Properties.VariableNames);

    if ~isequal(table_props, ex_table_props)
        missing_props = setdiff(ex_table_props, table_props);
        extra_props = setdiff(table_props, ex_table_props);
        subject_table{:, missing_props} = NaN;  
        subject_table = removevars(subject_table, extra_props);
    end

    % redundant field + can cause problems
    subject_table = removevars(subject_table, "condition1");

    exp_subj_table = subject_table(~contains(subject_table.condition, "control"), :);
    
    if height(exp_subj_table) < 50
        short_tables{s} = exp_subj_table;
        s = s+1;
    end
    
    if height(exp_subj_table) > 5
        cleaned_subj_table = group_mt_sinai_scanner_rew_lvls(exp_subj_table);
    else
        failed_tables{f} = exp_subj_table;
        f = f+1;
        continue
    end
   
    try
        % subj_scanner_behavior_table = fit_psychometric_to_scanner_behavior(cleaned_subj_table, psych_dir_name, want_plot);
        % plot_dec_making_map_mt_sinai(cleaned_subj_table, map_dir_name, var_name)

        all_clean_behavior = [all_clean_behavior; cleaned_subj_table];
    catch
        failed_tables{f} = cleaned_subj_table;
        f = f+1;
        continue
    end
end

short_table_subjects = cellfun(@(x) x.participant(1), short_tables);
 
%% brain activity dbs

load('mt_sinai_demo_db.mat')
load('imt_wkspc.mat')

full_db_table = [];
for j = 1:length(full_db)
    sub_db = full_db{j}; 
    try
        sub_db = define_trial_units_via_events(sub_db);
        full_db_table = [full_db_table; sub_db];
    catch
        existing_cols = full_db_table.Properties.VariableNames;
        curr_cols = sub_db.Properties.VariableNames;
        missing_cols = setdiff(existing_cols, curr_cols);
        for k = 1:length(missing_cols)
            missing_col = missing_cols{k};
            sub_db.(missing_col) = repelem("0", height(sub_db), 1);
        end
        full_db_table = [full_db_table; sub_db];
    end
end

full_db_table = renamevars(full_db_table, "subjectidnumber", "K01_SUBID");

%% cleaning brain activity db

brain_activity_db = renamevars(full_db_table, "K01_SUBID", "participant");
brain_activity_db = renamevars(brain_activity_db, "int_or_ext", "condition");

trial_nums = brain_activity_db.trial_number;
brain_activity_db.trial_number = trial_nums - 1;
all_clean_behavior = renamevars(all_clean_behavior, "trials_3_thisN", "trial_number");

all_clean_behavior.condition = string(all_clean_behavior.condition);
all_clean_behavior.participant = string(all_clean_behavior.participant);
brain_activity_db.condition = brain_activity_db.condition + "ernal";

brain_activity_db.upstream_striosome_nii = str2double(brain_activity_db.upstream_striosome_nii);
brain_activity_db.downstream_striosome_nii = str2double(brain_activity_db.downstream_striosome_nii);

%% join behavior to brain activity

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

%% brain maps

behavior_and_brain_no_zeros = ext_only_behavior_and_brain(ext_only_behavior_and_brain.upstream_striosome_nii ~= 0, :);
behavior_and_brain_no_down_zeros = ext_only_behavior_and_brain(ext_only_behavior_and_brain.downstream_striosome_nii ~= 0, :);

rois = ["upstream_striosome_nii", "downstream_striosome_nii", "left_caudate", "final_SN"];
get_brain_maps(ext_only_behavior_and_brain, "old_overall", rois);
get_brain_maps(ext_healthies, "old_healthies", rois)
get_brain_maps(ext_mdds, "old_mdds", rois)

%%
get_brain_maps(behavior_and_brain, "overall", rois);
get_brain_maps(healthies, "healthies", rois)
get_brain_maps(mdds, "mdds", rois)

%% reward/cost lvls

save_to = pwd + "\rew_cost_anova\";
mkdir(save_to)
roi = "upstream_striosome_nii";

[num_subs, subject_lvl_rs_downstream] = comparison_btwn_rew_lvls(ext_only_behavior_and_brain, ...
    [], [], roi, "rew_lvls", save_to, "behavior_and_brain_no_down_zeros");
comparison_btwn_rew_lvls(ext_only_behavior_and_brain, ...
    [], [], roi, "cost_lvls", save_to, "behavior_and_brain_no_down_zeros")

%% quick draw

ext_only_behavior_and_brain.discrete_rew_r2 = discretize(ext_only_behavior_and_brain.rew_r2, 5);
ext_only_behavior_and_brain.discrete_cost_r2 = discretize(ext_only_behavior_and_brain.cost_r2,5);

num_lvls = 5;
cost_disc = [];
rew_disc = [];

rois = ["upstream_striosome_nii", "downstream_striosome_nii","left_caudate"];
for r = 1:3
    roi = rois(r);

    rew_disc = [];
    cost_disc = [];
    for j = 1:num_lvls
        rew_disc_table = ext_only_behavior_and_brain(ext_only_behavior_and_brain.discrete_rew_r2 == j, :);
        cost_disc_table = ext_only_behavior_and_brain(ext_only_behavior_and_brain.discrete_cost_r2 == j, :);
    
        mean_r_d = mean(rew_disc_table.(roi), 'omitnan');
        mean_c_d = mean(cost_disc_table.(roi), 'omitnan');
    
        cost_disc = [cost_disc; mean_c_d];
        rew_disc = [rew_disc; mean_r_d];
    
    end

    figure
    bar(1:num_lvls, rew_disc)
    title(roi + " across rew r2")
    xlabel("r2 in rew psych")
    ylabel(roi + " activity")
    
    figure
    bar(1:num_lvls, cost_disc)
    title(roi + " across cost r2")
    xlabel("r2 in cost psych")
    ylabel(roi + " activity")
end

%% bar plots of complexities

rois = ["upstream_striosome_nii", "downstream_striosome_nii", "left_caudate"];
get_bar_complexities(ext_only_behavior_and_brain, "overall", rois)

get_bar_complexities(healthies, "healthies", rois)
get_bar_complexities(mdds, "mdds", rois)


%% clustering in scanner data

save_to = pwd + "\in_scanner_cluster\";
mkdir(save_to)

[rew_cluster_table, cost_cluster_table] = cluster_in_scanner_psychs(mdds, 8, 6, save_to);

%% healthy vs mdd 

healthies_xyz = log(abs( [healthies.rew_a, healthies.rew_b, healthies.rew_c] ));
mdds_xyz = log(abs( [mdds.rew_a, mdds.rew_b, mdds.rew_c] ));

figure
scatter3(healthies_xyz(:,1), healthies_xyz(:,2), healthies_xyz(:,3), 'filled', 'b')
hold on
scatter3(mdds_xyz(:,1), mdds_xyz(:,2), mdds_xyz(:,3), 'filled', 'r')
hold off
legend(["healthy"; "mdd"])
title("reward psychs")

healthies_xyz = log(abs( [healthies.cost_a, healthies.cost_b, healthies.cost_c] ));
mdds_xyz = log(abs( [mdds.cost_a, mdds.cost_b, mdds.cost_c] ));

figure
scatter3(healthies_xyz(:,1), healthies_xyz(:,2), healthies_xyz(:,3), 'filled', 'b')
hold on
scatter3(mdds_xyz(:,1), mdds_xyz(:,2), mdds_xyz(:,3), 'filled', 'r')
hold off
legend(["healthy"; "mdd"])
title("cost psychs")


%% behavior + brain vs full _ db _ table

figure
histogram((behavior_and_brain.upstream_striosome_nii))
hold on
histogram(str2double(full_db_table.upstream_striosome_nii))

straight_wo_removing =  outerjoin(brain_activity_db, all_clean_behavior,"MergeKeys", 1, ...
    "Keys", {'participant','condition','trial_number'});

figure
histogram((straight_wo_removing.upstream_striosome_nii))
hold on
histogram(str2double(full_db_table.upstream_striosome_nii))

no_nan_money = behavior_and_brain(~isnan(behavior_and_brain.money), :);

figure
histogram((no_nan_money.upstream_striosome_nii))
hold on
histogram(str2double(full_db_table.upstream_striosome_nii))

no_nan_rew_or_cost = behavior_and_brain(~isnan(behavior_and_brain.rew_lvls) | ~isnan(behavior_and_brain.cost_lvls) , :);

length(unique(behavior_and_brain.subjectidnumber))

length(unique(straight_wo_removing.participant))

setdiff(unique(full_table_db.participant), unique(behavior_and_brain.subjectidnumber))