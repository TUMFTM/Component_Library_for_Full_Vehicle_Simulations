function [MonotonousMap]=ConvertToMonotonousMap(OM_M_Pel_Map,M_MotVector)
% Designed by: Benedikt Danquah (FTM, Technical University of Munich)
% Created on: 01/2019, Version: Matlab2018b
% ------------------------------------------------------------------------
% Description: Converts electric power map to a strictly monotonous map in 
% torque (second dim) direction when speed is constant.
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


PelMap=OM_M_Pel_Map;
ZeroPos=find(M_MotVector==(min(abs(M_MotVector))));
MinPos=find(M_MotVector==min(M_MotVector));
MaxPos=find(M_MotVector==max(M_MotVector));
MotPartTPositions=ZeroPos:MaxPos;
GenPartTPositions=flip(MinPos:ZeroPos-1);

for iSpeed=1:size(PelMap,1)
    
    MotPart=convert_to_monotonous_growing_vector(PelMap(iSpeed,MotPartTPositions));
    PelMap(iSpeed,MotPartTPositions)=MotPart;
        
    GenPart=convert_to_monotonous_falling_vector(PelMap(iSpeed,GenPartTPositions));
    PelMap(iSpeed,GenPartTPositions)=GenPart;
    
end
MonotonousMap=PelMap;
end


 
 function Growing_Vect=convert_to_monotonous_growing_vector(vector)
     if isempty(vector)==0
            OldElem=vector(1);
              for iElem=2:length(vector)
                    if vector(iElem)>OldElem
                         OldElem=vector(iElem);
                    else
                        vector(iElem)=NaN;
                    end
              end
              if isnan(vector(end))
                  vector(end)=OldElem+abs(OldElem*0.0000000001);
              end
            Growing_Vect=fillmissing(vector,'linear');
     else
         Growing_Vect=[];
     end
 end
 
 
  function Falling_Vect=convert_to_monotonous_falling_vector(vector)
      if isempty(vector)==0
        OldElem=vector(1);
          for iElem=2:length(vector)
                if vector(iElem)<OldElem
                     OldElem=vector(iElem);
                else
                    vector(iElem)=NaN  ;
                end
          end
          if isnan(vector(end))
              vector(end)=OldElem-abs(OldElem*0.0000000001);
          end
        Falling_Vect=fillmissing(vector,'linear');

      else
        Falling_Vect=[];
      end
  end