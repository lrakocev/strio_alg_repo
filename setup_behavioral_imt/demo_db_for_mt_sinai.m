%% make demographic db of mt sinai subjects

%% response_dat = readtable()
clinical = readtable("C:\Users\lrako\OneDrive\Documents\mt_sinai\K01_tracking.xlsx", "Sheet", "clinical");
ghr = readtable("C:\Users\lrako\OneDrive\Documents\mt_sinai\K01_tracking.xlsx","Sheet", "ghrelin-updated", "NumHeaderLines",0);
cluster_idxs = readtable("C:\Users\lrako\OneDrive\Documents\human_dm\outside_data\mt_sinai_clusters_2.xlsx");
cluster_idxs = renamevars(cluster_idxs, "id", "K01_SUBID");

idxs = cluster_idxs.K01_SUBID;
idxs = eraseBetween(idxs, 1, 1); 
cluster_idxs.K01_SUBID = string(idxs);

join_mt_sinai = join(clinical, ghr);
join_mt_sinai.K01_SUBID = string(join_mt_sinai.K01_SUBID);
mt_sinai_w_clusters = outerjoin(join_mt_sinai,cluster_idxs,"MergeKeys",1);

