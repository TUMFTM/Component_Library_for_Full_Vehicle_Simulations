%% Description:
% Designed by: Benedikt Danquah (FTM, Technical University of Munich)
%-------------
% Created on: 01/2019
% ------------
% Version: Matlab2018b
%-------------
% Description: Plots the power map of the electric motor
% ------------
% References:   - [1]L. Horlbeck, "Auslegung elektrischer Maschinen für automobile Antriebsstränge unter Berücksichtigung
%                    des Überlastpotentials", Technische Universität München, München, 2018
%%-------------

load('Full_Load_Mot');
load('Min_Load_Mot');
load('Leistungskennfeld_Mot')
[OM_PEl_M_Map,OM_MotVector, PEl_MotVector]= init_Electric_Drive_Tabled_Consumption (OM_M_Pel_Map,M_MotVector,OM_MotVector,M_Full_Load,OM_Full_Load,M_Min_Load,OM_Min_Load);

figure
hold on
surfc(OM_MotVector,M_MotVector,OM_M_Pel_Map')
for i=1:1000
    plot3(OM_Full_Load,M_Full_Load,ones(1,61)*i*30,'color','red', 'linewidth',6)
end
hold off


figure
surfc(OM_MotVector,PEl_MotVector,OM_PEl_M_Map')
