load("ex_vox_act_db.mat")

strio_activity = output_activity_table.downstream_striosome_nii_vox{1};

num_n = size(strio_activity,1) / 2;
strio_activity = strio_activity(1:num_n, :);

strio_coords = output_activity_table.downstream_striosome_nii_coords{1};
strio_coords = strio_coords(1:num_n, :);

num_strio_clusters = 4;
%strio_table_w_clusters = activity_by_coords(strio_activity, strio_coords, "downstream strio", num_strio_clusters);

%% snc activity

snc_activity = output_activity_table.final_SN_vox{1};
snc_coords = output_activity_table.final_SN_coords{1};

num_sn_clusters = 6;
%snc_table_w_clusters = activity_by_coords(snc_activity, snc_coords, "snc", num_sn_clusters);

%% combine behavior to activities of all vox in snc

trial_labels = full_db{1,1}{1,1};

all_snc_activity = output_activity_table.final_SN_vox{1,1};
no_zero_snc_activity = all_snc_activity(sum(all_snc_activity,2) ~= 0, :);
snc_activity_table.vox_activity = no_zero_snc_activity';

snc_activity_table = struct2table(snc_activity_table);
snc_activity_table.onset_time_step = [1:height(snc_activity_table)]';

snc_activity_at_action = outerjoin(trial_labels, snc_activity_table, "MergeKeys",1, "Keys", {'onset_time_step'});
snc_activity_filled = fillmissing(snc_activity_at_action, 'previous');
snc_activity_filled.subjectidnumber = repelem(subjectid, height(snc_activity_filled), 1);

snc_activity_filled = define_trial_units_via_events(snc_activity_filled);

%% get clean behavior table

[all_clean_behavior, short_tables] =  get_clean_behavior();

short_table_subjects = cellfun(@(x) x.participant(1), short_tables);
short_table_sizes = cellfun(@(x) height(x), short_tables);

%%
all_clean_behavior = renamevars(all_clean_behavior, "trials_3_thisN", "trial_number");

all_clean_behavior.condition = string(all_clean_behavior.condition);
all_clean_behavior.participant = string(all_clean_behavior.participant);

all_clean_behavior = renamevars(all_clean_behavior, ["participant"],["subjectidnumber"]);

all_clean_behavior_sub = all_clean_behavior(:, {'subjectidnumber','trial_number','rew_lvls','cost_lvls'});

snc_activity_w_trial_lvls = outerjoin(all_clean_behavior_sub, snc_activity_filled, "MergeKeys", 1, "Keys",{'subjectidnumber','trial_number'});
snc_activity_w_trial_lvls = snc_activity_w_trial_lvls(~isnan(snc_activity_w_trial_lvls.onset_time_step) & ...
    ~isnan(snc_activity_w_trial_lvls.rew_lvls), :);

snc_activity_w_trial_lvls_ext = snc_activity_w_trial_lvls(snc_activity_w_trial_lvls.int_or_ext == "ext", :);

snc_activity_w_trial_lvls_ext_rew_sorted = sortrows(snc_activity_w_trial_lvls_ext, "rew_lvls");

snc_activity_w_trial_lvls_ext_cost_sorted = sortrows(snc_activity_w_trial_lvls_ext, "cost_lvls");

%%

cue_type = "fix";

snc_activity_w_trial_lvls_ext_rew_sorted = sortrows(snc_activity_w_trial_lvls_ext, "rew_lvls");

snc_activity_w_trial_lvls_ext_cost_sorted = sortrows(snc_activity_w_trial_lvls_ext, "cost_lvls");

snc_activity_w_trial_lvls_ext_rew_sorted = snc_activity_w_trial_lvls_ext_rew_sorted...
    (snc_activity_w_trial_lvls_ext_rew_sorted.trial_section == cue_type, :);
brain_activity_rew_sorted = snc_activity_w_trial_lvls_ext_rew_sorted.vox_activity;

figure
imagesc(brain_activity_rew_sorted');
xlabel("rew lvls sorted")

num_trials = size(brain_activity_rew_sorted,1);
ticks = round(1:num_trials/5:num_trials);
xticks(ticks)
labels = snc_activity_w_trial_lvls_ext_rew_sorted.rew_lvls(ticks);
xticklabels(labels)
ylabel("individual vox of snc")
title("non normalized activity at " + cue_type + " trial period, organized by reward lvls")

brain_activity_rew_sorted_normalized = normalize(brain_activity_rew_sorted,1,"zscore");

figure
imagesc(brain_activity_rew_sorted_normalized');
xlabel("rew lvls sorted")

xticks(ticks)
labels = snc_activity_w_trial_lvls_ext_rew_sorted.rew_lvls(ticks);
xticklabels(labels)
ylabel("individual vox of snc")
title("normalized activity at " + cue_type + " trial period, organized by reward lvls")


snc_activity_w_trial_lvls_ext_cost_sorted = sortrows(snc_activity_w_trial_lvls_ext, "cost_lvls");

snc_activity_w_trial_lvls_ext_cost_sorted = snc_activity_w_trial_lvls_ext_cost_sorted...
    (snc_activity_w_trial_lvls_ext_cost_sorted.trial_section == cue_type, :);
brain_activity_cost_sorted = snc_activity_w_trial_lvls_ext_cost_sorted.vox_activity;


figure
imagesc(brain_activity_cost_sorted');
xlabel("cost lvls sorted")

num_trials = size(brain_activity_rew_sorted,1);
ticks = round(1:num_trials/5:num_trials);
xticks(ticks)
labels = snc_activity_w_trial_lvls_ext_cost_sorted.cost_lvls(ticks);
xticklabels(labels)
ylabel("individual vox of snc")
title("non normalized activity at " + cue_type + " trial period, organized by cost lvls")

brain_activity_cost_sorted_normalized = normalize(brain_activity_cost_sorted,1,"zscore");

figure
imagesc(brain_activity_cost_sorted_normalized');
xlabel("cost lvls sorted")

xticks(ticks)
labels = snc_activity_w_trial_lvls_ext_cost_sorted.cost_lvls(ticks);
xticklabels(labels)
ylabel("individual vox of snc")
title("normalized activity at " + cue_type + " trial period, organized by cost lvls")

%%

strio_activity = output_activity_table.downstream_striosome_nii_vox{1};

whole_strio_table.vox_activity = strio_activity;
whole_strio_table.cluster_idx = [1:size(strio_activity,1)]';

whole_snc_table.vox_activity = no_zero_snc_activity;
whole_snc_table.cluster_idx = [1:size(no_zero_snc_activity,1)]';

whole_snc_table=struct2table(whole_snc_table) ;
whole_strio_table=struct2table(whole_strio_table);

%% get high corr vox 

corr_thresh = 0.15;
[corr_grid] = corr_btwn_strio_snc_clusters(whole_strio_table, whole_snc_table);

[strio_idx, snc_hotspot_idx] = find(abs(corr_grid) > corr_thresh);

snc_hotspot_vox = unique(snc_hotspot_idx);

grouping_hotspots = kmeans(snc_hotspot_vox, 5);

%% summary stats

types = ["rew_lvls";"cost_lvls"];
events = ["choice";"square";"response"]; %"fix"
for s = 1 %1:length(unique(grouping_hotspots))
    curr_group = grouping_hotspots == s;
    hot_spot = [snc_hotspot_vox(curr_group)];
    for j = 1:length(types)
        for k = 1:length(events)
            summary_stats_of_vox_activity_per_lvls(snc_activity_w_trial_lvls_ext, types(j), events(k), hot_spot) % snc_hotspot_vox)
        end
    end
end
