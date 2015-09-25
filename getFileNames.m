function fileNames = getFileNames(parentDir, ext)

    fileNames = dir(fullfile(parentDir, ['*', ext]));
        isub = [fileNames(:).isdir]; %# returns logical vector
    fileNames = {fileNames(~isub).name}';

    % make sure the returned file names are the same under different runs
    fileNames = sort(fileNames);

end