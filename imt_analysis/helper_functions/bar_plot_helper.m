function bar_plot_helper(cell_array, tit_str, y_str, x_str, save_to)

cell_means = cellfun(@(x) mean(x, 'omitnan'), cell_array);
cell_stds = cellfun(@(x) std(x, [], 'omitnan')/sqrt(sum(~isnan(x))), cell_array);
x = 1:length(cell_means);

figure
bar(x, cell_means)
hold on
errorbar(x, cell_means, cell_stds)
title(tit_str)
ylabel(y_str)
xlabel(x_str)
saveas(gcf, save_to + "\" + tit_str + ".fig")
close all


end