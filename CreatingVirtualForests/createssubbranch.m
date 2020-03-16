function [Trunk_o,Faces,Color,Polynomial] = createssubbranch(Trunk,n,l,d,Tip,Curv)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Angle_d                         =           diff(cart2pol(Trunk(:,1),Trunk(:,2)));
Angle_r                         =           Angle_d(2)/2;
[x,y,z]                         =           rotatecylindrical(Trunk(:,1),...                      Rotating the vertices 
                                                               Trunk(:,2),...                      around the z axis
                                                               Trunk(:,3),...
                                                               'z',Angle_r);
                             
Trunk_o                         =           [0 0 0];                                                %setting 1st node (required by 
Trunk_t                         =           [0 0 0];                                                %delaunay triangulation algorithm)
for j=1:n   
    Trunk_o                     =           [[Trunk_o(:,1)   ;   Trunk(:,1)             ;   x                   ],...
                                             [Trunk_o(:,2)   ;   Trunk(:,2)             ;   y                   ],...
                                             [Trunk_o(:,3)   ;   Trunk(:,3) + (j-1)/n*l ;   z + (j - 1/2)/n*l    ]];
    Trunk_t                     =           [[Trunk_t(:,1)   ;   Trunk(:,1) * (2*j-1)   ;   x*(2*j)             ],...
                                             [Trunk_t(:,2)   ;   Trunk(:,2) * (2*j-1)   ;   y*(2*j)             ],...
                                             [Trunk_t(:,3)   ;   Trunk(:,3) + (j-1)/2   ;   z + (j - 1/2)/2     ]];
end

n2                              =           size(Trunk,1);                                          %For the vertix finding.. we
Tipping                         =           d*exp(((-Trunk_o(:,3)/80) - exp(-80))*Tip);             %Tipping function
Trunk_o(:,1)                    =           Trunk_o(:,1).*Tipping;                                  %tipping of the tree
Trunk_o(:,2)                    =           Trunk_o(:,2).*Tipping;                                  %tipping of the tree

Curvature_base                  =           ((Trunk_o(:,3))/max(Trunk_o(:,3))).^3;
Curvature                       =           (Curv*(Curvature_base)*[1 0 0]) + ...  %Curvature function
                                            (Curv*(Curvature_base)*[0 1 0]);
                        
rand_o                          =           ones (size(Curvature,1),1)*[(2*((rand>0.5)-0.5)) (2*((rand>0.5)-0.5)) 0];
Curvature                       =           Curvature.* rand_o;
Trunk_o                         =           Trunk_o + Curvature;                                    %Curvature of the tree 

warning off
Polynomial                      =           zeros(5,2);
Polynomial(:,1)                 =           polyfit((1:size(Curvature,1))',Curvature(:,1),4);
Polynomial(:,2)                 =           polyfit((1:size(Curvature,1))',Curvature(:,2),4);
Polynomial(:,3)                 =           polyfit((1:size(Curvature,1))',Trunk_o(:,3)  ,4);
Polynomial(5,3)                 =           0;                                                      %(Z starts at zero)
warning on


% Faces                           =           delaunay(Trunk_t(:,1),Trunk_t(:,2),{'QJ'});             %Coupling of the vertices
Faces                           =           delaunay(Trunk_t(:,1),Trunk_t(:,2));             %Coupling of the vertices
% keyboard

% Trunk_o                       =           Trunk_o(2:end,:);                                       %removing the 1st node
% Trunk_t                       =           Trunk_t(2:end,:);                                       %removing the 1st node
% Faces                         =           Faces-1;                                                %removing the 1st node
% Faces                         =           Faces(find(all(Faces')),:);                             %removing the 1st node
% Faces                         =           sortrows(Faces);                                        %removing the 1st node
% Curvature                     =           Curvature(2:end,:);
Color                           =           ones(1,size(Faces,1))'*[0.6 0.2 0.1];                    %creating color 