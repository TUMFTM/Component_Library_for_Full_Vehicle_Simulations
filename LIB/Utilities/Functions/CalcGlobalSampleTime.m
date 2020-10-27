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
if isempty(GlobalSampleTime)==1
    if strcmp('auto',get_param(bdroot,'FixedStep')) 
    GlobalSampleTime=-1;
    else
        try
            modelwks=get_param(bdroot,'ModelWorkspace');
            GlobalSampleTime=getVariable(modelwks,get_param(bdroot,'FixedStep'));
        catch
            try
                GlobalSampleTime=evalin('base', get_param(bdroot,'FixedStep'));
            catch
                GlobalSampleTime=-1;
               % disp('Global SampleTime Could not be evaluated and is set to -1')
            end
        end
    end
end
end

