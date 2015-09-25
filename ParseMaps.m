function ParseMaps

%Set the path for maps and GT directories
mapsDir = './maps/';
gtDir = './groundtruth/';

%List all maps and groundtruths in the directory
mapNames = getFileNames(mapsDir,'png');
gtNames = getFileNames(gtDir,'png');

%Generate all possible indices for choosing 2 from 17
C = nchoosek(1:17,2);

curr_pos1 = 0;
curr_pos2 = 0;
create = true;

%Load the images one by one
for gt_iter=1:numel(gtNames)
    
    fprintf('Evaluating image: %d\n',gt_iter);
    
    %Load the GroundTruth
    tic;
    gtMat = imread(fullfile(gtDir,gtNames{gt_iter}));
    
    %For all 17 maps, load them and compute their AUC scores
    mapMat = cell(1,17);
    scoreAUC = zeros(1,17);
    
    for map_iter = 1:17
        idx = (gt_iter-1)*17 + map_iter;
        mapMat{map_iter} = imread(fullfile(mapsDir,mapNames{idx}));
        scoreAUC(map_iter)= AUC_Borji(double(mapMat{map_iter}),double(gtMat));
    end
    
    %For all possible selections, put the images alongside and compute the
    %label of them
    for iter = 1:size(C,1)
        
        idx1 = C(iter,1);
        map1Mat = mapMat{idx1};
        
        idx2 = C(iter,2);
        map2Mat = mapMat{idx2};
        
        if scoreAUC(idx1) > scoreAUC(idx2)
            label = 1;
        else
            label = 0;
        end
        
        map1Mat = imresize(map1Mat,[256,256]);
        map2Mat = imresize(map2Mat,[256,256]);
        
        %Store the maps into hdf5 datasets
        curr_pos1 = store2hdf5('data1.h5',map1Mat,label,create,1000,curr_pos1);
        curr_pos2 = store2hdf5('data2.h5',map2Mat,label,create,1000,curr_pos2);
        create = false;
    end
    
    fprintf('Elapsed Time: %f\n',toc);
    disp('-------------------------------------------------------')
    
end
end
