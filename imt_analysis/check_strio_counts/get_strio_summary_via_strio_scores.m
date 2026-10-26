function row = get_strio_summary_via_strio_scores(subj_id, striosomality_home_dir, dms_name)

subj_dir = striosomality_home_dir + "/" + subj_id;
fuzzy_logic_dir = subj_dir + "/testresults/testresults";

load(fuzzy_logic_dir + "/" + dms_name + "_striosomalities_fis.mat")

strio_counts = sum(striosomalities > 0, 2);
strio_regions = ["a24_a32_lh"; "final_SN"; "Hb_mni" ; "a24_a32_rh"; "Thalamus-MD_rh152"];

row.subj_id = subj_id;
for j = 1:length(strio_regions)
    region = strio_regions(j);
    region = strrep(region,"-","_");
    row.(region) = strio_counts(j);
end

row.sttm = length(striosomalities);

end