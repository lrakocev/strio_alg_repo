function subj_scanner_behavior_table = fit_psychometric_to_scanner_behavior(subj_scanner_behavior_table, dirName, want_plot)

subid = string(subj_scanner_behavior_table.participant(1));

rew_lvls = unique(subj_scanner_behavior_table.rew_lvls);
cost_lvls = unique(subj_scanner_behavior_table.cost_lvls);
cost_lvls = cost_lvls(~isnan(cost_lvls));

% get appr rates per each rew / cost lvl
rew_appr_rates = get_appr_rates_helper(rew_lvls, "rew_lvls", subj_scanner_behavior_table);
cost_appr_rates = get_appr_rates_helper(cost_lvls, "cost_lvls", subj_scanner_behavior_table);

% fit psychmetric functions
rew_count = 1;
[rew_psych, gof_rew] = fit(rew_lvls,rew_appr_rates,'(a/(1+b*exp(-c*(x))))');
while rew_count < 20 && gof_rew.rsquare < 0.6
    [rew_psych, gof_rew] = fit(rew_lvls,rew_appr_rates,'(a/(1+b*exp(-c*(x))))');
    rew_count = rew_count + 1;
end

cost_count = 1;
[cost_psych, gof_cost] = fit(cost_lvls,cost_appr_rates,'(a/(1+b*exp(-c*(x))))');
while cost_count < 20 && gof_cost.rsquare  < 0.6
    [cost_psych, gof_cost] = fit(cost_lvls,cost_appr_rates,'(a/(1+b*exp(-c*(x))))');
    cost_count = cost_count + 1;

end

table_height = height(subj_scanner_behavior_table);
% getting goodness of fit for each
subj_scanner_behavior_table.rew_r2 =  repelem( gof_rew.rsquare, table_height, 1);
subj_scanner_behavior_table.cost_r2 = repelem( gof_cost.rsquare, table_height, 1);

% the actual parameters of sigmoid (for clustering, checking shift, etc)
subj_scanner_behavior_table.rew_a = repelem( rew_psych.a, table_height, 1);  
subj_scanner_behavior_table.rew_b = repelem( rew_psych.b, table_height, 1); 
subj_scanner_behavior_table.rew_c = repelem( rew_psych.c, table_height, 1);

subj_scanner_behavior_table.cost_a = repelem( cost_psych.a, table_height, 1);  
subj_scanner_behavior_table.cost_b = repelem( cost_psych.b, table_height, 1); 
subj_scanner_behavior_table.cost_c = repelem( cost_psych.c, table_height, 1);


% to calc complexity
rew_val_from_psych = subj_scanner_behavior_table.rew_lvls;
cost_val_from_psych = subj_scanner_behavior_table.cost_lvls;

subj_scanner_behavior_table.complexity = rew_psych(rew_val_from_psych) - cost_psych(cost_val_from_psych);

if want_plot
    plot_psych_helper(cost_psych, cost_lvls,cost_appr_rates, dirName, subid, "cost")
    plot_psych_helper(rew_psych, rew_lvls, rew_appr_rates, dirName, subid, "rew")
end


end

function appr_rates = get_appr_rates_helper(lvls, lvl_type, subj_table)

appr_rates = [];
for i = 1:length(lvls)
    curr_lvl = lvls(i);

    lvl_table = subj_table(subj_table.(lvl_type) == curr_lvl, :);
    appr_rate = sum(lvl_table.response_ext, 'omitnan') / sum(~isnan(lvl_table.response_ext));
    
    appr_rates = [appr_rates; appr_rate];
 
end

end

function plot_psych_helper(fitobject3, x, y, dirName, subid, rew_or_cost)

figure
plot(fitobject3,x.',y.');
xlabel(rew_or_cost)
ylabel("Choice")
title("3 Param Sigmoid")
fighandle3 = gcf;
set(fighandle3, 'visible', 'on');
saveas(fighandle3,strcat(dirName, "\", subid, "_", rew_or_cost, "_psych.fig"))
close

end