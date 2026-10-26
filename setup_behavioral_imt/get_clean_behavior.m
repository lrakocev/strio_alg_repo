function [all_clean_behavior, short_tables] =  get_clean_behavior()

want_plot = 0;
var_name = "response_ext";
in_scanner_folder = "C:\Users\lrako\OneDrive\Documents\mt_sinai\not_to_git\in_scanner_data";
items_in_scanner_dir = dir(in_scanner_folder);

psych_dir_name = "C:\Users\lrako\OneDrive\Documents\mt_sinai\not_to_git\psych_dir";
mkdir(psych_dir_name)

map_dir_name = "C:\Users\lrako\OneDrive\Documents\mt_sinai\not_to_git\map_dir";
mkdir(map_dir_name)

% example subject w correct size table
ex_subj_table = readtable("C:\Users\lrako\OneDrive\Documents\" + ...
    "mt_sinai\not_to_git\in_scanner_data\406_effort-test_2020_Oct_29_1403.csv");
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
        subj_scanner_behavior_table = fit_psychometric_to_scanner_behavior(cleaned_subj_table, psych_dir_name, want_plot);
        % plot_dec_making_map_mt_sinai(cleaned_subj_table, map_dir_name, var_name)

        all_clean_behavior = [all_clean_behavior; subj_scanner_behavior_table];
    catch
        failed_tables{f} = cleaned_subj_table;
        f = f+1;
        continue
    end
end
end