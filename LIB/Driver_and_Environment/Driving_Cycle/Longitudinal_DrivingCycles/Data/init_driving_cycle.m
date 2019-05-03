function dc = init_driving_cycle( dcname, dccircuits,  dc_speed,  dc_gear)
%% Description:
% Designed by: Alexander Koch (FTM, Technical University of Munich)
% Created on: 01.05.2018, Version: Matlab2018b
%-------------
% Description: Allows to choose between 20 different driving cycles and gives the acceleration, speed, distance and gear 
%              for the corresponding time. Further option is to repeat the cycle.
% ------------
% Input:    - dcname:       Name of driving cycle
%           - dccircuits:   number of driving cycles
%           - dc_speed:     vehicle speed as defined in the driving cylce data
%           - dc_gear:      gear as defined in the driving cylce data
% ------------
% Output:    - dc: struct for driving cycle model with speed and gear
% ------------
% References:   - [1] S. Mueller, S. Rohr, und et al, Hrsg, Analysing the Influence of Driver Behaviour and Tuning 
%                     Measures on Battery Aging and Residual Value of Electric Vehicles, 2017
%%-------------

gear_data_available = ~isempty(dc_gear);

if strcmp(dcname,'Custom_Driving_Cycle')
    
    if size(dc_speed,2) == 1     % time series
        dc.speed = dc_speed;
    elseif size(dc_speed,2) == 2 % struct
        dc.speed = timeseries(dc_speed(:,1),dc_speed(:,2));
    else
        dc.speed = timeseries([0 0],[0 1]);
    end
    
    if gear_data_available == 1
        if size(dc_gear,2) == 1 
            dc.gear = dc_gear;
        elseif size(dc_gear,2) == 2
            dc.gear = timeseries(dc_gear(:,1),dc_gear(:,2));
        end
    else
        dc.gear=timeseries([0;0],[dc.speed.TimeInfo.Start,dc.speed.TimeInfo.End]);
    end
    
else
    load(dcname);
    dc.speed = timeseries(dc.speed,dc.time);
    
    if gear_data_available == 1
        dc.gear = timeseries(dc.gear,dc.time);
    else
        dc.gear=timeseries([0;0],[dc.speed.TimeInfo.Start,dc.speed.TimeInfo.End]);
    end
end

for i=1:dccircuits-1
    dc.speed = AppendNonuniformTimeseries_inDrivingcycle(dc.speed,dc.speed);
    
    if gear_data_available == 1
        dc.gear =  AppendNonuniformTimeseries_inDrivingycle(dc.gear,dc.gear);
    else
        dc.gear=timeseries([0;0],[dc.speed.TimeInfo.Start,dc.speed.TimeInfo.End]);
    end
end

dc.speedplot=timeseries([0;0],[dc.speed.TimeInfo.End,dc.speed.TimeInfo.End*1.2]);
dc.speedplot=AppendNonuniformTimeseries_inDrivingcycle(dc.speed,dc.speedplot);

stoptime = dc.speed.TimeInfo.End;
set_param(char(bdroot(gcb)),'StopTime',num2str(stoptime));

end

