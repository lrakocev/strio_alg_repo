Steps:
1. Copy the voxel data into this directory, with each subdirectory corresponding to a subject. Subdirectories must be named like "401" for subject 401, for instance
2. Run load_data.m to A) read in the data from the subdirectories into MATLAB, and B) run some preprocessing that's used in the other files
3. Run correlation_between_all_voxels_between_two_regions.m

Other files (i.e. whitejet.m and corr_dist_percentile.m) are helper functions.