function combined_strio_list = combine_rois_fuzzy_logic(striosomalities_from_rois, roi_list, dms_name, rankings)

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
    end


    roi_types_in_order = [roi_types_in_order; type];
end

contra_idx = find(roi_types_in_order == "contra");
ipsi_idx = find(roi_types_in_order == "ipsi");
lit_idx = find(roi_types_in_order == "literature");


combined_strio_list = [];
for i = 1:length(striosomalities_from_rois)         

    strio_col = striosomalities_from_rois(:, i);


    contra_strio = strio_col(contra_idx);
    ipsi_strio = strio_col(ipsi_idx);
    lit_strio = strio_col(lit_idx);

    output_strio = input_striosomality_fis(contra_strio, ipsi_strio, lit_strio(1));
    
    combined_strio_list = [combined_strio_list output_strio];
end

end