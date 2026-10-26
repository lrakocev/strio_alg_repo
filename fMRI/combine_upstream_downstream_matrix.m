function [upstream_list,downstream_list,both_list , actual_matrix] = combine_upstream_downstream_matrix(upstream_strio, downstream_strio, matrisomal)

upstream_list = [];
downstream_list = [];
both_list = [];
actual_matrix = [];

for i = 1:length(upstream_strio)

    upstream_val = upstream_strio(i);
    snc_val = downstream_strio(1,i);
    lh_val = downstream_strio(2,i);
    matrix_val = matrisomal(1,i);
    
    both_list = [both_list; (upstream_val > 0 && (snc_val > 0 || lh_val > 0))];
    downstream_list = [downstream_list; (snc_val > 0 && lh_val > 0)];
    upstream_list = [upstream_list; (upstream_val > 0 )];
    actual_matrix = [actual_matrix; matrix_val > 0];
    
end

end