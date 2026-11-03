function timing_table = ordering_timing_files(timing_dir)

timing_files = dir(timing_dir);

timing_table = [];
for i = 3:length(timing_files)
    currfile = timing_files(i).name;

    % if it's these weird files we don't want
    if contains(currfile, "RT") || ~contains(currfile, ["ext", "int"])
        continue
    end

    folder = timing_files(i).folder;
    timing_data = readtable(folder + "/" + currfile);

    if ~isempty(timing_data)

        timing_data = renamevars(timing_data, "Var1", "onset_in_seconds");
        [ctrl_or_exp, trial_section, int_or_ext] = clean_file_name(currfile);
   
        timing_data.ctrl_or_exp = repelem(ctrl_or_exp, height(timing_data), 1);
        timing_data.trial_section = repelem(trial_section, height(timing_data), 1);
        timing_data.int_or_ext = repelem(int_or_ext, height(timing_data), 1);
        %timing_data.rew_lvl = %%;
        %timing_data.cost_lvl = %%;
    
        timing_table = [timing_table; timing_data];
        
    end
end

timing_table.onset_time_step = floor(timing_table.onset_in_seconds ./2) ;
timing_table = sortrows(timing_table,"onset_in_seconds","ascend");

end

function [ctrl_or_exp, trial_section, int_or_ext] = clean_file_name(file_name)

file_name_list = split(file_name, "_");
ctrl_or_exp = string(file_name_list(2));
trial_section = string(file_name_list(3));
int_or_ext = string(file_name_list(4));

end