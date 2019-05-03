function []= WriteParaFile (Model)
% Designed by: Alexander Koch (FTM, Technical University of Munich)
% Created on: 01.05.2018, Version: Matlab2018b
% ------------------------------------------------------------------------
% Description: Creates a Parameterfile of a simulation Model. It sores all
% Data in of the Model masks. The Parameter file will be stored in the
% current folder.
% ------------------------------------------------------------------------
% Input:    - Model: Name of the model, of which the Parameter file should
%                    be created
% ------------------------------------------------------------------------
% Output:    - A Parameterfile will be created
% ------------------------------------------------------------------------
%% Get All Parameters

PARADATA=GetMaskParameters(Model);

%% Write MatFile

%Öffnen eines MatFiles
fileID=fopen([ Model '_Parameterfile' '.m'], 'w');


%Header for Parafile
Header=['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' '\n%%%%%%%%%%%%%%%%%%%%\t\tParameter File for ' Model '\t\t%%%%%%%%%%%%%%%%%%%%\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' '\n\n'];
fprintf(fileID,Header);


LenghtPARADATA = length(PARADATA);

BlocknameOld='';


for i=1:LenghtPARADATA
    
Blockname=PARADATA{i,1};

%Write Blockheader if Parameters of new Blocks are written
if (strcmp(Blockname,BlocknameOld)==0)
    Blockheader=['\n%%%% ' Blockname '\n\n'];
    fprintf(fileID,Blockheader);
end

Paradescription=PARADATA{i,2};

Paravar=PARADATA{i,3};

Paravalue=PARADATA{i,4};

%check if string starts with '
if strcmp(Paravalue(1),'''')
    ParavalueText=strcat(Paravalue,');\n\n')
else
    ParavalueText=strcat('''',num2str(Paravalue),''');\n\n')
end

InitText=strcat('\t%% ',Paradescription,'\n\t','set_param(''',Blockname,''',''',Paravar,''',',ParavalueText);

fprintf(fileID,InitText);

BlocknameOld=Blockname;
end


fclose(fileID);

end