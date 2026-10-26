function similar_strio_activity_pca_ensembles(activity_matrix, num_clusters)

num_n = size(activity_matrix,1) / 2;
activity_matrix = activity_matrix(1:num_n, :);

standardizedData = zscore(activity_matrix, 0, 2);

[coeff, score, latent, ~, explained] = pca(standardizedData);

cumExplained = cumsum(explained);
numPCs = find(cumExplained >= 90, 1);
reducedData = score(:, 1:numPCs);

idx = kmeans(reducedData, num_clusters);

%{
figure;
scatter3(reducedData(:,1), reducedData(:,2), reducedData(:,3), 15, idx, 'filled');
xlabel('PC 1'); ylabel('PC 2'); zlabel('PC 3');
title('Neuronal Activity Clustered in Principal Component Space');
%}

[~, sort_idx] = sort(idx);
sorted_activity = activity_matrix(sort_idx, :);

figure;
imagesc(sorted_activity);
colormap('default');
colorbar
xlabel('Time Steps');
ylabel('Neurons (Sorted by Ensemble)');
title('Neuronal Activity Clustered by Ensembles using PCs of activity');

end