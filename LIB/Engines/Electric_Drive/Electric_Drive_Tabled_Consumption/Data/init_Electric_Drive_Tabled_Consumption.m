function [OM_PEl_M_Map,OM_MotVector, PEl_MotVector]= init_Electric_Drive_Tabled_Consumption (OM_M_Pel_Map,M_MotVector,OM_MotVector,M_Full_Load,OM_Full_Load,M_Min_Load,OM_Min_Load)
%% Description:
% Designed by: Benedikt Danquah (FTM, Technical University of Munich)
% Created on: 01/2019, Version: Matlab2018b
% ------------------------------------------------------------------------
% Description: The function calculates the power map of the electric motor,
%              and the omega vector and electric power vector.
% ------------------------------------------------------------------------
% Input:    - OM_M_Pel_Map: electric power map
%           - M_MotVector: input torque vector
%           - OM_MotVector: input speed vector
%           - M_Full_Load: torque full load line
%           - OM_Full_Load: speed full load line
%           - M_Min_Load: torque min load line
%           - OM_Min_Load: speed min load line
% ------------------------------------------------------------------------
% Output:   - OM_PEl_M_Map: inverted electric power map
%           - OM_MotVector: adapted speed vector
%           - PEl_MotVector: adapted electric power vector
% ------------------------------------------------------------------------
% Convert Map to strictly monotonous Map

[MonotonousMap,OM_MotVector, M_MotVector]=ConvertToMonotonousMap(OM_M_Pel_Map,OM_MotVector,M_MotVector,M_Full_Load,OM_Full_Load,M_Min_Load,OM_Min_Load,3);
%[xq,yq] = meshgrid(OM_Vector, M_Vector);
%figure
%surfc(OM_Vector,M_Vector,MonotonousMap')

[OM_PEl_M_Map,OM_MotVector, PEl_MotVector]=invert3dMap(MonotonousMap,OM_MotVector,M_MotVector);
%[xq,yq] = meshgrid(OM_Vector, PEl_Vector);
% figure
% surfc(OM_MotVector,PEl_MotVector,OM_PEl_M_Map')
end

