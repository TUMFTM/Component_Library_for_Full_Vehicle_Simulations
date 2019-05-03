function [ConvMap,X_Vector, ZtoY_Vector]=invert3dMap(MonotonousMap,X_Vector,Y_Vector)
% Designed by: Benedikt Danquah (FTM, Technical University of Munich)
% Created on: 01/2019, Version: Matlab2018b
% ------------------------------------------------------------------------
% Description: Inverts the 3D map.
% ------------------------------------------------------------------------
% Input:    - MonotonousMap:
%           - X_Vector:
%           - Y_Vector:
% ------------------------------------------------------------------------
% Output:   - ConvMap: inverted map
%           - X_Vector:
%           - ZtoY_Vector:
% ------------------------------------------------------------------------

ConvMap=zeros(size(MonotonousMap));
Pmax=max(max(MonotonousMap));
Pmin=min(min(MonotonousMap));
ZtoY_Vector=(Pmin:(Pmax-Pmin)/(size(Y_Vector,2)-1):Pmax);
for OMs=1:size(X_Vector-1,2)
    PelVector=MonotonousMap(OMs,:);
    A=[PelVector',Y_Vector'] ;
    [C,ia,ic] = unique(A(:,1),'rows') ;
    uA = A(ia,:);
    ConvMap(OMs,:)=interp1(uA(:,1),uA(:,2),ZtoY_Vector);
end
ConvMap=fillmissing(ConvMap,'previous',2);
ConvMap=fillmissing(ConvMap,'linear',2);
end