function[]= BusInInitFct()

%Get Amount of Bus-Selector Outputs
Model=gcb();
BSPath=strcat(gcb,'/Bus Selector')
PortHandlesBS=get_param(BSPath,'PortHandles')
NumberofParameters=length(PortHandlesBS.Outport)
blks= find_system(gcb,'LookUnderMasks','all','Type','block');
%Create Outputs

%Check if New Building is required
PortHandBI=get_param(Model,'PortHandles');
OutportNum=length(PortHandBI.Outport)

if OutportNum-1<NumberofParameters
        for i=(OutportNum):NumberofParameters
        %Build Outputs
        NewOutPath=strcat(Model,'/Out',num2str(i))
        add_block('simulink/Commonly Used Blocks/Out1', NewOutPath)
        set_param(NewOutPath,'Position',[465 33+40*i 495 47+40*i])
        end
          
   
elseif OutportNum-1>NumberofParameters
    
    %%TODO With this, it is not possible to delete lines and blocks in the
    %%middle --> New skcript that detects the not connected?
    try
        %i=NumberofParameters+5
        i=5
        
        %Counter of deleted blocks
        j=0
        while i<=length(blks)
                    %LineHand=get_param(blks(i),'LineHandles')
                    %try
                    %delete_line(LineHand{1,1}.Inport(1))
                    %end
            Connected=get_param(blks(i),'PortConnectivity')
            
            %Delete line and block if unconected lines
            if Connected{1,1}.SrcBlock ==-1
                LineHand=get_param(blks(i),'LineHandles')   
                try
                    delete_line(LineHand{1,1}.Inport(1))
                end
            
                delete_block(blks(i))
                j=j+1
            
            %New Positioning of remaining blocks    
            elseif Connected{1,1}.SrcBlock ~=-1
               
               set_param(char(blks(i)),'Position',[465 33+40*(i-4-j) 495 47+40*(i-4-j)])    
               
            end
            i=1+i    
        end
    end
    
    
end

%Refresh all Lines
    %Delete all Input-Lines
    LineHand=get_param(BSPath,'LineHandles')
    for i=1:NumberofParameters
        try
        delete_line(LineHand.Outport(i))
        end
    end
    
    %For Lines
    blks= find_system(gcb,'LookUnderMasks','all','Type','block');

    %Draw New Lines
    for i=1:NumberofParameters
        % From
        %oport= cellstr(strcat('Bus Selector/',num2str(i)));
        FromPortHandles=get_param(blks(3),'PortHandles')
        
        % To 
        ToPortHandles = get_param(blks(i+4),'PortHandles')
        %iport= cellstr(strcat(get_param(blks(i+4),'Name'),'/1')); 

        %NewLine = add_line(Model,oport,iport,'autorouting','on');
        NewLine = add_line(Model,FromPortHandles{1,1}.Outport(i),ToPortHandles{1,1}.Inport(1),'autorouting','on');
        %set_param(NewLine, 'Name', LineName);
    
    end

%Rename all Outputs

%Rename all Outputs to Out_1... that there is no double name if just order
%is changed
for i=5:(NumberofParameters+4)
    Outnumber=i-5;
    set_param(char(blks(i)),'Name',strcat('TempOut_',num2str(Outnumber))) 
end

%New Block List
blks= find_system(gcb,'LookUnderMasks','all','Type','block');

%Final Rename
for i=5:(NumberofParameters+4)
    %GetNames
    PortHandlesOut = get_param(blks(i), 'PortHandles')
    Line=get_param(PortHandlesOut{1,1}.Inport,'Line')
    NewOutName=get_param(Line,'Name')
    NewOutName=strrep(NewOutName,'<','')
    NewOutName=strrep(NewOutName,'>','')
    %SetName
    set_param(char(blks(i)),'Name',NewOutName)
    
end
end
