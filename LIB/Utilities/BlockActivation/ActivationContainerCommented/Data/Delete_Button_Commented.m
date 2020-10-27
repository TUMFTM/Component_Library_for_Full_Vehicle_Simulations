function [] = Delete_Button_Commented(index)

% Designed by: Benedikt Taiber (FTM, Technical University of Munich)
% ------------------------------------------------------------------------
% Description: Function clears all blocks and lines corresponding to the
%              subsystem/parameter-container with index number within the
%              BlockActiationCommented-block

% ------------------------------------------------------------------------
% Input:    - index: Index number of 'DeleteX' button, identifying all
%                    corresponding blocks and lines
%
% ------------------------------------------------------------------------
% Output:   - []: No Outputs
%
% ------------------------------------------------------------------------

%% Extract necessary block names/handles and line handles:

mask = Simulink.Mask.get(gcb);
path = gcb;
    %Get mask handle and path

subsystem_block = [gcb '/' get_param(gcb,['Subsystem' num2str(index)])];
    %Get path of subsystem corresponding to index number

source_block = get_param(subsystem_block,'PortConnectivity');
source_block = [source_block.SrcBlock]';
    %Handles of subsystem's source blocks
    
dest_block = get_param(subsystem_block,'PortConnectivity');
dest_block = [dest_block.DstBlock]';
    %Handles of subsystem's destination blocks

    
%% Delete all blocks and lines corresponding to index number:
    
if ~isempty(source_block)
    %Check if source blocks exist
    
    for i_delete = 1:length(source_block)
    
        %Check if subsystem inport is connected to input/ground block:
        
        if source_block(i_delete,1) > 0
            %Connection between subsystem and input/ground block exists
            
            source_block_dst = get_param(source_block(i_delete,1),'PortConnectivity');
            
                if length([source_block_dst.DstBlock]) < 2
                    %Input/Ground block serves only one subsystem

                    delete_block(source_block(i_delete,1));
                        %Delete found source block for subsystem
                        
                elseif length([source_block_dst.DstBlock]) > 1
                    %Input block serves more than one subsystem;
                    %input/ground block is not deleted, only connection line
                end
                    
        elseif source_block(i_delete,1) < 0
                %No connection between subsystem and input/ground block
        end
    end
end


if ~isempty(dest_block)
    %Check if destination blocks exist
    
    for i_delete = 1:length(dest_block)
        
        %Check if subsystem outport is connected to any destination block:
        
        if dest_block(i_delete,1) > 0
            %Connection between subsystem and destination block exists
            
            %Check type of destination block:
            
            dest_block_type = get_param(dest_block(i_delete,1),'BlockType');
            
            if strcmp(dest_block_type,'Outport') || strcmp(dest_block_type,'Terminator')
                %Destination block is a Outport/Terminator block and can be
                %deleted
                
                delete_block(dest_block(i_delete,1));
                    %Delete found destination block for subsystem outport
                    
            elseif strcmp(dest_block_type,'Sum')
                %Destination block is an Add block
                
                reconfig_add_block(dest_block,i_delete,subsystem_block);
                    %Call function to reconfigure signals and add block
                
            end
        end
    end
end


line_handles = get_param(subsystem_block,'LineHandles');
line_handles = [line_handles.Inport line_handles.Outport]';
    %Handles of all lines going in/out of subsystem

if ~isempty(line_handles)
    %Check if any lines emerge from subsystem
    
    for i_delete = 1:length(line_handles)
        
        if line_handles(i_delete,1) > 0
            %Check if in-/outport of subsystem has emerging line
            
            delete_line(line_handles(i_delete,1));
                %Delete all found lines going in/out of subsystem
        
        elseif line_handles(i_delete,1) < 0
        end
    end
end


delete_block(subsystem_block);
    %Delete subsystem corresponding to index number
    
group = mask.getDialogControl(['Container' num2str(index)]);
group.Visible = 'off';
set_param(path,['Status' num2str(index)],'Inactive');
set_param(path,['Subsystem' num2str(index)],'');
    %Set corresponding parameter container invisible and set parameters to
    %inactive
    
    
end

