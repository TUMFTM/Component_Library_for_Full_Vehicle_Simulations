function []=BusRefreshBusSelector()

BSSPath=strcat(gcb,'/Bus Selector')
InSignals={}
InSignals=get_param(BSSPath,'InputSignals')


%NEW Element
BSOutput=(InSignals{2}{1})

LengthSignalTwo=length(InSignals{1}{2})


for i=1:LengthSignalTwo
    AddName=InSignals{1,1}{1,2}{i,1}
    if iscell(AddName)==0
    BSOutput=strcat(BSOutput,',BUS.',AddName)
    else
    BSOutput=strcat(BSOutput,',BUS.',AddName{1})
    end
end


    set_param(BSSPath, 'OutputSignals', string(BSOutput))
    
end
