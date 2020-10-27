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

[MonotonousMap]=ConvertToMonotonousMap(OM_M_Pel_Map,M_MotVector);
szOM=size(OM_M_Pel_Map,1);
szT=size(OM_M_Pel_Map,2);
OM_MotVectorMesh=OM_MotVector'*ones(1,szT);
M_MotVectorMesh=ones(szOM,1)*M_MotVector;

%convert map
PEl_MotVectorMesh=ones(szOM,1)*(min(min(MonotonousMap)):((max(max(MonotonousMap))-min(min(MonotonousMap)))/(szT-1)):max(max(MonotonousMap)));
PEl_MotVector=PEl_MotVectorMesh(1,:);
OM_PEl_M_Map=griddata(OM_MotVectorMesh,MonotonousMap,M_MotVectorMesh,OM_MotVectorMesh,PEl_MotVectorMesh);
ZeroPos=find(PEl_MotVector==(min(abs(PEl_MotVector))));
MinPos=find(PEl_MotVector==min(PEl_MotVector));
MaxPos=find(PEl_MotVector==max(PEl_MotVector));
MotPartTPositions=ZeroPos:MaxPos;
GenPartTPositions=flip(MinPos:ZeroPos-1);

OM_PEl_M_Map(:,MotPartTPositions)=fillmissing(OM_PEl_M_Map(:,MotPartTPositions),'nearest','EndValues',max(max(OM_PEl_M_Map(:,MotPartTPositions))));
OM_PEl_M_Map(:,GenPartTPositions)=fillmissing(OM_PEl_M_Map(:,GenPartTPositions),'nearest','EndValues',min(min(OM_PEl_M_Map(:,GenPartTPositions))));
end

