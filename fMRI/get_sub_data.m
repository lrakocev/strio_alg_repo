function activities = get_sub_data(conn, tablename, subid, roi, taskType, eventID, analysisType, voxelType)

dbRows = sqlread(conn,tablename);
dbRows = convertvars(dbRows, 1:22, "string");

trialRows = dbRows(dbRows.subjectid == subid & dbRows.roi == roi &...
    dbRows.eventid == eventID & dbRows.tasktype == taskType ...
    & dbRows.voxeltype == voxelType & dbRows.analysistype == analysisType, :);

file = trialRows.datafile;

fileID = fopen(file);
read = fscanf(fileID,'%f');
isroundnum = round(read) == read;

n_tsteps_ = find(diff(isroundnum(1:end-2) & isroundnum(2:end-1) & ...
isroundnum(3:end)),2)-3;
n_tsteps = n_tsteps_(2);

n_voxels = length(read)/(n_tsteps+3);

voxel_ref = zeros(n_voxels,3);
activities = zeros(n_voxels,n_tsteps);
for vx=1:n_voxels
    voxel_ref(vx,:) = read((vx-1)*(n_tsteps+3)+1 : (vx-1)*(n_tsteps+3)+3);
    activities(vx,:)=read((vx-1)*(n_tsteps+3)+4 : vx*(n_tsteps+3));
end

fclose(fileID);

if eventID ~= "all"
    eventString = trialRows.eventindex;
    [eventStart, eventEnd] = strread(eventString, '%u,%u');
    
    activities = activities(:, eventStart:eventEnd);
end

if voxelType ~= "all"
    voxelString = trialRows.voxelindex;
    [voxelStart, voxelEnd] = strread(voxelString,"%u,%u");
   
    activities = activities(voxelStart:voxelEnd, :);

end