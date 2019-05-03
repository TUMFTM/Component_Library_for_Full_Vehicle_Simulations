function [MonotonousMap,OM_MotVector, M_MotVector]=ConvertToMonotonousMap(OM_M_Pel_Map,OM_MotVector,M_MotVector,M_Full_Load,OM_Full_Load,M_Min_Load,OM_Min_Load,SupportPoints)
% Designed by: Benedikt Danquah (FTM, Technical University of Munich)
% Created on: 01/2019, Version: Matlab2018b
% ------------------------------------------------------------------------
% Description: Converts electric power map to a strictly monotonous map.
% ------------------------------------------------------------------------
% Input:    - OM_M_Pel_Map: electric power map
%           - M_MotVector: torque vector
%           - OM_MotVector: speed vector
%           - M_Full_Load: torque full load line
%           - OM_Full_Load: speed full load line
%           - M_Min_Load: torque min load line
%           - OM_Min_Load: speed min load line
% ------------------------------------------------------------------------
% Output:   - MonotonousMap: monotonous electric power map
%           - OM_MotVector: adapted speed vector
%           - M_MotVector: adapted torque vector
% ------------------------------------------------------------------------
% References:   - [1]L. Horlbeck, "Auslegung elektrischer Maschinen für automobile Antriebsstränge unter Berücksichtigung
%                    des Überlastpotentials", Technische Universität München, München, 2018
% ------------------------------------------------------------------------
if size(M_Full_Load,1)>1
    OM_Full_Load=OM_Full_Load';
end
if size(OM_Full_Load,1)>1
    M_Full_Load=M_Full_Load';
end
if size(M_Min_Load,1)>1
    M_Min_Load=M_Min_Load';
end
if size(OM_Min_Load,1)>1
    OM_Min_Load=OM_Min_Load';
end

M_Full_Load_needed=interp1(OM_Full_Load,M_Full_Load,OM_MotVector);
M_Full_Load_needed=fillmissing(M_Full_Load_needed,'nearest');
M_Min_Load_needed=interp1(OM_Min_Load,M_Min_Load,OM_MotVector);
M_Min_Load_needed=fillmissing(M_Min_Load_needed,'nearest');

Motorgrid=griddedInterpolant({OM_MotVector',M_MotVector},OM_M_Pel_Map);
MonotonousMap=zeros(size(OM_M_Pel_Map));
for OMs=1:1:size(OM_MotVector-1,2)
   
%     values=(M_Min_Load_needed(OMs):M_Full_Load_needed(OMs):M_Min_Load_needed(OMs))
    Motorvalue_max=Motorgrid(OM_MotVector(OMs),M_Full_Load_needed(OMs));
    Motorvalue_min=Motorgrid(OM_MotVector(OMs),M_Min_Load_needed(OMs));
    MonotonousMap(OMs,:)=interp1([M_Full_Load_needed(OMs);M_Min_Load_needed(OMs)],[Motorvalue_max;Motorvalue_min],M_MotVector);
end
MonotonousMap=fillmissing(MonotonousMap','nearest')';
end