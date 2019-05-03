%% Description:
% Designed by: Benedikt Danquah (FTM, Technical University of Munich)
% Created on: 01/2019, Version: Matlab2018b
%-------------
% Description: The function appends two timeseries, if more than one
% driving cycle is choosen.
% ------------
% Input:    - Timeseries1: first array of timeseries
%           - Timeseries2: second array of timeseries
% ------------
% Output:   - AppendedTimeseries: 
%-------------

function AppendedTimeseries = AppendNonuniformTimeseries_inDrivingcycle(Timeseries1,Timeseries2)
%APPENDNONUNIFORMTimeseries Summary of this function goes here
%   Detailed explanation goes here
Time1Increment=Timeseries1.TimeInfo.Increment;
Timeseries1=resample(Timeseries1,...
    Timeseries1.TimeInfo.Start:Timeseries1.TimeInfo.Increment:Timeseries1.TimeInfo.End,...
    'linear') ;
Timeseries1=setuniformtime(Timeseries1,...
    'StartTime',(Timeseries1.TimeInfo.Start),...
    'Interval',Time1Increment);

Time2Increment=Timeseries2.TimeInfo.Increment;
Timeseries2=resample(Timeseries2,...
    Timeseries2.TimeInfo.Start:Timeseries2.TimeInfo.Increment:Timeseries2.TimeInfo.End,...
    'linear') ;

Timeseries2=setuniformtime(Timeseries2,...
    'StartTime',(Timeseries1.TimeInfo.End+Time1Increment),...
    'Interval',Time2Increment);

AppendedTimeseries=append(Timeseries1,Timeseries2);

AppendedTimeseries=resample(AppendedTimeseries,...
    AppendedTimeseries.TimeInfo.Start:min(Timeseries1.TimeInfo.Increment,Timeseries2.TimeInfo.Increment):AppendedTimeseries.TimeInfo.End,...
    'linear'); 
AppendedTimeseries=setuniformtime(AppendedTimeseries,...
    'StartTime',(AppendedTimeseries.TimeInfo.Start),...
    'Interval',min(Timeseries1.TimeInfo.Increment,Timeseries2.TimeInfo.Increment));
end

