function [] = init_activation_container()

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


%% Setup Routine:

    %Assumption: Every activation block has a corresponding subsystem

Setup = find_system(gcb,'LookUnderMasks','all','regexp','on','BlockType','Constant','Name','Activation');
mask = Simulink.Mask.get(gcb);
    %Find all activation blocks, which are currently within the block
    %diagram and get the mask handle

    
if isempty(Setup)
    %No activation blocks (subsystems), set all parameter containers
    %invisible/inactive
    
    for i_setup = 1:10
   
        group = mask.getDialogControl(['Container' num2str(i_setup-1)]);
        group.Visible = 'off';
            %Set all parameter containers that are not in use to invisible
        
        set_param(gcb,['Status' num2str(i_setup-1)],'Inactive');
        set_param(gcb,['Activation' num2str(i_setup-1)],'0');
            %Set activation variables that are not in use to inactive/0
    end
    
elseif ~isempty(Setup{1,1})
    %Activation blocks (subsystems) are present; set corresponding
    %parameter container to visible

    for i_setup = 1:size(Setup,1)
    
        Setup{i_setup,2} = get_param(Setup{i_setup,1},'Name');
            %Get name of activation block
        Setup{i_setup,3} = sscanf(Setup{i_setup,2},'Activation%d');
            %Extract number of activation block
    
        help_variable = get_param(Setup{i_setup,1},'PortConnectivity');
        Setup{i_setup,4} = get_param(help_variable.DstBlock,'Name');
            %Extract name of enabled subsystem to which the activationX-
            %block is connected to
        
        group = mask.getDialogControl(['Container' num2str(Setup{i_setup,3})]);
        group.Visible = 'on';
            %Get handle to Container-group for corresponding
            %Activation-parameter and set it to visible
        
        parameter = mask.getParameter(['Status' num2str(Setup{i_setup,3})]);
        parameter.Prompt = ['Activity status of "' Setup{i_setup,4} '":'];
            %Change prompt for activity status on mask dialog to names of
            %current subsystems
    end
    
    
    help_variable = [0:9]';
    help_variable = help_variable(~ismember([0:9]',[Setup{:,3}]'));
        %Get indices of inactive subsystems

    for i_setup = 1:length(help_variable)
   
        group = mask.getDialogControl(['Container' num2str(help_variable(i_setup,1))]);
        group.Visible = 'off';
            %Set all parameter containers that are not in use to invisible
        
        set_param(gcb,['Status' num2str(help_variable(i_setup,1))],'Inactive');
        set_param(gcb,['Activation' num2str(help_variable(i_setup,1))],'0');
            %Set activation variables that are not in use to inactive/0
    
    end
end

end

