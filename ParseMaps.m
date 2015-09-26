function ParseMaps

%Set the path for maps and GT directories
mapsDir = './maps/';
gtDir = './groundtruth/';

%List all groundtruths in the directory
gtNames = getFileNames(gtDir,'png');

nImgs = 2;

Posfixes = {'AC','AIM','CA','CB','FT','GB','HC','IM','IT','LC','MSS','RC','SEG','SR','SUN','SWD','SeR'};

%Generate all possible indices for choosing 2 from 17
C = nchoosek(1:17,2);

curr_pos1 = 0;
curr_pos2 = 0;
create = true;

%Load the images one by one

fileID1 = fopen('data1.dat','w');
fileID2 = fopen('data2.dat','w');
fileIDLabel = fopen('label.dat','w');
for gt_iter=1:nImgs
    
    fprintf('Evaluating image: %d\n',gt_iter);
    
    %Load the GroundTruth
    tic;
    gtMat = imread(fullfile(gtDir,gtNames{gt_iter}));
    
    %For all 17 maps, load them and compute their AUC scores
    mapMat = cell(1,17);
    scoreAUC = zeros(1,17);
    
    for map_iter = 1:17
        
        mapName = [gtNames{gt_iter}(1:end-4) '_' Posfixes{map_iter} '.png'];
        namesArchive{map_iter} = mapName;
        
        mapMat{map_iter} = imread(fullfile(mapsDir,mapName));
        scoreAUC(map_iter)= AUC_Borji(double(mapMat{map_iter}),double(gtMat));
        
    end
    
    %For all possible selections, put the images alongside and compute the
    %label of them
    for iter = 1:size(C,1)
        
        idx1 = C(iter,1);        
        idx2 = C(iter,2);
        
        if scoreAUC(idx1) > scoreAUC(idx2)
            label = 1;
        else
            label = 0;
        end

        fprintf(fileID1,'%s\n',namesArchive{idx1});
        fprintf(fileID2,'%s\n',namesArchive{idx2});
        fprintf(fileIDLabel,'%d\n',label);
        %Store the maps into hdf5 datasets
%         curr_pos1 = store2hdf5('data1.h5',map1Mat,label,create,1000,curr_pos1);
%         curr_pos2 = store2hdf5('data2.h5',map2Mat,label,create,1000,curr_pos2);
%         create = false;
    end
    
    fprintf('Elapsed Time: %f\n',toc);
    disp('-------------------------------------------------------')
    
end
end
