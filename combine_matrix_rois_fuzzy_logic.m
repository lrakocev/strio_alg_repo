function combined_matrix_list = combine_matrix_rois_fuzzy_logic(matrisomalities_from_rois, roi_list, dms_name, rankings)

if contains(dms_name, "left")
    side = "lh";
else
    side = "rh";
end

roi_types_in_order = [];
for j = 1:length(roi_list)
    roi_name = roi_list(j);
    type = string(rankings(rankings.ROI_keyword == roi_name, :).region_type); 

    if type == "cortical" & contains(roi_name, side)
        type = "ipsi";
    elseif type == "cortical" & ~contains(roi_name, side)
        type = "contra";
    else
        type = "thal";
    end

    roi_types_in_order = [roi_types_in_order; type];
end

contra_idx = find(roi_types_in_order == "contra");
ipsi_idx = find(roi_types_in_order == "ipsi");
thal_idx = find(roi_types_in_order == "thal");


combined_matrix_list = [];
for i = 1:length(matrisomalities_from_rois)         

    matrix_col = matrisomalities_from_rois(:, i);

    contra1_mat = matrix_col(contra_idx(1));
    ipsi1_mat = matrix_col(ipsi_idx(1));
    contra2_mat = matrix_col(contra_idx(2));
    ipsi2_mat = matrix_col(ipsi_idx(2));
    thal1_mat = matrix_col(thal_idx(1));
    thal2_mat = matrix_col(thal_idx(2));
   

    output_matrix = input_matrix_fis(contra1_mat, ipsi1_mat, contra2_mat, ipsi2_mat, thal1_mat);
    
    combined_matrix_list = [combined_matrix_list output_matrix];
end

end