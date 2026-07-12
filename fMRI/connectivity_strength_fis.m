function output = connectivity_strength_fis(roi_corr, num_hi_voxels)
    % Load the FIS object (assuming it's in the workspace or a .fis file)
    % If it's a .fis file, use readFIS: myFIS = readFIS('myFIS.fis');
    % If it's in the workspace, you need to ensure it is passed in.
    % A robust way is to read from a file.
    myFIS = readfis('connectivity_strength_fis.fis'); 

    % Evaluate the FIS
    output = evalfis(myFIS, [roi_corr num_hi_voxels]);
end