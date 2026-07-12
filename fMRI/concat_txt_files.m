function concat_txt_files(file1, file2,output_name)

file1_content = fileread(file1);
file2_content = fileread(file2);
combined_content = [file1_content, '\n', file2_content];
output_filename = output_name + '.txt';
fid = fopen(output_filename, 'w');

% Write the combined content to the new file
fprintf(fid, '%s', combined_content);

% Close the file
fclose(fid);

end