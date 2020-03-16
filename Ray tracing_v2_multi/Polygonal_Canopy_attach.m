function [Branch_rt, Faces1,Color, Polynomial1,i]= Polygonal_Canopy_attach(Trunk,Faces0,Polynomial0,n_b,l,d,o,n_v)     

Branch_rt   =   zeros(n_v*2*6+1,3,n_b);
Polynomial  =   zeros(5,2,n_b);
i           =   zeros(1,1,n_b);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Orientation of the Branch vertices (hexagonal)%%%%%%%%%%%%%%%%%%%%%%%
Branch0     =   [cos(-180/180*pi) sin(-180/180*pi) 0
                 cos(-120/180*pi) sin(-120/180*pi) 0
                 cos(-060/180*pi) sin(-060/180*pi) 0
                 cos(+000/180*pi) sin(+000/180*pi) 0
                 cos(+060/180*pi) sin(+060/180*pi) 0
                 cos(+120/180*pi) sin(+120/180*pi) 0];
             
for jj=1:n_b
     [ii,vector_d]=Polygonal_Canopy_Intersection(Trunk,Polynomial0,o);
%     intersection
    i(:,:,jj)=ii;                                           
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Neighbors of this node%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [r,c]       =   find(Faces0==i(:,:,jj));                                                 %all vertices with intersection to j
    index_i     =  unique(Faces0(r,:));
    index       =  index_i(index_i~=i(:,:,jj));    
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Branch Parameters Tipping, Curvature  t%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Tip     =   2+18*rand;                                                  %Amount of Tipping of the branch/trunk
        Curv    =   5*rand;                                                     %Curvature of the branch/trunk

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Create Subbranch%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        [Branch,Faces1,Color,Polynomial1(:,:,jj)] =   Polygonal_Canopy_subbranch(Branch0,n_v,l,d,Tip,Curv);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Orientate to vector%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        [alpha1,r]      =           cart2pol(vector_d(:,1),vector_d(:,2));
        [theta,alpha2,r]=           cart2sph(vector_d(:,1),vector_d(:,2),vector_d(:,3));

        x               =           Branch(:,1);
        y               =           Branch(:,2);
        z               =           Branch(:,3);
        
        [x,y,z]         =           Polygonal_Canopy_rotatecylindrical(x,y,z,'z',-alpha1);
        [x,y,z]         =           Polygonal_Canopy_rotatecylindrical(x,y,z,'y',-pi/2+alpha2);
        [x,y,z]         =           Polygonal_Canopy_rotatecylindrical(x,y,z,'z',alpha1);
        Branch_r        =           [x y z];                                      %Branch rotated
%         keyboard
        %%%%%%%%Rotate polynomial%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        N               =           [1:size(Branch)];               
        X               =           polyval(Polynomial1(:,1,jj),N);                %convert to curvature
        Y               =           polyval(Polynomial1(:,2,jj),N);                %convert to curvature
        Z               =           polyval(Polynomial1(:,3,jj),N);                %convert to curvature
        
        [X,Y,Z]         =           Polygonal_Canopy_rotatecylindrical(X,Y,Z,'z',-alpha1);       %rotate curvature
        [X,Y,Z]         =           Polygonal_Canopy_rotatecylindrical(X,Y,Z,'y',-pi/2+alpha2);  %rotate curvature
        [X,Y,Z]         =           Polygonal_Canopy_rotatecylindrical(X,Y,Z,'z',alpha1);        %rotate curvature
        
        warning off
        Polynomial1(:,1,jj) =           polyfit((1:size(X,2)),X,4);                %convert back to polynomial
        Polynomial1(:,2,jj) =           polyfit((1:size(Y,2)),Y,4);                %convert back to polynomial
        Polynomial1(:,3,jj) =           polyfit((1:size(Z,2)),Z,4);                %convert back to polynomial
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Put Branch to height of the node%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Branch_rt(:,:,jj)  =   Branch_r + ones(size(Branch_r,1),1)*Trunk(i(:,:,jj),:);  %Branch rotated + translated
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Put Branch to neighbours of the node to branch%%%%%%%%%%%%%%%%%%%%%%%%
%         keyboard
        T   =   Trunk(index,:) - ones(6,1)*Trunk(ii,:);
        B   =   Branch_rt(2:7,:,jj)-ones(6,1)*Branch_rt(1,:,jj);
        [theta_t,phi_t,r_t] =   cart2sph(T(:,1),T(:,2),T(:,3));
        [theta_b,phi_b,r_b] =   cart2sph(B(:,1),B(:,2),B(:,3));
    
        [theta_ts,j1]           =   sort(theta_t);
        [theta_bs,j2]           =   sort(theta_b);
        B(j2,:)                 =   T(j1,:);
        Branch_rt(2:7,:,jj)     =   B + ones(6,1)*Branch_rt(1,:,jj);
        
        % The trunk is now connected, but not very good (see pictures). The orientation of the start vertix should be
        %added, however.. fornow...
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Draw the Trunk + branches (looking good)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
end