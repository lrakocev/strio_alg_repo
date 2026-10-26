function clusters = similar_strio_activity_ensembles(activity_matrix, num_clusters)

% for some reason the activity doubled up? 
num_n = size(activity_matrix,1) / 2;
activity_matrix = activity_matrix(1:num_n, :);

coactivity = corr(activity_matrix');

D = 1 - abs(coactivity);

Z = linkage(D, 'average');
clusters = cluster(Z, 'maxclust',num_clusters);

unique_clusters = unique(clusters);
disp('Identified Ensembles and their neuron counts:');
for i = 1:length(unique_clusters)
    ensemble_size = sum(clusters == unique_clusters(i));
    fprintf('Ensemble %d: %d neurons\n', unique_clusters(i), ensemble_size);
end

[~, sort_idx] = sort(clusters);
sorted_activity = activity_matrix(sort_idx, :);

figure;
imagesc(sorted_activity);
colormap('default');
colorbar
xlabel('Time Steps');
ylabel('Neurons (Sorted by Ensemble)');
title('Neuronal Activity Clustered by Ensembles using cross corr');
end