function [] = New_Subsystem_Commented()

% Designed by: Benedikt Taiber (FTM, Technical University of Munich)
% ------------------------------------------------------------------------
% Description: Function checks if any new subsystems can be added within
%              the BlockActivationCommented-block and adds new basic
%              subsystem block-structure if possible
% ------------------------------------------------------------------------
% Input:    - []: No inputs
%
% ------------------------------------------------------------------------
% Output:   - []: No outputs
% ------------------------------------------------------------------------


%% Check which subsystem-spots are still available:

Setup = find_system(gcb,'IncludeCommented','On','SearchDepth','1','LookUnderMasks','all','BlockType','SubSystem');
    %Find all subsystems within the masked activation subsystem
Setup(1) = [];
    %Clear first entry, as it is the activation container itself


if isempty(Setup)
    
    input_port = 1;
    output_port = 1;
    n_subsystems = [0:9]';
        %Indices of all possible subsystems (currently not in use)
    
elseif ~isempty(Setup{1,1})

    for i_setup = 1:size(Setup,1)
    
        Setup{i_setup,2} = get_param(Setup{i_setup,1},'Name');
            %Get name of existing activation subsystems
        Setup{i_setup,3} = str2double( get_param(Setup{i_setup,1},'Description') );
            %Get index of activation subsystem by reading the description
    end

    n_subsystems = [0:9]';
    n_subsystems = n_subsystems(~ismember([0:9]',[Setup{:,3}]'));
        %Indices of activation subsystems that are currently not in use
        
    %Count existing in-/output-ports for new subsystem:
    
    input_port = find_system(gcb,'SearchDepth','1','LookUnderMasks','all','BlockType','Inport');
    input_port = size(input_port,1) + 1;
    
    output_port = find_system(gcb,'SearchDepth','1','LookUnderMasks','all','BlockType','Outport');
    output_port = size(output_port,1) + 1;
    
end


%% Add new blocks to block diagram:

if ~isempty(n_subsystems)
    %Free parameters available
    
    add_block('simulink/Sources/In1',[gcb '/Inputs' num2str(input_port)]);
    set_param([gcb '/Inputs' num2str(input_port)],...
              'position',[70,382+n_subsystems(1,1)*300,110,398+n_subsystems(1,1)*300],...
              'port',num2str(input_port));
        %Add Inport and set name, position and port number

    add_block('simulink/Sinks/Out1',[gcb '/Outputs' num2str(output_port)]);
    set_param([gcb '/Outputs' num2str(output_port)],...
              'position',[495,382+n_subsystems(1,1)*300,535,398+n_subsystems(1,1)*300],...
              'port',num2str(output_port));
        %Add outport and set name, position and port number

    add_block('simulink/Ports & Subsystems/Subsystem',[gcb '/Subsystem' num2str(n_subsystems(1,1))]);
    set_param([gcb '/Subsystem' num2str(n_subsystems(1,1))],...
              'position',[175,320+n_subsystems(1,1)*300,420,460+n_subsystems(1,1)*300],...
              'Description',num2str(n_subsystems(1,1)),...
              'Commented','Off');
        %Add "activation subsystem" and set name, position, index within
        %the description and Commented-status
    
    add_line(gcb,['Inputs' num2str(input_port) '/1'],['Subsystem' num2str(n_subsystems(1,1)) '/1']);
    add_line(gcb,['Subsystem' num2str(n_subsystems(1,1)) '/1'],['Outputs' num2str(output_port) '/1']);
        %Add connecting lines between subsystem and port blocks
        
    set_param(gcb,['Status' num2str(n_subsystems(1,1))],'Active');
        %Set initial status of new subsystem to active 
    
elseif isempty(n_subsystems)
    %No free parameters; new subsystem can not be added
    
end


end

