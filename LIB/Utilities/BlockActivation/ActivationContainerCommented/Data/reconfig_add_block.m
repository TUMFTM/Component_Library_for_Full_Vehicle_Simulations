function [] = reconfig_add_block(dest_block,i_delete,subsystem_block)

% Designed by: Benedikt Taiber (FTM, Technical University of Munich)
% ------------------------------------------------------------------------
% Description: Function deletes/re-routes the output signals within the
%              activation container depending on the number of remaining
%              enabled subsystems
% ------------------------------------------------------------------------
% Input:    - dest_block: Array containing the handles of the destination
%                         blocks for the subsystem, which will be deleted
%           - i_delete: Current counting index of for-loop function is
%                       nested in
%           - subsystem_block: Path of subsystem block, which will be
%                              deleted
%
% ------------------------------------------------------------------------
% Output:   - []: No Outputs
% ------------------------------------------------------------------------

%%Re-routing process:

sum_ports = get_param(dest_block(i_delete,1),'PortConnectivity');
sum_lines = get_param(dest_block(i_delete,1),'LineHandles');
%Get port and line information of sum block
                
if length([sum_ports.SrcBlock]) < 3
    %Sum block has two inputs
                    
    delete_line([sum_lines.Inport sum_lines.Outport]);
        %Delete all lines emerging from sum block
    delete_block(dest_block(i_delete,1));
        %Delete Sum-Block
                        
    for i_sum = 1:2
        
        outport_handle = get_param(sum_ports(i_sum).SrcBlock,'PortHandles');
        outport_handle = outport_handle.Outport(1, sum_ports(i_sum).SrcPort+1);
        	%Get handle of output of subsystem
                    
        inport_handle = get_param(sum_ports(size(sum_ports,1)).DstBlock,'PortHandles');
        inport_handle = inport_handle.Inport;
        	%Get handle of input of outport block
                    
        if ~(sum_ports(i_sum).SrcBlock == get_param(subsystem_block,'Handle'))
                        
        	add_line(gcb,outport_handle,inport_handle,'autorouting','smart');
        end
        	%Re-connect output of remaining subsystem to outport
    end
                    
elseif length([sum_ports.SrcBlock]) > 2
	%Sum block has more than two inputs
                   
	delete_line([sum_lines.Inport]);
    	%Delete all input lines of sum block
    set_param(dest_block(i_delete,1), 'Inputs', repmat('+',1,strlength(get_param(dest_block(i_delete,1),'Inputs')) - 1) );
    	%Reduce number of inputs of sum block by 1
                        
    for i_sum = 1:length([sum_ports.SrcBlock])
        %Go through all subsystems connected to sum block
                
        if ~(sum_ports(i_sum).SrcBlock == get_param(subsystem_block,'Handle'))
            %Check if subsystem still exists respectively is not the
            %subsystem, which is being deleted
            
            outport_handle = get_param(sum_ports(i_sum).SrcBlock,'PortHandles');
            outport_handle = outport_handle.Outport(1, sum_ports(i_sum).SrcPort+1);
                %Get handle of output of subsystem
                    
            inport_handle = get_param(dest_block(i_delete,1),'PortHandles');
            inport_handle = inport_handle.Inport(1,i_sum);
                %get handle of input of sum block
            
            add_line(gcb,outport_handle,inport_handle,'autorouting','smart');
            
        end
     end
end


% %%Re-routing process:
% 
% merge_ports = get_param(dest_block(i_delete,1),'PortConnectivity');
% merge_lines = get_param(dest_block(i_delete,1),'LineHandles');
% %Get port and line information of merge block
%                 
% if length([merge_ports.SrcBlock]) < 3
%     %Merge block has two inputs
%                     
%     delete_line([merge_lines.Inport merge_lines.Outport]);
%         %Delete all lines emerging from merge block
%     delete_block(dest_block(i_delete,1));
%         %Delete Merge-Block
%                         
%     for i_merge = 1:2
%                         
%         outport_handle = get_param(merge_ports(i_merge).SrcBlock,'PortHandles');
%         outport_handle = outport_handle.Outport(1, merge_ports(i_merge).SrcPort+1);
%         	%Get handle of output of subsystem
%                     
%         inport_handle = get_param(merge_ports(size(merge_ports,1)).DstBlock,'PortHandles');
%         inport_handle = inport_handle.Inport;
%         	%get handle of input of outport block
%                     
%         if ~(merge_ports(i_merge).SrcBlock == get_param(subsystem_block,'Handle'))
%                         
%         	add_line(gcb,outport_handle,inport_handle,'autorouting','smart');
%         end
%         	%Re-connect output of remaining subsystem to outport
%     end
%                     
% elseif length([merge_ports.SrcBlock]) > 2
% 	%Merge block has more than two inputs
%                    
% 	delete_line([merge_lines.Inport]);
%     	%Delete all input lines of merge block
%     set_param(dest_block(i_delete,1),'Inputs',num2str(length([merge_ports.SrcBlock])-1));
%     	%Reduce number of inputs of merge block by 1
%                         
%     for i_merge = 1:length([merge_ports.SrcBlock])
%         %Go through all subsystems connected to merge block
%                         
%         if ~(merge_ports(i_merge).SrcBlock == get_param(subsystem_block,'Handle'))
%             %Check if subsystem still exists respectively is not the
%             %subsystem, which is being deleted
%             
%             outport_handle = get_param(merge_ports(i_merge).SrcBlock,'PortHandles');
%             outport_handle = outport_handle.Outport(1, merge_ports(i_merge).SrcPort+1);
%                 %Get handle of output of subsystem
%             
%             inport_handle = get_param(dest_block(i_delete,1),'PortHandles');
%             inport_handle = inport_handle.Inport(1,i_merge);
%                 %Get handle of input of merge block
%                             
%             add_line(gcb,outport_handle,inport_handle,'autorouting','smart');
%                                 
%         end
%      end
% end

end

