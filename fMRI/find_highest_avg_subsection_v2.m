function [bestScore, bestCoords, bestX, bestY, bestZ, bestW, bestH, bestD, bestStd, bestAvg, bestMed] = find_highest_avg_subsection_v2(matrix_3d, min_size)

[R, C, P] = size(matrix_3d);

minWin = [min_size, min_size, min_size];
maxWin = [R, C, P];

bestScore = -Inf; bestStd = 0;
bestX = 0; bestY = 0; bestZ = 0;
bestW = 0; bestH = 0; bestD = 0;
bestStd= 0;

clean_matrix_3d = fillmissing(matrix_3d, "constant", 0);

squaredData = clean_matrix_3d.^2;
nonNanData = ~isnan(matrix_3d);

for w = minWin(1):maxWin(1)
    for h = minWin(2):maxWin(2)
        for d = minWin(3):maxWin(3)
            
            % Use a moving box filter to sum up the squared values
            % 'valid' means the window stays completely inside the 3D space
            sumSquaresMatrix = convn(squaredData, ones(w, h, d), 'valid');
           % nonNanMatrix = convn(nonNanData, ones(w, h, d), 'valid');

                        
            % Divide by total pixels in the window to get the mean of squares
            numPixels = w * h * d;
            meanSquaresMatrix = sumSquaresMatrix / (numPixels^2);

            
            % Find the highest score for this specific window size
            [maxVal, linearIdx] = max(meanSquaresMatrix(:));
            
            % If this score is the best one yet, save the details
            if maxVal > bestScore
                bestScore = maxVal;
                bestW = w; bestH = h; bestD = d; % Save size
                
                % Convert the 1D index back to 3D grid coordinates (X, Y, Z)
                [X, Y, Z] = ind2sub(size(meanSquaresMatrix), linearIdx);
                bestX = X; bestY = Y; bestZ = Z; % Save start position
            end
            
        end
    end
end

best_section = matrix_3d(bestX:(bestX + bestW - 1), bestY:(bestY + bestH - 1), bestZ:(bestZ + bestD - 1));

bestAvg = mean(best_section,'all', 'omitnan');
bestStd = std(best_section, [],'omitmissing');
bestMed = median(best_section, 'all','omitnan');

bestCoords = combinations(bestX:(bestX + bestW - 1), bestY:(bestY + bestH - 1), bestZ:(bestZ + bestD - 1));



end