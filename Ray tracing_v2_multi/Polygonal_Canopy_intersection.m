function [ii,vector_d]=Polygonal_Canopy_Intersection(Trunk,Polynomial,o)
%Notation [ii,vector_d]=Intersection_Vectors(Trunk,Polynomial,o)
%Trunk: Shape depicted by the surface points (tube)
%Polynomial: This line denotes the %central line of the shape "Trunk".
%o: Offset
%ii, intersection point on the Surface of Trunk
%vector_d: orientation of the vector which begins in Trunk(ii,:)
%
%The M-file "Intersection_Vectors, calculates 
%-a point on the line "Polynomial". 
%-a vector with random orientation.
%-a point on outside of the Trunk, with the orientation
%-the length of all the nodes in Trunk to these 2 points
%-the node (ii) for which the sum of these lengths is minimum

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Create point on the curvature of the Trunk%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    a                       =   randperm(ceil(size(Trunk,1)*(1-o)))+ceil(o*size(Trunk,1));
%     a(1)                    =   140;
    x1                      =   polyval(Polynomial(:,1),a(1)) +Trunk(1,1);
    y1                      =   polyval(Polynomial(:,2),a(1)) +Trunk(1,2);
    z1                      =   polyval(Polynomial(:,3),a(1)) +Trunk(1,3);   
    
%     z1                      =   a(1)/size(Trunk,1)*max(max(Trunk));
    vertix1                 =   [x1 y1 z1];
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Create random orientation of the branch%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Vector_d                =   [(rand-0.5)*2 (rand-0.5)*2 (rand-0.5)*2];
    [theta_d,phi_d,r]       =   cart2sph(Vector_d(:,1),...
                                         Vector_d(:,2),...
                                         Vector_d(:,3));
    vector_d  =   Vector_d/r;

    %%%%%%%%%%%%%%Find the node on the surface which intersects closest with the random Vector%%%%%%%%%%%%%
    vertix2 =   vertix1 + vector_d*10;
    Vertix  =   [vertix1;vertix2];
    
    
% keyboard
    Diff1   =   Trunk - ones(size(Trunk,1),1)*vertix1;
    L1      =   sqrt(Diff1(:,1).^2 + Diff1(:,2).^2+Diff1(:,3).^2);
    Diff2   =   Trunk - ones(size(Trunk,1),1)*vertix2;
    L2      =   sqrt(Diff2(:,1).^2 + Diff2(:,2).^2+Diff2(:,3).^2);
    Added_L =   L1+L2;
    n2      =   8;                                                              %Top vertices do not have 6 neighbours
                                                                                %and bottom
    Added_L =   Added_L(1:end-n2*2,:);                                          %therefor these can not be chosen    
    [Lmin,ii]=   min(Added_L);                                           %the cutoff for this is at least n2=8;
                                                                                %the cutoff for this is at least n2=8;
    