function [] = init_new_subsystem()

% Designed by: Benedikt Taiber (FTM, Technical University of Munich)
% ------------------------------------------------------------------------
% Description: Function checks if any new subsystems can be added and adds
%              new basic subsystem block-structure if possible
% ------------------------------------------------------------------------
% Input:    - []: No inputs
%
% ------------------------------------------------------------------------
% Output:   - []: No outputs
% ------------------------------------------------------------------------


%% Check which subsystem-spots are still available:

Setup = find_system(gcb,'LookUnderMasks','all','regexp','on','BlockType','Constant','Name','Activation');
    %Find all activation blocks, which are currently within the block
    %diagram

if isempty(Setup)
    
    input_port = 1;
    output_port = 1;
    n_subsystems = [0:9]';
        %Numbers of activation-blocks that are currently not in use
    
elseif ~isempty(Setup{1,1})

    for i_setup = 1:size(Setup,1)
    
        Setup{i_setup,2} = get_param(Setup{i_setup,1},'Name');
            %Get name of activation block
        Setup{i_setup,3} = sscanf(Setup{i_setup,2},'Activation%d');
            %Extract number of activation block
    end

    n_subsystems = [0:9]';
    n_subsystems = n_subsystems(~ismember([0:9]',[Setup{:,3}]'));
        %Numbers of activation-blocks that are currently not in use
        
        
    %Count existing in-/output-ports for new subsystem:
    
    input_port = find_system(gcb,'SearchDepth','1','LookUnderMasks','all','BlockType','Inport');
    input_port = size(input_port,1);
    
    output_port = find_system(gcb,'SearchDepth','1','LookUnderMasks','all','BlockType','Outport');
    output_port = size(output_port,1);
    
    
end


%% Add new blocks to block diagram:

if ~isempty(n_subsystems)
    %Free parameters available
    
    add_block('simulink/Sources/In1',[gcb '/Inputs' num2str(input_port+1)]);
    set_param([gcb '/Inputs' num2str(input_port+1)],...
              'position',[70,382+n_subsystems(1,1)*300,110,398+n_subsystems(1,1)*300],...
              'port',num2str(input_port+1));

    add_block('simulink/Sinks/Out1',[gcb '/Outputs' num2str(output_port+1)]);
    set_param([gcb '/Outputs' num2str(output_port+1)],...
              'position',[495,382+n_subsystems(1,1)*300,535,398+n_subsystems(1,1)*300],...
              'port',num2str(output_port+1));

    add_block('simulink/Ports & Subsystems/Enabled Subsystem',[gcb '/Enabled Subsystem' num2str(n_subsystems(1,1))]);
    set_param([gcb '/Enabled Subsystem' num2str(n_subsystems(1,1))],...
              'position',[175,320+n_subsystems(1,1)*300,420,460+n_subsystems(1,1)*300]);
    
    add_block('simulink/Sources/Constant',[gcb '/Activation' num2str(n_subsystems(1,1))]);
    set_param([gcb '/Activation' num2str(n_subsystems(1,1))],...
              'Orientation','down');
    set_param([gcb '/Activation' num2str(n_subsystems(1,1))],...
              'position',[174,250+n_subsystems(1,1)*300,416,280+n_subsystems(1,1)*300]);
    set_param([gcb '/Activation' num2str(n_subsystems(1,1))],...
              'Value',['Activation' num2str(n_subsystems(1,1))]);
    
    add_line(gcb,['Inputs' num2str(input_port+1) '/1'],['Enabled Subsystem' num2str(n_subsystems(1,1)) '/1']);
    add_line(gcb,['Enabled Subsystem' num2str(n_subsystems(1,1)) '/1'],['Outputs' num2str(output_port+1) '/1']);
    add_line(gcb,['Activation' num2str(n_subsystems(1,1)) '/1'],['Enabled Subsystem' num2str(n_subsystems(1,1)) '/Enable']);
    
    
elseif isempty(n_subsystems)
    %No free parameters; new subsystem can not be added
    
end


end

