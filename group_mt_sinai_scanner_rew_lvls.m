function subject_table = group_mt_sinai_scanner_rew_lvls(subject_table)

num_lvls = 5;

subject_table = convert_cell_rows(subject_table, "money");
subject_table = convert_cell_rows(subject_table, "line_pos");

raw_money = subject_table.money;
raw_effort = subject_table.line_pos;

raw_money(raw_money == 'None') = NaN;
raw_effort(raw_effort == 'None') = NaN;

money_groups = discretize(raw_money, num_lvls);
subject_table.rew_lvls = money_groups;

effort_groups = discretize(raw_effort , num_lvls);
subject_table.cost_lvls = effort_groups;

% general formatting cleaning bc some tables' formatting differ! 
subject_table = convert_cell_rows(subject_table, "key_resp_2_rt");
subject_table = convert_cell_rows(subject_table, "response_ext");
subject_table = convert_cell_rows(subject_table, "response_ext1");
subject_table.percent = num2cell(subject_table.percent);

end

function subject_table = convert_cell_rows(subject_table, col_name)

col_data = subject_table.(col_name);
if isa(col_data ,'cell')
    col_data = str2double(col_data);
    subject_table.(col_name) = col_data;
end

end
