function [activities,brain_region_names,...
    n_region,voxel_ref,n_subject,n_tsteps] = load_data(data_dir,subject_names,limited_voxels,rois_to_read)

% subject names must be names of the directories

% load data
% input data should be saved in subdirectories corresponding to each subject
% the number of time steps should always be 286 for it to read right

% data is stored in 2 dataframes: one listing the times, the other the
% voxel x/y/z IDS, in the same i,j dataframe location. i index is for the
% brain regions, j is for the voxel.

n_subject = length(subject_names);

format long g
clear brain_region_names voxel_ref activities

for subj=1:n_subject

    path=fullfile(data_dir);
    d=dir(fullfile(path,'*.txt'));

    dir_table = struct2table(d);
    names = string(dir_table.name);

    which_names = names(all(contains(names, rois_to_read),2));

    n_region(subj) = numel(which_names);
    brain_region_names{subj} = strings(n_region(subj),1);

    for br=1:n_region(subj)

                
        disp("loading subject "+num2str(subj)+" of "+num2str(n_subject)+ ...
            ", brain region "+br+" of "+num2str(n_region(subj)))

        brain_region_names{subj}(br) = extractAfter(erase(which_names(br),...
            ["_voxels.txt","_roi","_mayberg","_MNI","152"]),"_");

        file_path = strcat(data_dir,"/",which_names(br));

        fileID = fopen(file_path,'r'); 
        read = fscanf(fileID,'%g');

        %file_content = fileread(fileID);
        %lf_count = count(file_content, '\n');
        %non_zero_read = read(read ~= 0);
        isroundnum = round(read) == read;
        
        lines = readlines(file_path);
        line_length = length(split(lines(1), " ")) - 3;
        %if br == 1
           %n_tsteps_ = find(diff(isroundnum(1:end-2) & isroundnum(2:end-1) & ...
           %isroundnum(3:end)),2)-3;
            
            n_tsteps(subj) = line_length;
            long_activities{subj} = double.empty(0,n_tsteps(subj));
       % end
        n_voxels = length(lines) - 1; %floor(length(read)/(n_tsteps(subj)+3));
        if isnumeric(limited_voxels) 
            n_voxels = min(n_voxels,limited_voxels);
        end
        voxel_ref{subj}{br} = zeros(n_voxels,3);
        activities{subj}{br} = zeros(n_voxels,n_tsteps(subj));
        for vx=1:n_voxels
            try
            curr_line = str2num(erase(lines(vx, :),"\n"));
            voxel_ref{subj}{br}(vx,:) = curr_line(1:3); %read((vx-1)*(n_tsteps(subj)+3)+1 : (vx-1)*(n_tsteps(subj)+3)+3);
            activities{subj}{br}(vx,:) = curr_line(4:end);%read((vx-1)*(n_tsteps(subj)+3)+4 : vx*(n_tsteps(subj)+3));
            catch
                vx;
            end
        end
        fclose(fileID);
        %long_activities{subj}(end+1:end+n_voxels,:) = activities{subj}{br};
    end
end

% don't include brain regions with missing data
% necessary here because missing ROIs cause headaches in the analysis later
% on

for subj=1:n_subject
    is_filled = false;
    for br=1:n_region(subj)
        is_filled(br) = ~isempty(activities{subj}{br});
    end
    activities{subj} = activities{subj}(is_filled);
    n_region(subj) = sum(is_filled);
    brain_region_names{subj} = brain_region_names{subj}(is_filled);
    voxel_ref{subj} = voxel_ref{subj}(is_filled);
end