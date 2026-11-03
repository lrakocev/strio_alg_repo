function [rankings, strio_projecting_regions, matrix_projecting_regions, ...
    control_regions,DMS_regions] = load_striosome_projecting_rankings(filename, brain_region_names)

% load the excel sheet
rankings = readtable(filename);

% check whether there are any brain regions in the voxel data not assigned
% rankings in the xlsx doc, and raise an error if there are
ROIs_in_voxel_data = strings(0);
for i = 1:length(brain_region_names)
    new_names = brain_region_names{i}(:);
    ROIs_in_voxel_data(end+1:end+length(new_names)) = new_names;
end

for i = 1:length(unique(ROIs_in_voxel_data))
    if ~ismember(ROIs_in_voxel_data(i),...
            rankings.ROI_keyword)
        warning(strcat(ROIs_in_voxel_data(i) + " is an ROI in the " + ...
            "voxel data but not listed in" + filename + ", " + ...
            "should probably be added to the .xlsx doc"))
    end
end

strio_projecting_regions = rankings.ROI_keyword( ...
    rankings.striosome_projection_ranking > 0);
matrix_projecting_regions = rankings.ROI_keyword( ...
    rankings.striosome_projection_ranking == 0 & ...
    rankings.matrix_projection_ranking > 0);
control_regions = rankings.ROI_keyword( ...
    rankings.striosome_projection_ranking == 0 & ...
    rankings.matrix_projection_ranking == 0);
DMS_regions = rankings.ROI_keyword(...
    rankings.region_type == "DMS");

% exclude the notes in the 5th and 6th columns
rankings = rankings(:,1:5);

end