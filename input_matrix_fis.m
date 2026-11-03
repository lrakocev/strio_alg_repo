function output = input_matrix_fis(contra1_mat, ipsi1_mat, contra2_mat, ipsi2_mat, thal1_mat)
    % Load the FIS object (assuming it's in the workspace or a .fis file)
    % If it's a .fis file, use readFIS: myFIS = readFIS('myFIS.fis');
    % If it's in the workspace, you need to ensure it is passed in.
    % A robust way is to read from a file.
    myFIS = readfis('input_matrix_roi_fis.fis'); 

    % Evaluate the FIS
    output = evalfis(myFIS, [contra1_mat, ipsi1_mat, contra2_mat, ipsi2_mat, thal1_mat]);
end