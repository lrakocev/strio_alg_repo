function output = input_striosomality_fis(contra_strio, ipsi_strio, lit_strio)
    % Load the FIS object (assuming it's in the workspace or a .fis file)
    % If it's a .fis file, use readFIS: myFIS = readFIS('myFIS.fis');
    % If it's in the workspace, you need to ensure it is passed in.
    % A robust way is to read from a file.
    myFIS = readfis('input_roi_fis.fis'); 

    % Evaluate the FIS
    output = evalfis(myFIS, [contra_strio, ipsi_strio, lit_strio]);
end