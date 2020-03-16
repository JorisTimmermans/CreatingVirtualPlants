function [ii,vector_d]          =   intersection(Trunk,Polynomial,o,theta_branch,chi_branch)
%Create point inside the trunk (on the internal curvature)
N_trunk                         =   size(Trunk,1);
offset                          =   ceil(o*N_trunk)-1;
a                               =   randperm(N_trunk-offset)+offset;

Vertix_i                        =   [(polyval(Polynomial(:,1),a(1)-1:a(1)+1)	+Trunk(1,1))  ;...
                                     (polyval(Polynomial(:,2),a(1)-1:a(1)+1)    +Trunk(1,2))  ;...
                                     (polyval(Polynomial(:,3),a(1)-1:a(1)+1)    +Trunk(1,3))]';

vertix_i                        =   Vertix_i(2,:);
Vector_i                        =   (Vertix_i(3,:)-Vertix_i(1,:))/2;
vector_i                        =   Vector_i/sqrt(Vector_i*Vector_i');
[theta_trunk,phi_trunk]         =   cart2sph(vector_i(:,1),vector_i(:,2),vector_i(:,3));
chi_trunk                       =   pi/2-phi_trunk*(1-0.1*rand) ;

[x,y,z]                         =   sph2cart(theta_branch,pi/2-chi_branch/180*pi,1);
[x,y,z]                         =   rotatecylindrical(x,y,z,'y',-chi_trunk);
[x,y,z]                         =   rotatecylindrical(x,y,z,'z',theta_trunk);

Vector_d(1)                     =   x;
Vector_d(2)                     =   y;
Vector_d(3)                     =   z;
vector_d                        =   Vector_d/sqrt(Vector_d*Vector_d');      %normalize vector

% Create point outside trunk to which vector is pointing from the inside point

vertix_o                        =   vertix_i + vector_d*10;


%Find the node on the surface which intersects closest with the random Vector%

diffx_i                         =   Trunk(:,1) - vertix_i(:,1);
diffx_o                         =   Trunk(:,1) - vertix_o(:,1);
diffy_i                         =   Trunk(:,2) - vertix_i(:,2);
diffy_o                         =   Trunk(:,2) - vertix_o(:,2);

diffz_i                         =   Trunk(:,3) - vertix_i(:,3);
diffz_o                         =   Trunk(:,3) - vertix_o(:,3);

Li_s                            =   diffx_i.^2 + diffy_i.^2+diffz_o.^2;
Lo_s                            =   diffx_o.^2 + diffy_o.^2+diffz_i.^2;

Added_L_s                       =   Li_s+Lo_s;                                  
                                                                            
Added_L_s                       =   Added_L_s(1:end-8*2,:);                  %Top vertices and bottom do not have 6 neighbours therefor must not be chosen    
[Lmin_s,ii]                     =   min(Added_L_s);                          % find outside point
    