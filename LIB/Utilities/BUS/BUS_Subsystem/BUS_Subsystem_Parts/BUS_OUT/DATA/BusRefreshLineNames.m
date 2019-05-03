function[]=BusRefreshLineNames()

p=Simulink.Mask.get(gcb)
paramNoI = p.getParameter('NumberofInputs')
NumberofInputs=str2num(paramNoI.Value)
Model=gcb;


PortHandlesBO = get_param(gcb, 'PortHandles')
lines=get_param(PortHandlesBO.Inport,'Line')


for j=1:NumberofInputs
%If Nothing is connected
if lines{j+1}==-1 
    %Nothing
else

NewLineName=get_param(lines{j+1}, 'Name')

%Check if connected line has a name
if isempty(NewLineName)==1
    %Get Name of ahead lying blocks output
    
    Line=get(lines{j+1})

    SourcePath=strcat(Line.Parent,'/',Line.SourcePort)
    SourcePath=strsplit(SourcePath,':')
    
    PathofPorts=find_system(SourcePath{1,1},'SearchDepth',1,'LookUnderMasks','All','FollowLinks','on','BlockType','Outport')
    %Strange bug: if there is a / in the outport name it becomes //
    PathofPorts=strrep(PathofPorts,'//','/')
    
    NumberofPort=str2num(SourcePath{1,2})
    
    %If a block witout a outport is connected, like a constant
    if isempty(PathofPorts)==1
        %NameofBlock as Name
        
        NewLineName=strsplit(Line.SourcePort,':')
        NewLineName=NewLineName{1,1}
        
    else
        %Name is Outportname
    NewLineName=strrep(PathofPorts{NumberofPort},strcat(SourcePath{1,1},'/'),'')
    end
end
    
    InputName=strcat(Model,'/In',num2str(j))
    PortHandlesIN=get_param(InputName,'PortHandles');
    set_param(PortHandlesIN.Outport(1),'Name',NewLineName);
end
%set_param(OldLineName, 'Name', OldLineName);
%set_param(list_of_block_in_subsystem{i}, 'Name', new_name);

end

end