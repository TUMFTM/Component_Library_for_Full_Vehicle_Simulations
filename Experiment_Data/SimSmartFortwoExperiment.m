function [simulation,cycle] = SimSmartFortwoExperiment(ModelName,experiment, experimentno)
% Designed by: Benedikt Danquah (FTM, Technical University of Munich)
% Created on: 10.02.2019, Version: Matlab2018b
% ------------------------------------------------------------------------
% Description: Runs a Simulink Longitudinal Simulation Model using the
%              measured driving cycles of an experiment
% ------------------------------------------------------------------------
% Input:    - ModelName: Name of Model to simulate
%           - experiment: Experiment Data of Nexperiments
%           - experimentno: Number of current experiment
% ------------------------------------------------------------------------
% Output:    - simulation: Simulation Results
%            - cycle: Driving cycle
% ------------------------------------------------------------------------

cycle=experiment(experimentno).VehicleSpeedFiltered;                        % Extract Driving Cycle of experiment

StopTime=experiment(experimentno).DrivingCycle.TimeInfo.End;                % Estimate Stop time of driving cycle
assignin('base','cycle',cycle);                                             % load Driving cycle in main workspace 

simn=sim(ModelName,'StopTime',num2str(StopTime));                           % Simulate given model

result=simn.logsout;                                                        % save logsout data to result
simulation.name=experiment(experimentno).name;                              % save simulation Data in defined struct and return data
simulation.Consumption=result{2}.Values.CumulativeConsumption__Wh_    ;     
simulation.VehicleDesiredSpeed=result{2}.Values.CycleSpeed__m_s_   ;
simulation.VehicleSpeed=result{2}.Values.VehicleSpeed__m_s_   ;
simulation.BatPower=result{2}.Values.Actual_power_Power_Source__W_   ;
simulation.Torque=result{2}.Values.DriveWheelTorque__Nm_  ;
end

