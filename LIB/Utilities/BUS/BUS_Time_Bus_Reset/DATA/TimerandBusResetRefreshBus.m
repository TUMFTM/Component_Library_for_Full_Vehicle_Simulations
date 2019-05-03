function []=TimerandBusResetRefreshBus()
BSPath=strcat(gcb,'/Bus Selector')

InSignals=get_param(BSPath,'InputSignals')


BSOutput=InSignals{1,1}{1,1};
for i=2:length(InSignals)-1
    AddName=InSignals{i,1}{1,1}
    %try
    BSOutput=strcat(BSOutput,',',AddName)
    %catch
    %   BSOutput=strcat(BSOutput,',',AddName)
    %end
end


set_param(BSPath, 'OutputSignals', BSOutput)

end