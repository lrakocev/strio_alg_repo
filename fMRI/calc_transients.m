function [num_pks] = calc_transients(smoothed_activity)

mean_activity = mean(smoothed_activity, 'omitnan');
std_dev = std(smoothed_activity);

thresh = mean_activity + 1.5*std_dev;

[pks, locs] = findpeaks(smoothed_activity, 'MinPeakHeight', thresh);

[neg_pks, neg_locs] = findpeaks(-1 * smoothed_activity, 'MinPeakHeight', thresh);

num_pks = length(pks) + length(neg_pks);

end