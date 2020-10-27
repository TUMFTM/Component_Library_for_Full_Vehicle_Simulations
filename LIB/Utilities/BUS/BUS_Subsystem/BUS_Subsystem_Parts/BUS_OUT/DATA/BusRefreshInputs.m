function[]=BusRefreshInputs()

%Access Parameters
p=Simulink.Mask.get(gcb)
paramNoI = p.getParameter('NumberofInputs')
NumberofInputs=str2num(paramNoI.Value)

%Access Parameterw
paramN = p.getParameter('NameSys')
NewName=(paramN.Value)
NewName=strrep(NewName,'''','')

%Name of Subsystem
Model= gcb()
BCPath = strcat(Model, '/Bus Creator')
PortHandlesBC= get_param(BCPath, 'PortHandles')
set(PortHandlesBC.Outport(1),'SignalNameFromLabel', NewName)


%Check if New Building is required
PortHandBO=get_param(gcb,'PortHandles');
InportNum=length(PortHandBO.Inport)
if InportNum-1==NumberofInputs
    %Nothing happens
else
     
    %Delete all Input-Lines
    LineHand=get_param(BCPath,'LineHandles')
    try
    delete_line(LineHand.Inport)
    catch
        disp('no lines to delete')
    end
    %Set the Inputs of the Bus Creator
    set_param(BCPath,'Inputs',num2str(NumberofInputs))
    
    %Checking if Input-Blocks have to be created or deleted
    if NumberofInputs>(InportNum-1)
        
        
    %Adding of required Inputs
    for i=(InportNum):NumberofInputs
   
        % Adding of a input block
        InPath =strcat(Model, '/In')
        In1Path =strcat(Model, '/In1')
        add_block('simulink/Commonly Used Blocks/In1', In1Path ,'MakeNameUnique', 'on');
        BlocknameNum= int2str(i);
        Blocknamepath= strcat(InPath, BlocknameNum);
        set_param(Blocknamepath,'Position',[165 33+40*i 195 47+40*i])
  
   
    end
    elseif NumberofInputs<(InportNum)-1
        
    %DELETE BLOCKS %InportNum 7 NumberofInports=3
    NumberToDelete=InportNum-NumberofInputs-1
    ToDelete={};
    for i=1:NumberToDelete
        InDeleteNum=num2str(NumberofInputs+i)
        InDeletePath =strcat(Model, '/In',InDeleteNum)
        ToDelete{i}=InDeletePath
    end
    
    for i=1:length(ToDelete)
    delete_block(ToDelete{i})
    end
    end
    for i=1:NumberofInputs
        
        % Adding of a line between Input and Bus Creator
        InPath =strcat(Model, '/In')
        BlocknameNum= int2str(i);
        Blocknamepath= strcat(InPath, BlocknameNum);
        
        % From
        oport= strcat('In',BlocknameNum,'/1');
   
        % To
        iport= strcat('Bus Creator/', BlocknameNum);
   
        LineName=strcat('Line ', BlocknameNum);
        NewLine = add_line(Model,oport,iport);
        set_param(NewLine, 'Name', LineName);
    end

end

%Inport of Names
BusRefreshLineNames()

end