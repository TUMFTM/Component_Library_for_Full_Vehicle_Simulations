function [WorkspaceParameters] = get_workspace_parameter(Blockpath)
% Designed by: Benedikt Danquah (FTM, Technical University of Munich)
% Created on: 01.05.2019, Version: Matlab2018b
% ------------------------------------------------------------------------
% Description: Reads Workspace Variables of Simulink Block and returns it
% as a strct
% ------------------------------------------------------------------------
% Input:    - Blockpath: Path to Simulink Block
% ------------------------------------------------------------------------
% Output:   - WorkspaceParameters: workspace Parameters of desired Block
% ------------------------------------------------------------------------
 variables = get_param(Blockpath,'MaskWSVariables'); 
    
    for i= 1:length(variables)
        name = {variables(i).Name};
        value = variables(i).Value;
        WorkspaceParameters.(name{1}) = value;
    
    end
end

