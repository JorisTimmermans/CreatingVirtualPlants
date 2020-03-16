function [Area]                 =   Calculate_Effective_Area(Vertices,Faces,Axis)

switch Axis
    case 'Along'
        vector_obs              =   [1 0 0];
    case 'Cross'
        vector_obs              =   [0 1 0];
end
Vector_obs                      =   vector_obs(ones(size(Faces,1),1),:);

%%
Vertix123                       =   permute(reshape(Vertices(Faces,:),size(Faces,1),3,3), [1 3 2]);
Vector123                       =   diff(Vertix123,[],3);
XYZ                             =   mean(Vertix123,3);


Cross12_13                      =   cross(Vector123(:,:,1),Vector123(:,:,2) ,2);
Dot_cross_obs                   =   dot(  Vector_obs      ,Cross12_13       ,2);
Dot_cross_cross                 =   dot(  Cross12_13      ,Cross12_13       ,2);

A123                            =   sqrt(Dot_cross_cross)/2;
A123_eff                        =   A123.*Dot_cross_obs;

% I                               =   A123_eff>=0;                    % back side of trunk               
% A123_eff(I)                     =   0;                                  
% A123_eff(~I)                    =   -A123_eff(~I);       

Area                            =   [XYZ A123 A123_eff];

