function [curr_pos] = store2hdf5(filename, data,label,create,chunksz,curr_pos)

%Covert data to 4-D vector --> [width height 1 N]
data = reshape(data,[256 256 1 1]);

startloc=struct('Data',[1,1,1,curr_pos+1],'LB',[1,curr_pos+1]);

if create
    %startloc=struct('Data',[1,1,1,1],'LB',[1,1]);
    h5create(filename, '/data', [256 256 1 Inf], 'Datatype', 'double', 'ChunkSize', [256 256 1 chunksz]);
    h5create(filename, '/label', [1 Inf], 'Datatype', 'double', 'ChunkSize', [1 chunksz]); % width, height, channels, number
    
end
h5write(filename, '/data', data, startloc.Data,[256 256 1 1]);
h5write(filename, '/label', label, startloc.LB, size(label));
curr_pos = curr_pos + size(data,4);

end
