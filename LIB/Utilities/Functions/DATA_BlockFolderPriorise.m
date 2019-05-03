function initialdirectory= DATA_BlockFolderPriorise (Block)
% Designed by: Benedikt Danquah (FTM, Technical University of Munich)
% Created on: 01.05.2018, Version: Matlab2018b
% ------------------------------------------------------------------------
% Description: Removes and Adds current Library Block and calculation Data
%to the Matlab Path. This way all needed function don't shade in the path.
% ------------------------------------------------------------------------
% Input:    - Block: Block which should be reentered
% ------------------------------------------------------------------------
% Output:    - initialdirectory: returns initial directory
% ------------------------------------------------------------------------
initialdirectory=cd;

if strcmp(get_param(Block,'LinkStatus'),'none')==0
    info=libinfo(Block);
    path=which (info(1).Library);

    for i=1:length(path)
        if ~(path(end)=='\'||path(end)=='/')
             path=path(1:end-1);
        else
            break
        end
    end
    path=[path,'DATA'];
    rmpath(genpath(path))
    addpath(genpath(path))
    cd (path)
end

if strcmp(get_param(Block,'LinkStatus'),'none')==1
    info=libinfo(Block);
    Currentblock=info(1).Block;
    Libraryname=extractBefore(Currentblock,'/');
    Libraryname=char(Libraryname);
    path=which(Libraryname);
    for i=1:length(path)
        if ~(path(end)=='\'||path(end)=='/')
            path=path(1:end-1);
        else
            break
        end
    end
    path=[path,'DATA'];
    rmpath(genpath(path))
    addpath(genpath(path))
    cd (path)
end

end