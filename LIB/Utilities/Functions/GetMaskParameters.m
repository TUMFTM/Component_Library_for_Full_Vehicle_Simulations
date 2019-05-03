
function [Output] = GetMaskParameters(Model)
% Designed by: Alexander Koch (FTM, Technical University of Munich)
% Created on: 01.05.2018, Version: Matlab2018b
% ------------------------------------------------------------------------
% Description: Gets all Mask Parameters of a Simulink Simulation Model. The 
%results will be stored in the output.
% ------------------------------------------------------------------------
% Input:    - Model: Name of the model
% ------------------------------------------------------------------------
% Output:   - All mask parameters of the Model
% ------------------------------------------------------------------------
%Funktion kann nicht unter einer Maske weitere Masken finden
%TODO

%Laden des Modells
load_system(Model);

%Auflisten aller Blöcke
BlockPaths = find_system(Model,'LookUnderMasks','all','Type','Block');

%Erstellen einer Cell
 CELL={};

%Anzahl der zu untersuchenden Blöcke
AnzahlBlocks = length(BlockPaths);

%Definition des Korrekturfaktors damit keine leeren Zeilen geschrieben
%werden
K=0;

%Definition eines Zeilenzählers
Z=0;

%ERster Block
for i=1:1:AnzahlBlocks
    
    AktuelleMaske = Simulink.Mask.get(BlockPaths{i, 1})
    
    % Checken ob die Maske von einem Selbstgebauten Block stammt und
    % angezeigt werden soll
    B = isempty({AktuelleMaske.Type});
    if B==0
        A = strcmp({AktuelleMaske.Type},'SB');
    else
        A = 0
    end
    
    if A == 0
        
    %Um keine leeren Zellen zu schreiben    
    K=K+1;
    
    else
    
    %Bestimmung der Parameteranzahl der aktuellen Maske
    AnzahlParameter=AktuelleMaske.numParameters;
    
    %Y Nummer der Zeile, in die geschrieben werden soll, ohne
    %Korrekturfaktor und j
    Y=Z+i;
   
    for j=1:1:AnzahlParameter
        
    CELL{Y+j-1-K,1}=BlockPaths{i, 1};
    CELL{Y+j-1-K,2}= AktuelleMaske.Parameters(1,j).Prompt; %Front Surface [m2]
    CELL{Y+j-1-K,3}= AktuelleMaske.Parameters(1,j).Name; %A_st
    CELL{Y+j-1-K,4}= AktuelleMaske.Parameters(1,j).Value; % FS oder Zahl
    
    %Zähler, wie viele Zeilen beschrieben worden sind
    Z=Z+1;

    end
    %Damit die nächste Zeile direkt unter die vorherige geschrieben wird (i
    %erhäht sich ja auch --> 1 muss abgezogen werden
    Z=Z-1;
    end
    

    
end
Output=CELL

%xlswrite('PARAMETER.xls',CELL)
end