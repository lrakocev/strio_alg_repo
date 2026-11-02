function observed_p_appr = plot_dec_making_map_mt_sinai(subject_table, dirName, var_name)

% is this for one subject or for an avg
subids = string(subject_table.subjectidnumber);
num_subs = length(unique(subids));
if num_subs == 1
    subid = subids(1);
else
    subid = "all";
end

if isa(subject_table.(var_name),'string')
    non_string_version = str2double(subject_table.(var_name));
    subject_table.(var_name) = non_string_version;
end

cost_levels = 1/5:1/5:1;
reward_levels = 1/5:1/5:1;

observed_p_appr = zeros(5);
rs = repelem(reward_levels,1,length(reward_levels))'; 
cs = repmat(cost_levels,1,length(cost_levels))';
ps = zeros(length(cost_levels)*length(reward_levels),1); 

i = 1;
for r=1:length(reward_levels)
    for c=1:length(cost_levels)
        r_c_table =  subject_table(subject_table.cost_lvls == c & subject_table.rew_lvls == r,:);
        if ~isempty(r_c_table)
            ps(i) = mean(r_c_table.(var_name),'omitnan');
            observed_p_appr(6 - c,r) = ps(i);
            i = i+1;
        end
    end
end

min_p = min(ps);
max_p = max(ps);

imagesc(observed_p_appr);
cb = colorbar;
clim([min_p max_p]);

            
xlabel("rew")
ylabel("cost")
if num_subs > 1
    title("dec making map for of " + var_name + " for " + subid + " (" + num_subs + " subjects)")
else
    title("dec making map for of " + var_name + " for " + subid)
end

saveas(gcf,strcat(dirName, "\", var_name, "_", subid, "_map.fig"))
close


end