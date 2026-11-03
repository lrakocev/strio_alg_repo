function h = check_roi_corr_distr(data)

lambda_est = mean(data);
[h, p, stats] = chi2gof(data, 'CDF', @(x) poisscdf(x, lambda_est), 'EstimatedParameters', 1);

% h = 0 means it's poisson, h ~= 0 means not poisson
end