function [] = Init_ActivationContainer_Commented()

% Designed by: Benedikt Taiber (FTM, Technical University of Munich)
% ------------------------------------------------------------------------
% Description: Function initialises BlockActivationCommented-block, by
%              reading all existing subsystems and setting the
%              corresponding parameters within the mask
% ------------------------------------------------------------------------
% Input:    - []: No inputs
%
% ------------------------------------------------------------------------
% Output:   - []: No outputs
% ------------------------------------------------------------------------


%% Setup Routine:

mask = Simulink.Mask.get(gcb);
    %Get the mask handle of the activation subsystem
Setup = find_system(gcb,'IncludeCommented','On','SearchDepth','1','LookUnderMasks','all','BlockType','SubSystem');
    %Find all subsystems within the masked activation subsystem
Setup(1) = [];
    %Clear first entry, as it is the activation container itself


if isempty(Setup)
    %No existing subsystems within container, set all parameter containers
    %invisible/inactive
    
    for i_setup = 0:9
    
        group = mask.getDialogControl(['Container' num2str(i_setup)]);
        group.Visible = 'off';
            %Set all parameter containers that are not in use to invisible
        set_param(gcb,['Status' num2str(i_setup)],'Inactive');
            %Set all subsystems that are not in use to inactive
        set_param(gcb,['Subsystem' num2str(i_setup)],'');
            %Clear name of inactive subsystem variable
    end
    
elseif ~isempty(Setup{1,1})
    %Subsystems within container exist; set corresponding
    %parameter container to visible

    for i_setup = 1:size(Setup,1)
        
        help_variable = find_system(Setup{i_setup,1},'IncludeCommented','On','BlockType','SubSystem');
            %Get path of sim2gether block within subsystem
        help_variable = [help_variable ; get_param(help_variable{1,1},'Handle')];
        
        for i_type = 1:size(help_variable,1)
        
            block_type = Simulink.Mask.get(help_variable{i_type,1});
            
            if isempty(block_type)
                continue
            elseif strcmp(block_type.Type,'SB')
                continue
            elseif ~strcmp(block_type.Type,'SB')
                help_variable{i_type,:} = [];
            end
        end
        
        help_variable = help_variable(~cellfun(@isempty, help_variable(:,1)), :);
        
        if ~strcmp(get_param(help_variable{1,1},'Name'),get_param(help_variable{2,1},'Name'))
            %Check if name of subsystem corresponds to name of sim2gether
            %block within subsystem
            
            set_param(Setup{i_setup,1},'Name',erase(help_variable{2,1},[help_variable{1,1} '/']));
                %Set name of subsystem to name of sim2gether block, it
                %contains
            Setup{i_setup,1} = getfullname(help_variable{end,1});
                %Write new subsystem name to Setup struct
        end
        
        Setup{i_setup,2} = get_param(Setup{i_setup,1},'Name');
            %Get name of existing activation subsystems
            
        Setup{i_setup,3} = str2double( get_param(Setup{i_setup,1},'Description') );
            %Get index of activation subsystem by reading the description
            
        set_param(gcb,['Subsystem' num2str(Setup{i_setup,3})],Setup{i_setup,2});
            %Set value of subsystem variable to name of corresponding
            %subsystem
            
        group = mask.getDialogControl(['Container' num2str(Setup{i_setup,3})]);
        group.Visible = 'on';
            %Get handle to Container-group for corresponding parameters and
            %set it to visible
        
        parameter = mask.getParameter(['Status' num2str(Setup{i_setup,3})]);
        parameter.Prompt = ['Activity status of "' Setup{i_setup,2} '":'];
            %Change prompt for subsystem variable on mask dialog to name of
            %corresponding subsystem
    end
    
    
    help_variable = [0:9]';
    help_variable = help_variable(~ismember([0:9]',[Setup{:,3}]'));
        %Get indices of inactive subsystems

    for i_setup = 1:length(help_variable)
   
        group = mask.getDialogControl(['Container' num2str(help_variable(i_setup,1))]);
        group.Visible = 'off';
            %Set all parameter containers that are not in use to invisible
        set_param(gcb,['Status' num2str(help_variable(i_setup,1))],'Inactive');
            %Set all subsystems that are not in use to inactive
        set_param(gcb,['Subsystem' num2str(help_variable(i_setup,1))],'');
            %Clear name of inactive subsystem variable
    
    end
end

end

