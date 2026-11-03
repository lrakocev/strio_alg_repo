function [upstream_list,downstream_list,both_list, up_and_lh, up_and_sn] = combine_upstream_downstream_fuzzy_logic(upstream_strio, downstream_strio)

upstream_list = [];
downstream_list = [];
both_list = [];
up_and_lh = [];
up_and_sn = [];
for i = 1:length(upstream_strio)

    upstream_val = upstream_strio(i);
    snc_val = downstream_strio(1,i);
    lh_val = downstream_strio(2,i);

    %{
    output_strio_lh = combine_striosomality_fis(upstream_val, lh_val);
    output_strio_snc = combine_striosomality_fis(upstream_val, snc_val);
    output_strio = max(output_strio_lh, output_strio_snc);
    %}
    
    both_list = [both_list; (upstream_val > 0 && (snc_val > 0 || lh_val > 0))];
    downstream_list = [downstream_list; (snc_val > 0 || lh_val > 0)];
    upstream_list =[ upstream_list; (upstream_val > 0 )];
    
    up_and_lh = [up_and_lh; (upstream_val > 0) && (lh_val > 0)];
    up_and_sn = [up_and_sn; (upstream_val > 0) && (snc_val > 0)];
    
end

end