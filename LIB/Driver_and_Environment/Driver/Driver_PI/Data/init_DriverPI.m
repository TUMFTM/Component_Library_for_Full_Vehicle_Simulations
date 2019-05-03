function [ThrottleP,ThrottleI,BrakeP,BrakeI,hysteresis] = init_DriverPI(LocalSampleTime,GlobalSampleTime)

% Designed by: Benedikt Taiber (FTM, Technical University of Munich)
% ------------------------------------------------------------------------
% Description: Function initializes Temperature block
% ------------------------------------------------------------------------
% Input:    - LocalSampleTime: local sample time within Driver PI-block
%           - GlobalSampleTime: global sample time of entire simulation
%                               model
% ------------------------------------------------------------------------
% Output:   - ThrottleP: P-value for throttle control of controller
%           - ThrottleI: I-value for throttle control of controller
%           - BrakeP: P-value for brake control of controller
%           - BrakeI: I-value for brake control of controller
% -----------------------------------------------------------------------

LocalSampleTime = str2num(LocalSampleTime);
GlobalSampleTime = str2num(GlobalSampleTime);

%% Set controller parameters:

if isempty(GlobalSampleTime)
    
    ThrottleP = 14;
    ThrottleI = 0.12;
    BrakeP = 14;
    BrakeI = 0.12;
    hysteresis = 0.045;

elseif LocalSampleTime == -1 
    %Case of inherited sample time for local sample time
    if GlobalSampleTime <= 0.005
        ThrottleP = 28;
        ThrottleI = 0.25;
        BrakeP = 28;
        BrakeI = 0.25;
        hysteresis = 0.04;
        
    elseif (0.005 < GlobalSampleTime) && (GlobalSampleTime <= 0.05)
        ThrottleP = 14;
        ThrottleI = 0.12;
        BrakeP = 14;
        BrakeI = 0.12;
        hysteresis = 0.045;
        
    elseif (0.05 < GlobalSampleTime) && (GlobalSampleTime <= 0.5)
        ThrottleP = 2;
        ThrottleI = 0.01;
        BrakeP = 2;
        BrakeI = 0.01;
        hysteresis = 0.05;
        
    elseif GlobalSampleTime > 0.5
        ThrottleP = 0.125;
        ThrottleI = 0.00025;
        BrakeP = 0.125;
        BrakeI = 0.00025;
        hysteresis = 0.45;
    end
    
elseif LocalSampleTime ~= -1
    
    if LocalSampleTime <= 0.005
        ThrottleP = 28;
        ThrottleI = 0.25;
        BrakeP = 28;
        BrakeI = 0.25;
        hysteresis = 0.04;
        
    elseif (0.005 < LocalSampleTime) && (LocalSampleTime <= 0.05)
        ThrottleP = 14;
        ThrottleI = 0.12;
        BrakeP = 14;
        BrakeI = 0.12;
        hysteresis = 0.045;
        
    elseif (0.05 < LocalSampleTime) && (LocalSampleTime <= 0.5)
        ThrottleP = 2;
        ThrottleI = 0.01;
        BrakeP = 2;
        BrakeI = 0.01;
        hysteresis = 0.05;
        
    elseif LocalSampleTime > 0.5
        ThrottleP = 0.125;
        ThrottleI = 0.00025;
        BrakeP = 0.125;
        BrakeI = 0.00025;
        hysteresis = 0.45;
        
    end
end

set_param(gcb,'ThrottleP',num2str(ThrottleP),...
              'ThrottleI',num2str(ThrottleI),...
              'BrakeP',num2str(BrakeP),...
              'BrakeI',num2str(BrakeI),...
              'hysteresis',num2str(hysteresis));

end

