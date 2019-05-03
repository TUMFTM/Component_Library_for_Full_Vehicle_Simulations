%% Description:
% Designed by: Tony Weiss (FTM, Technical University of Munich)
%-------------
% Created on: 16.04.2018
% ------------
% Version: Matlab2017b
%-------------
% Description: Function for ploting the efficiency map
% ------------
% Input:    - current path of inverter: Matlab Path
% ------------
% References:   - [1] Lukas Wheldon, “Modellbasierte Analyse des Effizienzsteigerungspotentials einer aktiven 
%                     Batteriepackverschaltung im elektrischen Antriebsstrang,” Technische Universität München, München, 2017
%%-------------

function InitPlotInverter(current_path_inverter)

%% get data of mask workspace variables
var_inver = get_param(current_path_inverter,'MaskWSVariables'); 
    
    for i_eplot= 1:length(var_inver)
        name = {var_inver(i_eplot).Name};
        value = var_inver(i_eplot).Value;
        struct.(name{1}) = value;
    end

%% generell parameters
    tg = 11;                %font size
    ta = 'Helvetica';       %font name
    

%% figure plot    
    h1 = figure;
    h1.Name = 'Electric Power Losses Inverter';
    grid on;
    x_value = struct.W_Vektor;
    y_value = struct.M_Vektor_motgen;
    z_value = struct.P_Loss;
    z_value = z_value';
    surf(x_value,y_value,z_value);
    ax1 = gca;
    %ax1.ActivePositionProperty = 'outerposition';
    ax1.FontName = ta;
    ax1.FontSize = tg;
    xlabel(ax1,'Angular Velocity{\it {\omega}} in rad/s');
    ylabel(ax1,'Torque{\it M} in N m');
    set(ax1,'XLim', [min(x_value) max(x_value)],'YLim',[min(y_value) max(y_value)],'ZLim',[min(min(z_value)) max(max(z_value))]);
    ax1.View = [-40 30];
    colormap(ax1,'jet');
    cb = colorbar;
    cb.Location = 'eastoutside';
    cb.Label.String = 'Electric Power Losses{\it P} in W';
    cb.FontSize = tg;
    cb.FontName = ta;
    xtickangle(-30);
    ytickangle(20);
    ylh = get(ax1,'ylabel');                                                    
    ylp = get(ylh, 'Position');
    set(ylh, 'Rotation',-30, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
    xh = get(ax1,'xlabel');                                                    
    xp = get(xh, 'Position');
    set(xh, 'Rotation',22, 'Position',xp, 'VerticalAlignment','middle', 'HorizontalAlignment','left')
end

