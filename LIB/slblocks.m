function blkStruct = slblocks
		% This function specifies that the library should appear
		% in the Library Browser
		% and be cached in the browser repository
        
        % Name of the subsystem which will show up in the Simulink Blocksets
        % and Toolboxes subsystem
        %blkStruct.Name = regexprep( productInfo.Name, '\s+', sprintf('\n') );
        % The function that will be called when the user double-clicks on
        % this icon.
        % Example:  blkStruct.OpenFcn = 'dsplib';
        %
        %blkStruct.OpenFcn = 'LIB_FTM';
        %blkStruct.OpenFcn =  'LIB_Getriebe';
        %blkStruct.OpenFcn = 'LIB_Getriebe';
        %open_system('LIB_Motor');
        %open_system('LIB_Getriebe');
        

        % Specifying the entry for 'LIB_FTM' in the LB repository
        Browser(1).Library  = 'FTM_LIB';
        Browser(1).Name     = 'FTM_Vehicle_Components';
        %Browser(1).Type     = 'Palette';
        %Browser(1).IsFlat   = 0;
        %Browser(1).Children = {'LIB_Getriebe', 'Motor'};
        Browser(1).Choice=0 ; 

        blkStruct.Browser = Browser;

       