function PlotMaps(blockpath)
% Designed by: Benedikt Danquah (FTM, Technical University of Munich)
% Created on: 01/2019, Version: Matlab2018b
% ------------------------------------------------------------------------
% Description: Get`s the mask workspace variables of the electric motor and
% plots the power map.
% ------------------------------------------------------------------------
% Input:    - blockpath: actual path of the electric motor model
% ------------------------------------------------------------------------
% References:   - [1]L. Horlbeck, "Auslegung elektrischer Maschinen für automobile Antriebsstränge unter Berücksichtigung
%                    des Überlastpotentials", Technische Universität München, München, 2018
% ------------------------------------------------------------------------
%% get data of mask workspace variables
var_edrive = get_param(blockpath,'MaskWSVariables'); 
    
    for i_eplot= 1:length(var_edrive)
        name = {var_edrive(i_eplot).Name};
        value = var_edrive(i_eplot).Value;
        struct.(name{1}) = value;
    end
    OM_M_Pel_Map=struct.OM_M_Pel_Map;
    M_MotVector=struct.M_MotVector;
    OM_MotVector=struct.OM_MotVector;
    M_Full_Load=struct.M_Full_Load;
    OM_Full_Load=struct.OM_Full_Load;
    M_Min_Load=struct.M_Min_Load;
    OM_Min_Load=struct.OM_Min_Load;
    OM_PEl_M_Map=struct.OM_PEl_M_Map;
    PEl_MotVector=struct.PEl_MotVector;
    
    

%% figure plot    


figure
hold on
surfc(OM_MotVector,M_MotVector,OM_M_Pel_Map')
for i=1:1000
    plot3(OM_Full_Load,M_Full_Load,ones(1,61)*i*30,'color','red', 'linewidth',6)
end
hold off


figure
surfc(OM_MotVector,PEl_MotVector,OM_PEl_M_Map')




   
end
% function InitPlotEDrive(current_path_edrive)
% 
% %% get data of mask workspace variables
% var_edrive = get_param(current_path_edrive,'MaskWSVariables'); 
%     
%     for i_eplot= 1:length(var_edrive)
%         name = {var_edrive(i_eplot).Name};
%         value = var_edrive(i_eplot).Value;
%         struct.(name{1}) = value;
%     end
% 
% %% generell parameters
%     tg = 11;                %font size
%     ta = 'Helvetica';       %font name
%     
% 
% %% figure plot    
%     h1 = figure;
%     h1.Name = 'Electric Power Losses E-Motor';
%     grid on;
%     x_value = struct.W_Vektor;
%     y_value = struct.M_Vektor_motgen;
%     z_value = struct.P_Loss;
%     z_value = z_value';
%     surf(x_value,y_value,z_value);
%     ax1 = gca;
%     %ax1.ActivePositionProperty = 'outerposition';
%     ax1.FontName = ta;
%     ax1.FontSize = tg;
%     xlabel(ax1,'Angular Velocity{\it {\omega}} in rad/s');
%     ylabel(ax1,'Torque{\it M} in N m');
%     set(ax1,'XLim', [min(x_value) max(x_value)],'YLim',[min(y_value) max(y_value)],'ZLim',[min(min(z_value)) max(max(z_value))]);
%     ax1.View = [-40 30];
%     colormap(ax1,'jet');
%     cb = colorbar;
%     cb.Location = 'eastoutside';
%     cb.Label.String = 'Electric Power Losses{\it P} in W';
%     cb.FontSize = tg;
%     cb.FontName = ta;
%     xtickangle(-30);
%     ytickangle(20);
%     ylh = get(ax1,'ylabel');                                                    
%     ylp = get(ylh, 'Position');
%     set(ylh, 'Rotation',-30, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
%     xh = get(ax1,'xlabel');                                                    
%     xp = get(xh, 'Position');
%     set(xh, 'Rotation',22, 'Position',xp, 'VerticalAlignment','middle', 'HorizontalAlignment','left')
% end
