function full_subject_table = apply_func_to_all_subject_data(func_name, data_dir, dms_name, varargin)

num_inputs = nargin(func_name);  

all_sub = dir(data_dir);
full_subject_table = [];
for j = 3:length(all_sub)
    subj_id = string(all_sub(j).name);
    try
        if num_inputs == 3
            subj_row = func_name(subj_id, data_dir, dms_name);
        else
            subj_row = func_name(subj_id, data_dir, dms_name, varargin{1});
        end
        full_subject_table = [full_subject_table; subj_row];
    catch
        continue
    end
end

full_subject_table = struct2table(full_subject_table); 



end