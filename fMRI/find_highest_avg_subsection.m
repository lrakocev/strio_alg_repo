function [highest_avg, best_coords, start_x, start_y, start_z, max_avg, max_std, max_med] = find_highest_avg_subsection(matrix_3d, sub_size)

    [R, C, P] = size(matrix_3d);

    max_std = 0;
    max_avg = -inf;
    max_med = -inf;
    highest_avg = [];
    start_x = 0; 
    start_y = 0; 
    start_z = 0;

    volume = sub_size(1)*sub_size(2)*sub_size(3);
    for i = 1:(R - sub_size(1) + 1)
        for j = 1:(C - sub_size(2) + 1)
            for k = 1:(P - sub_size(3) + 1)
                current_section = matrix_3d(i:(i + sub_size(1) - 1), j:(j + sub_size(2) - 1), k:(k + sub_size(3) - 1));

                coords = combinations(i:(i + sub_size(1) - 1),  j:(j + sub_size(2) - 1),  k:(k + sub_size(3) - 1));

                curr_avg = mean(current_section, 'all','omitnan');
                curr_med = median(current_section, 'all','omitnan');


                curr_std = mean(std(current_section,'omitmissing'),'all','omitnan');
                count_nans = sum(isnan(current_section),'all');
                                
                if count_nans / volume >= 0.25
                    continue
                end

                if curr_avg > max_avg
                    max_avg = curr_avg;
                    max_med = curr_med;
                    max_std = curr_std;
                    highest_avg = current_section;
                    best_coords = coords;
                    start_x = i;
                    start_y = j;
                    start_z = k;
                end
            end
        end
    end

end