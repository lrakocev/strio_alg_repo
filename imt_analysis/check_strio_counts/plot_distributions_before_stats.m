function [output_table] = plot_distributions_before_stats(mt_sinai_w_clusters, brain_cluster_table, plot_col)


ghr_levels = mt_sinai_w_clusters.ghr;
ghr_bins = mt_sinai_w_clusters.ghr_bin;

% hormones
figure
nexttile
histogram(ghr_bins)
xlabel("ghr bins")
ylabel("num subjects")

hold on
nexttile
histogram(ghr_levels, 10)
xlabel("ghr levels")
ylabel("num subjects")


unique_subs = unique(brain_cluster_table.K01_SUBID);
all_strio_activity = [];
for j = 1:length(unique_subs)
    sub = unique_subs(j);
    sub_table = brain_cluster_table(brain_cluster_table.K01_SUBID == sub, :);

    activity = sub_table.(plot_col);
    try
        activity = activity{1};
    catch
    end
  
    all_strio_activity = [all_strio_activity; mean(activity,"all",'omitnan')];

end

figure
histogram(all_strio_activity,20)
xlabel(plot_col)
ylabel("num subjects")

output_table.subj_id = unique_subs;
output_table.strio_activity = all_strio_activity;

output_table = struct2table(output_table);


end

function d = parse_to_double(val)
    if ischar(val) || isstring(val)
        d = str2double(val);
    else
        d = double(val);
    end
end