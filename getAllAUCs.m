function scoreAUC = getAllAUCs
mapsDir = './maps/';
gtDir = './groundtruth/';

mapNames = getFileNames(mapsDir,'png');
gtNames = getFileNames(gtDir,'png');

C = nchoosek(1:17,2);
curr_pos1 = 0;
curr_pos2 = 0;
create = true;
for gt_iter=1:numel(gtNames)
    
    fprintf('Evaluating image: %d\n',gt_iter);
    
    tic;
    gtMat = imread(fullfile(gtDir,gtNames{gt_iter}));
       
    for iter =1:size(C,1)
        idx = (gt_iter-1)*17 + C(iter,1);
        map1Mat = imread(fullfile(mapsDir,mapNames{idx}));        
        
        idx = (gt_iter-1)*17 + C(iter,2);
        map2Mat = imread(fullfile(mapsDir,mapNames{idx}));
        
        scoreAUC(iter,1)= AUC_Borji(double(map1Mat),double(gtMat));        
        scoreAUC(iter,2)= AUC_Borji(double(map2Mat),double(gtMat));        
        
        if scoreAUC(iter,1) > scoreAUC(iter,2)
            label = 1;
        else
            label = 0;
        end
        
        map1Mat = imresize(map1Mat,[256,256]);
        map2Mat = imresize(map2Mat,[256,256]);
        
         curr_pos1 = store2hdf5('data1.h5',map1Mat,label,create,1000,curr_pos1); 
         curr_pos2 = store2hdf5('data2.h5',map2Mat,label,create,1000,curr_pos2); 
         create = false;
    end 
    fprintf('Elapsed Time: %f\n',toc);
    disp('-------------------------------------------------------')
    
end


end
