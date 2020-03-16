function [Vector2]  =   rotate_vector_along_axis(Vector,Axis,alpha0)
[theta,alpha1, r1]  =   cart2sph(Axis(:,1),Axis(:,2),Axis(:,3));
alpha2              =   cart2pol(Axis(:,1),Axis(:,2));

x1                  =   Vector(:,1);
y1                  =   Vector(:,2);
z1                  =   Vector(:,3);
% x                   =   Axis(:,1);
% y                   =   Axis(:,2);
% z                   =   Axis(:,3);

%%%%%%%%%%%%%%%%%%%%%% align Axis with x-axis%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [x,y,z]             =   Polygonal_Canopy_rotatecylindrical(x,y,z,'z',-alpha2);
[x1,y1,z1]             =   Polygonal_Canopy_rotatecylindrical(x1,y1,z1,'z',-alpha2);
% [x,y,z]             =   Polygonal_Canopy_rotatecylindrical(x,y,z,'y',-alpha1);
[x1,y1,z1]             =   Polygonal_Canopy_rotatecylindrical(x1,y1,z1,'y',-alpha1);

%%%%%%%%%%%%%%%%%%%%% rotate alpha0 degrees around x axis%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[x1,y1,z1]             =   Polygonal_Canopy_rotatecylindrical(x1,y1,z1,'x',alpha0);
% [x,y,z]             =   Polygonal_Canopy_rotatecylindrical(x,y,z,'x',alpha0);

%%%%%%%%%%%%%%%%%%%%%% align Axis with original orientation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[x1,y1,z1]             =   Polygonal_Canopy_rotatecylindrical(x1,y1,z1,'y',alpha1);
% [x,y,z]             =   Polygonal_Canopy_rotatecylindrical(x,y,z,'y',alpha1);
[x1,y1,z1]             =   Polygonal_Canopy_rotatecylindrical(x1,y1,z1,'z',alpha2);
% [x,y,z]             =   Polygonal_Canopy_rotatecylindrical(x,y,z,'z',alpha2);

Vector2                 =   [x1,y1,z1];