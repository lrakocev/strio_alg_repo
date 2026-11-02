all_sub = dir('C:\Users\lrako\OneDrive\Documents\mt_sinai\subject_viz\copy_to_local');

want_plot = 0;
input_mat_dir = "C:/Users/lrako/OneDrive/Documents/mt_sinai/subject_viz_mat_091026/mat_copy_to_local_091026";
mat_strio_overlap = apply_func_to_all_subject_data(@overlap_strio_and_matrix, input_mat_dir, "left-caudate", want_plot);


%% get best examples

mat_subs = ["427"; "543"; "529"; "410"];
for k = 1:length(mat_subs)
    mat_sub = mat_subs(k);
    overlap_row = overlap_strio_and_matrix(mat_sub, "left-caudate",1,input_mat_dir);
end


%% plot best examples

dms_name = "left-caudate";
lh_snc_comparison = [];

chosen_subjects_for_mat_activity = string([537]); %547, 536, 527, 537, 432, 428, 420, 416, 408]);
for j = 1:height(mat_strio_overlap)
    
    row = mat_strio_overlap(j, :);
    subj_id = row.subj_id; 
    if ~ismember(subj_id,chosen_subjects_for_mat_activity)
        continue
    end

    mat = row.actual_matrix{1,1};
    lh = row.lh_list{1,1};
    snc = row.snc_list{1,1};
    upstream = row.upstream_list{1,1};

    lh_strio = find(lh > 0);
    ups_strio = find(upstream > 0);

    all_strio = unique([lh_strio ups_strio]);

    mat_cnctvty_for_strio = mat(all_strio);

    figure
    plot(1:length(mat_cnctvty_for_strio),mat_cnctvty_for_strio)
    hold on

    xlabel('striosomal vox defined by LH or PL+')
    ylabel('matrisomality')
    hold on
    plot(1:length(mat_cnctvty_for_strio), repelem(mean(mat), 1, length(mat_cnctvty_for_strio)))
    hold off
    title("matrisomality across striosomal voxels for subj " + subj_id)

    save_to = "C:\Users\lrako\OneDrive\Documents\mt_sinai\subject_viz_ex\" + subj_id;

    ylim([-0.55 0.2])
    set(gcf,'renderer','Painters')
    saveas(gcf, save_to + "\matrix_activity.fig")
    saveas(gcf, save_to + "\matrix_activity.svg")
    close all

end

