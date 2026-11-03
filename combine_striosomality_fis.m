function output = combine_striosomality_fis(upstream_strio, downstream_strio)
    % Load the FIS object (assuming it's in the workspace or a .fis file)
    % If it's a .fis file, use readFIS: myFIS = readFIS('myFIS.fis');
    % If it's in the workspace, you need to ensure it is passed in.
    % A robust way is to read from a file.
    myFIS = readfis('combo_strio_fis.fis'); 

    % Evaluate the FIS
    output = evalfis(myFIS, [upstream_strio, downstream_strio]);
end