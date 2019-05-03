function GlobalSampleTime = CalcGlobalSampleTime(LocalSampleTime)
% Designed by: Benedikt Danquah (FTM, Technical University of Munich)
% Created on: 25.04.2019, Version: Matlab2018b
% ------------------------------------------------------------------------
% Description: Calculates the global Sample Time of the current simulation
% ------------------------------------------------------------------------
% Input:    - LocalSampleTime: Local Sample Time of Block
% ------------------------------------------------------------------------
% Output:    - GlobalSampleTime: global Sample time of Simulation
% ------------------------------------------------------------------------
GlobalSampleTime=str2num(get_param(bdroot,'FixedStep'));
if strcmp('auto',GlobalSampleTime) 
    GlobalSampleTime=-1;
end
end

