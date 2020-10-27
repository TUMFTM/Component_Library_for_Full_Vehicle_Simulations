function [picturexpos,pictureypos,picturewidth,pictureheight] = CalcBlockPicturePosition(Blockpath,pictureratio,minoffsetrelx,minoffsetrely,minoffsetabsleft,minoffsetabsright)
% Designed by: Benedikt Danquah (FTM, Technical University of Munich)
% Created on: 01.05.2019, Version: Matlab2018b
% ------------------------------------------------------------------------
% Description: Calculating optimal picture position depending on Simulink Block size 
%              and minimum margin size
% ------------------------------------------------------------------------
% Input:    - Blockpath: Name of Model to simulate
%           - pictureratio: ratio of input picture
%           - minoffsetrelx: minmum relative offset from left and right side of block to picture
%           - minoffsetrely: minmum relative offset from bottom and top side of block to picture
%           - minoffsetabsleft: minimum absolute offset between left side of block and picture
%           - minoffsetabsright: minimum absolute offset between right side of block and picture
% ------------------------------------------------------------------------
% Output:    - picturexpos: Picture x position in Simulink Block
%            - pictureypos: Picture y position in Simulink Block
%            - picturewidth: Picture width in Simulink Block
%            - pictureheight: Picture height in Simulink Block
% ------------------------------------------------------------------------
pos=get_param(Blockpath, 'position');                                       %Get Block Position
width=abs((pos(3)-pos(1)));                                                 %Calculate width
height=abs((pos(4)-pos(2)));                                                %Calculate height
heighteff=height*(1-2*minoffsetrely);                                       %Calculate availabel height
widtheff=width-max(width*minoffsetrelx,minoffsetabsleft)-max(width*minoffsetrelx,minoffsetabsright); %Calculate availabel width
if widtheff/heighteff<=pictureratio                                         %Calculate width and hight when space is limited by available width
    picturewidth=widtheff;
    picturexpos=max(width*minoffsetrelx,minoffsetabsleft);
    pictureheight=picturewidth/pictureratio;
    pictureypos=(height-pictureheight)/2;
else 
    pictureheight=heighteff;                                                 %Calculate width and hight when space is limited by available height
    pictureypos=(height-pictureheight)/2;
    picturewidth=pictureheight*pictureratio;
    if minoffsetabsleft>=(width-picturewidth)/2
        picturexpos=minoffsetabsleft;
    elseif minoffsetabsright>=(width-picturewidth)/2
            picturexpos=width-picturewidth-minoffsetabsright;
    else
            picturexpos=(width-picturewidth)/2;
    end                  
end
end




